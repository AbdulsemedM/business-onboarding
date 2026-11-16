/// Lets the visible step screen tell the wizard shell whether the user can
/// move on. The shell calls [validate] when Next is pressed.
///
/// A step screen registers in `initState` and unregisters in `dispose`.
class StepValidation {
  bool Function()? _validator;

  void register(bool Function() validator) => _validator = validator;

  void unregister(bool Function() validator) {
    if (identical(_validator, validator)) _validator = null;
  }

  /// Steps that have not registered a validator are always valid.
  bool validate() => _validator?.call() ?? true;
}
