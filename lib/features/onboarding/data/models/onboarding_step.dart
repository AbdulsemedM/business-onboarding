/// The wizard steps, in order.
enum OnboardingStep {
  business,
  documents,
  compliance,
  review;

  bool get isFirst => index == 0;
  bool get isLast => index == values.length - 1;

  /// 1-based position, for display.
  int get number => index + 1;

  OnboardingStep? get next => isLast ? null : values[index + 1];
  OnboardingStep? get previous => isFirst ? null : values[index - 1];
}
