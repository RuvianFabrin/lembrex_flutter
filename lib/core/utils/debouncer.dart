import 'dart:async';

/// Debouncer para auto-save: aguarda [delay] de inatividade antes de chamar a ação.
/// Chame [flush] no dispose() para garantir que a última edição não se perde.
class Debouncer {
  final Duration delay;
  Timer? _timer;
  VoidCallback? _pendingAction;

  Debouncer({this.delay = const Duration(milliseconds: 800)});

  void call(VoidCallback action) {
    _pendingAction = action;
    _timer?.cancel();
    _timer = Timer(delay, () {
      _pendingAction?.call();
      _pendingAction = null;
    });
  }

  /// Executa imediatamente qualquer ação pendente e cancela o timer.
  void flush() {
    _timer?.cancel();
    _timer = null;
    _pendingAction?.call();
    _pendingAction = null;
  }

  void dispose() {
    flush();
  }
}

typedef VoidCallback = void Function();
