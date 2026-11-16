import 'dart:convert';

import 'package:business_onboarding/core/api/api_client.dart';
import 'package:business_onboarding/core/api/interceptors/error_interceptor.dart';
import 'package:business_onboarding/core/config/app_config.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/core/storage/session_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers requests from [handler] and records them. No network.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late InMemorySessionStore session;
  late int expiredCount;

  Dio client(_FakeAdapter adapter) {
    final dio = createApiClient(
      config: const AppConfig(apiBaseUrl: 'https://api.test'),
      sessionStore: session,
      onSessionExpired: () => expiredCount++,
    );
    dio.httpClientAdapter = adapter;
    return dio;
  }

  setUp(() {
    session = InMemorySessionStore(
      const Session(
        accessToken: 'old',
        refreshToken: 'r1',
        applicationId: 'app-1',
      ),
    );
    expiredCount = 0;
  });

  test('adds the token and the application header', () async {
    final adapter = _FakeAdapter((_) => _json(200, {'data': {}}));
    await client(adapter).get<dynamic>('/api/v1/partner/applications/app-1');

    final sent = adapter.requests.single;
    expect(sent.headers['Authorization'], 'Bearer old');
    expect(sent.headers['X-Onboarding-Application-Id'], 'app-1');
  });

  test('refreshes once on 401 and retries with the new token', () async {
    final adapter = _FakeAdapter((o) {
      if (o.path.endsWith('/auth/refresh')) {
        return _json(200, {
          'data': {'accessToken': 'new', 'refreshToken': 'r2'},
        });
      }
      return o.headers['Authorization'] == 'Bearer new'
          ? _json(200, {
              'data': {'ok': true},
            })
          : _json(401, {'message': 'expired'});
    });

    final response = await client(
      adapter,
    ).get<dynamic>('/api/v1/partner/applications');

    expect(dataOf(response), {'ok': true});
    expect((await session.read())?.accessToken, 'new');
    expect((await session.read())?.refreshToken, 'r2');
    // The application id survives a token refresh.
    expect((await session.read())?.applicationId, 'app-1');
    expect(expiredCount, 0);
  });

  test('signs out when the refresh is refused', () async {
    final adapter = _FakeAdapter((o) => _json(401, {'message': 'nope'}));

    await expectLater(
      client(adapter).get<dynamic>('/api/v1/partner/applications'),
      throwsA(isA<DioException>()),
    );
    expect(await session.read(), isNull);
    expect(expiredCount, 1);
  });

  test(
    'a wrong password on login is not treated as an expired session',
    () async {
      final adapter = _FakeAdapter((_) => _json(401, {'message': 'bad'}));

      final error = await client(adapter)
          .post<dynamic>('/api/v1/auth/login', data: {})
          .then<Object?>((_) => null, onError: (Object e) => e);

      expect(failureFrom(error!), const AppFailure.unauthorized());
      expect(expiredCount, 0);
      expect(await session.read(), isNotNull);
    },
  );

  group('readable validation reasons', () {
    Future<AppFailure> failureFor(Object body, [int status = 400]) async {
      final adapter = _FakeAdapter((_) => _json(status, body));
      try {
        await client(
          adapter,
        ).post<dynamic>('/api/v1/partner/applications/app-1/submit');
      } catch (error) {
        return failureFrom(error);
      }
      fail('Expected an error');
    }

    test('field errors become "field: reason"', () async {
      expect(
        await failureFor({
          'errorCode': 'VALIDATION_ERROR',
          'validationErrors': {
            'businessLocationAddress.city': 'must not be blank',
          },
        }),
        const AppFailure.validation(
          messages: ['Business location address city: must not be blank'],
        ),
      );
    });

    test('technical BAD_REQUEST messages are hidden', () async {
      expect(
        await failureFor({
          'errorCode': 'BAD_REQUEST',
          'message': 'Cannot map `null` into type `short` (com.fastpay...)',
        }),
        const AppFailure.validation(),
      );
    });

    test('a business-rule message is shown', () async {
      expect(
        await failureFor({
          'errorCode': 'DUPLICATE',
          'message': 'An account with this email already exists.',
        }, 409),
        const AppFailure.validation(
          messages: ['An account with this email already exists.'],
        ),
      );
    });
  });

  test('only HTTPS base URLs are allowed', () {
    expect(
      () => createApiClient(
        config: const AppConfig(apiBaseUrl: 'http://api.test'),
        sessionStore: session,
        onSessionExpired: () {},
      ),
      throwsArgumentError,
    );
  });
}
