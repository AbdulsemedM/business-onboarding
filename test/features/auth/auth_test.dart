import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/core/router/routes.dart';
import 'package:business_onboarding/features/auth/data/auth_repository.dart';
import 'package:business_onboarding/features/auth/logic/auth_cubit.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_draft_store.dart';
import '../../helpers/sample_data.dart';

class FakeAuthRepository implements AuthRepository {
  bool signedIn = false;
  bool hasApplication = true;
  AppFailure? failure;
  final expired = StreamController<void>.broadcast();
  RegistrationForm? registered;
  String? createdBusiness;

  @override
  Future<bool> hasSession() async => signedIn;

  @override
  Future<bool> needsApplication() async => !hasApplication;

  String application = 'app-1';

  @override
  Future<String?> applicationId() async => hasApplication ? application : null;

  @override
  Future<SignInResult> login({
    required String email,
    required String password,
  }) async {
    if (failure != null) throw failure!;
    signedIn = true;
    return hasApplication ? SignInResult.ready : SignInResult.needsApplication;
  }

  @override
  Future<SignInResult> register(RegistrationForm form) async {
    if (failure != null) throw failure!;
    registered = form;
    signedIn = true;
    return SignInResult.ready;
  }

  @override
  Future<void> createApplication(String businessName) async {
    if (failure != null) throw failure!;
    createdBusiness = businessName;
    hasApplication = true;
  }

  @override
  Future<void> logout() async => signedIn = false;

  @override
  Stream<void> get sessionExpired => expired.stream;
}

void main() {
  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'a saved session is signed in',
      build: () => AuthCubit(repository: FakeAuthRepository()..signedIn = true),
      act: (cubit) => cubit.check(),
      expect: () => [const AuthState(status: AuthStatus.signedIn)],
    );

    blocTest<AuthCubit, AuthState>(
      'login without an application asks for one',
      build: () =>
          AuthCubit(repository: FakeAuthRepository()..hasApplication = false),
      act: (cubit) => cubit.login(email: 'a@b.co', password: 'x'),
      expect: () => [
        const AuthState(busy: true),
        const AuthState(status: AuthStatus.needsApplication),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'a failed login keeps the reason',
      build: () => AuthCubit(
        repository: FakeAuthRepository()
          ..failure = const AppFailure.unauthorized(),
      ),
      act: (cubit) => cubit.login(email: 'a@b.co', password: 'x'),
      expect: () => [
        const AuthState(busy: true),
        const AuthState(failure: AppFailure.unauthorized()),
      ],
    );

    test('an expired session signs out and says why', () async {
      final repository = FakeAuthRepository()..signedIn = true;
      final cubit = AuthCubit(repository: repository);
      await cubit.check();

      repository.expired.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        const AuthState(status: AuthStatus.signedOut, sessionExpired: true),
      );
      await cubit.close();
    });
  });

  group('screens', () {
    late FakeAuthRepository auth;
    late FakeDraftStore store;

    Future<void> open(
      WidgetTester tester, {
      String location = Routes.welcome,
    }) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        App(draftStore: store, authRepository: auth, initialLocation: location),
      );
      await tester.pumpAndSettle();
    }

    setUp(() {
      auth = FakeAuthRepository();
      store = FakeDraftStore();
    });

    testWidgets('signed out users land on Sign in', (tester) async {
      await open(tester, location: Routes.status);
      expect(
        find.text('Sign in to continue your agent application.'),
        findsOneWidget,
      );
    });

    testWidgets('signing in opens Welcome', (tester) async {
      await open(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email address'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'me@shop.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Start application'), findsOneWidget);
    });

    testWidgets('a wrong password is explained', (tester) async {
      auth.failure = const AppFailure.unauthorized();
      await open(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'me@shop.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'bad',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(
        find.text("That email and password don't match. Try again."),
        findsOneWidget,
      );
    });

    testWidgets('an account without an application names its business', (
      tester,
    ) async {
      auth
        ..signedIn = true
        ..hasApplication = false;
      await open(tester);

      expect(find.text('Name your business'), findsOneWidget);
      await tester.enterText(find.byType(TextField), ' Corner Market ');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(auth.createdBusiness, 'Corner Market');
      expect(find.text('Start application'), findsOneWidget);
    });

    testWidgets('sign out asks, then clears the draft', (tester) async {
      auth.signedIn = true;
      store = FakeDraftStore(const OnboardingDraft(business: completeStep1));
      await open(tester);

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
      await tester.pumpAndSettle();

      expect(store.stored, isNull);
      expect(auth.signedIn, isFalse);
      expect(
        find.text('Sign in to continue your agent application.'),
        findsOneWidget,
      );
    });

    testWidgets("another account's draft is discarded on sign-in", (
      tester,
    ) async {
      auth.signedIn = true;
      store = FakeDraftStore(
        const OnboardingDraft(business: completeStep1, applicationId: 'old'),
      );
      await open(tester);

      expect(store.stored?.applicationId, 'app-1');
      expect(store.stored?.business, isNot(completeStep1));
      expect(find.text('Start application'), findsOneWidget);
    });

    testWidgets('the same account keeps its draft', (tester) async {
      auth.signedIn = true;
      store = FakeDraftStore(
        const OnboardingDraft(business: completeStep1, applicationId: 'app-1'),
      );
      await open(tester);

      expect(store.stored?.business, completeStep1);
      expect(find.text('Continue application'), findsOneWidget);
    });

    testWidgets('back on Create account returns to Sign in', (tester) async {
      await open(tester, location: Routes.register);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(
        find.text('Sign in to continue your agent application.'),
        findsOneWidget,
      );
    });

    testWidgets('register checks the password rules', (tester) async {
      await open(tester, location: Routes.register);

      await tester.enterText(
        find.widgetWithText(TextField, 'First name'),
        'Alex',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Last name'),
        'Owner',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Business name'),
        'Corner Market',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'alex@shop.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Mobile phone'),
        validUsPhone,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'weak',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'weak',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pumpAndSettle();
      expect(auth.registered, isNull);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'SecurePass123!',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'SecurePass123!',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pumpAndSettle();

      expect(auth.registered?.phoneNumber, '+16502530000');
      expect(auth.registered?.businessName, 'Corner Market');
      expect(find.text('Start application'), findsOneWidget);
    });
  });
}
