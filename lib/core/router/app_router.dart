import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/ui/welcome_screen.dart';
import '../../features/onboarding/data/models/onboarding_step.dart';
import '../../features/onboarding/review/ui/review_screen.dart';
import '../../features/onboarding/status/ui/status_screen.dart';
import '../../features/onboarding/step1_business/ui/step1_business_screen.dart';
import '../../features/onboarding/step2_documents/ui/step2_documents_screen.dart';
import '../../features/onboarding/step3_compliance/ui/step3_compliance_screen.dart';
import '../../features/onboarding/ui/wizard_shell.dart';
import 'routes.dart';

GoRouter createAppRouter({String initialLocation = Routes.welcome}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
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
        builder: (context, state) => const StatusScreen(),
      ),
    ],
  );
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
