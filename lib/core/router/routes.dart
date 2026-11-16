import '../../features/onboarding/data/models/onboarding_step.dart';

abstract final class Routes {
  static const welcome = '/';
  static const status = '/status';
  static const login = '/login';
  static const register = '/register';
  static const applications = '/applications';
  static const businessName = '/business-name';
  static const onboarding = '/onboarding';
}

extension OnboardingStepRoute on OnboardingStep {
  String get path => '${Routes.onboarding}/$name';
}
