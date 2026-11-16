import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/logic/auth_cubit.dart';
import '../../features/auth/ui/business_name_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/register_screen.dart';
import '../../features/auth/ui/welcome_screen.dart';
import '../../features/onboarding/data/models/application_status.dart';
import '../../features/onboarding/data/models/onboarding_step.dart';
import '../../features/onboarding/review/ui/review_screen.dart';
import '../../features/onboarding/status/ui/status_screen.dart';
import '../../features/onboarding/step1_business/ui/step1_business_screen.dart';
import '../../features/onboarding/step2_documents/ui/step2_documents_screen.dart';
import '../../features/onboarding/step3_compliance/ui/step3_compliance_screen.dart';
import '../../features/onboarding/ui/wizard_shell.dart';
import 'routes.dart';

GoRouter createAppRouter({
  required AuthCubit auth,
  String initialLocation = Routes.welcome,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: _StreamListenable(auth.stream),
    redirect: (context, state) => _redirect(auth.state.status, state),
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.businessName,
        builder: (context, state) => const BusinessNameScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            WizardShell(step: _stepFor(state.uri.path), child: child),
        routes: [
          for (final step in OnboardingStep.values)
            GoRoute(
              path: step.path,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: _screenFor(step)),
            ),
        ],
      ),
      GoRoute(
        path: Routes.status,
        builder: (context, state) => StatusScreen(
          // Passed right after a submit, so the screen needn't reload.
          initial: state.extra is ApplicationSnapshot
              ? state.extra! as ApplicationSnapshot
              : null,
        ),
      ),
    ],
  );
}

/// Signed-out users only see the sign-in screens; an account without an
/// application must name its business first.
String? _redirect(AuthStatus status, GoRouterState state) {
  final location = state.matchedLocation;
  final onSignIn = location == Routes.login || location == Routes.register;
  return switch (status) {
    // Still reading the saved session: stay put (Welcome shows a spinner).
    AuthStatus.unknown => null,
    AuthStatus.signedOut => onSignIn ? null : Routes.login,
    AuthStatus.needsApplication =>
      location == Routes.businessName ? null : Routes.businessName,
    AuthStatus.signedIn =>
      onSignIn || location == Routes.businessName ? Routes.welcome : null,
  };
}

/// Lets the router re-check [_redirect] whenever the auth state changes.
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

OnboardingStep _stepFor(String path) => OnboardingStep.values.firstWhere(
  (step) => step.path == path,
  orElse: () => OnboardingStep.business,
);

Widget _screenFor(OnboardingStep step) => switch (step) {
  OnboardingStep.business => const Step1BusinessScreen(),
  OnboardingStep.documents => const Step2DocumentsScreen(),
  OnboardingStep.compliance => const Step3ComplianceScreen(),
  OnboardingStep.review => const ReviewScreen(),
};
