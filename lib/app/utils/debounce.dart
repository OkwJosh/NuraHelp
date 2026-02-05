import 'dart:async';
import 'package:flutter/material.dart';

/// Debounce utility class to delay function execution
/// Useful for search inputs, API calls, etc.
class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({required this.delay});

  /// Call the function after delay
  /// Cancels previous timer if called again before delay completes
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel the pending timer
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose and clean up
  void dispose() {
    _timer?.cancel();
  }
}

/// Debounce for functions with parameters
class DebouncerWithParam<T> {
  final Duration delay;
  Timer? _timer;

  DebouncerWithParam({required this.delay});

  void call(void Function(T) action, T param) {
    _timer?.cancel();
    _timer = Timer(delay, () => action(param));
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Extension on TextEditingController for easy debouncing
extension DebouncedTextController on TextEditingController {
  /// Listen to text changes with debounce
  void addDebouncedListener({
    required Duration delay,
    required void Function(String) onChanged,
  }) {
    final debounce = Debounce(delay: delay);
    addListener(() {
      debounce.call(() => onChanged(text));
    });
  }
}
