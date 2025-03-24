import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;
  final ValueNotifier<bool> _isRunning = ValueNotifier(false);

  ValueListenable<bool> get isRunning => _isRunning;

  Debouncer({required this.delay});

  void call(void Function() callback) {
    _timer?.cancel();
    _isRunning.value = true;
    _timer = Timer(delay, () {
      callback();
      _isRunning.value = false;
    });
  }

  void dispose() {
    _timer?.cancel();
    _isRunning.dispose();
  }
}
