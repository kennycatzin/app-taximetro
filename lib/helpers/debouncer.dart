import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;
  void Function(T value)? onValue;
  Timer? _timer;

  set value(T val) {
    _timer?.cancel();
    _timer = Timer(duration, () => onValue?.call(val));
  }
}
