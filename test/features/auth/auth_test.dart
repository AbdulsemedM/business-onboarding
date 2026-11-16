import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:business_onboarding/app.dart';
import 'package:business_onboarding/features/applications/data/application_summary.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/core/router/routes.dart';
import 'package:business_onboarding/features/auth/data/auth_repository.dart';
import 'package:business_onboarding/features/auth/logic/auth_cubit.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_draft_store.dart';
import '../../helpers/sample_data.dart';

/// Behaves like the real repository: signing in opens no application,
/// registering and creating open the new one.
class FakeAuthRepository implements AuthRepository {
  bool signedIn = false;
  AppFailure? failure;
  final expired = StreamController<void>.broadcast();
  RegistrationForm? registered;
  String? createdBusiness;

  /// The account's applications, newest first.
  List<ApplicationSummary> apps = [
    const ApplicationSummary(
      id: 'app-1',
      businessName: 'Corner Market',
      status: ApplicationStatus.draft,
    ),
  ];

  /// The open application (only while signed in).
  String? openApplication = 'app-1';

  @override
  Future<bool> hasSession() async => signedIn;

  @override
  Future<String?> applicationId() async => signedIn ? openApplication : null;

  @override
  Future<SignInResult> login({
    required String email,
    required String password,
  }) async {
    if (failure != null) throw failure!;
    signedIn = true;
    openApplication = null;
    return SignInResult.needsApplication;
  }

  @override
  Future<SignInResult> register(RegistrationForm form) async {
    if (failure != null) throw failure!;
    registered = form;
    signedIn = true;
    await createApplication(form.businessName);
    return SignInResult.ready;
  }

  @override
  Future<List<ApplicationSummary>> listApplications() async {
    if (failure != null) throw failure!;
    return apps;
  }

  @override
  Future<void> selectApplication(String applicationId) async =>
      openApplication = applicationId;

  @override
  Future<void> createApplication(String businessName) async {
    if (failure != null) throw failure!;
    createdBusiness = businessName;
    final id = 'app-${apps.length + 1}';
    apps = [
      ApplicationSummary(
        id: id,
        businessName: businessName,
        status: ApplicationStatus.draft,
      ),
      ...apps,
    ];
    openApplication = id;
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
      expect: () => [
        const AuthState(status: AuthStatus.signedIn, applicationId: 'app-1'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'a saved session without an open application shows the list',
      build: () => AuthCubit(
        repository: FakeAuthRepository()
          ..signedIn = true
          ..openApplication = null,
      ),
      act: (cubit) => cubit.check(),
      expect: () => [const AuthState(status: AuthStatus.needsApplication)],
    );

    blocTest<AuthCubit, AuthState>(
      'login opens no application: the agent picks one',
      build: () => AuthCubit(repository: FakeAuthRepository()),
      act: (cubit) => cubit.login(email: 'a@b.co', password: 'x'),
      expect: () => [
        const AuthState(busy: true),
        const AuthState(status: AuthStatus.needsApplication),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'selecting an application opens it',
      build: () => AuthCubit(repository: FakeAuthRepository()..signedIn = true),
      act: (cubit) => cubit.selectApplication('app-9'),
      expect: () => [
        const AuthState(status: AuthStatus.signedIn, applicationId: 'app-9'),
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

    testWidgets('signing in shows the list, and a tap opens one', (
      tester,
    ) async {
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

      expect(find.text('My applications'), findsOneWidget);
      await tester.tap(find.text('Corner Market'));
      await tester.pumpAndSettle();

      expect(auth.openApplication, 'app-1');
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

    testWidgets('an account without applications starts one', (tester) async {
      auth
        ..signedIn = true
        ..apps = []
        ..openApplication = null;
      await open(tester);

      expect(find.text('No applications yet'), findsOneWidget);
      await tester.tap(find.text('New application'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), ' Corner Market ');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(auth.createdBusiness, 'Corner Market');
      expect(find.text('Start application'), findsOneWidget);
    });

    testWidgets('each application keeps its own draft', (tester) async {
      auth
        ..signedIn = true
        ..apps = [
          const ApplicationSummary(id: 'app-2', businessName: 'Second Shop'),
          ...auth.apps,
        ];
      store = FakeDraftStore(
        const OnboardingDraft(business: completeStep1, applicationId: 'app-1'),
      );
      await open(tester);
      expect(find.text('Continue application'), findsOneWidget);

      Future<void> openFromList(String name) async {
        await tester.ensureVisible(find.text('My applications'));
        await tester.tap(find.text('My applications'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
      }

      await openFromList('Second Shop');
      expect(find.text('Start application'), findsOneWidget);

      await openFromList('Corner Market');
      expect(find.text('Continue application'), findsOneWidget);
      expect(store.drafts['app-1']?.business, completeStep1);
    });

    testWidgets('sign out asks, then clears every draft', (tester) async {
      auth
        ..signedIn = true
        ..openApplication = null;
      store = FakeDraftStore(
        const OnboardingDraft(business: completeStep1, applicationId: 'app-1'),
      );
      await open(tester);

      await tester.tap(find.byTooltip('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
      await tester.pumpAndSettle();

      expect(store.drafts, isEmpty);
      expect(auth.signedIn, isFalse);
      expect(
        find.text('Sign in to continue your agent application.'),
        findsOneWidget,
      );
    });

    testWidgets('drafts of applications not on the account are removed', (
      tester,
    ) async {
      auth
        ..signedIn = true
        ..openApplication = null;
      store = FakeDraftStore()
        ..drafts['old'] = const OnboardingDraft(applicationId: 'old')
        ..drafts['app-1'] = const OnboardingDraft(applicationId: 'app-1');
      await open(tester);

      expect(find.text('Corner Market'), findsOneWidget);
      expect(store.drafts.keys, ['app-1']);
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
