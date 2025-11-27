import 'dart:async';
import 'package:flutter/foundation.dart';

/// A debouncer class that delays the execution of a function until after
/// a specified duration has elapsed since the last time it was invoked.
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  /// Runs the action after the debounce duration has elapsed.
  /// If called again before the duration elapses, the timer is reset.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels the debouncer if it's active.
  void cancel() {
    _timer?.cancel();
  }

  /// Disposes of the debouncer and cancels any pending timers.
  void dispose() {
    _timer?.cancel();
  }
}
