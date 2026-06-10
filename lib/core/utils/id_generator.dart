import 'package:intl/intl.dart';

/// Gera ID único baseado em timestamp com microssegundos.
/// Formato: 20240608143022123456
String gerarId() {
  final now = DateTime.now();
  final formatter = DateFormat('yyyyMMddHHmmss');
  final base = formatter.format(now);
  final micros = now.microsecond.toString().padLeft(6, '0');
  return '$base$micros';
}

/// Retorna DateTime.now() em UTC para uso no campo updated_at.
DateTime agora() => DateTime.now().toUtc();
