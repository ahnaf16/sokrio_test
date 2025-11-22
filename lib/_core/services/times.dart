import 'dart:async';
import 'dart:ui';

class Throttler {
  Throttler(this.interval);
  final Duration interval;

  VoidCallback? _action;
  Timer? _timer;

  void call(VoidCallback action, {bool immediateCall = false}) {
    _action = action;
    if (_timer == null) {
      if (immediateCall) {
        _action?.call();
        _action = null;
      }
      _timer = Timer(interval, () {
        _action?.call();
        _action = null;
        _timer = null;
      });
    }
  }

  void cancelPending() {
    _action = null;
    _timer?.cancel();
    _timer = null;
  }
}
