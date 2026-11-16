import 'dart:async';

/// Runs the most recent action once [delay] has passed without a new call.
class Debouncer {
  Debouncer(this.delay);

  final Duration delay;
  Timer? _timer;
  void Function()? _pending;

  bool get isPending => _pending != null;

  void run(void Function() action) {
    _timer?.cancel();
    _pending = action;
    _timer = Timer(delay, flush);
  }

  /// Runs the pending action now, if there is one.
  void flush() {
    final action = _pending;
    cancel();
    action?.call();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pending = null;
  }
}
