// Clipboard de imagem para Desktop (Windows e Linux).
//
// Windows → Win32 FFI puro (user32.dll / kernel32.dll), sem super_native_extensions
//   e sem TSF. Em Dart, variáveis top-level final são lazy: as DLLs só são
//   abertas na 1ª chamada Windows real, portanto este arquivo é seguro em Linux.
//
// Linux → subprocess xclip (X11) ou wl-clipboard (Wayland).
//
// Formatos suportados para LEITURA:
//   1. "PNG"  (formato registrado — copiado pelo próprio app ou por apps que
//              exportam PNG explicitamente, ex: Browsers, GIMP)
//   2. CF_DIBV5 (17) / CF_DIB (8) — formato padrão Windows; usado por Snipping
//              Tool, PrintScreen, Paint, etc. Convertido de BMP→PNG via dart:ui.
//
// Formato de ESCRITA: sempre "PNG" registrado.

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';

// ─── typedefs Win32 ───────────────────────────────────────────────────────────

typedef _OpenClipboardNative = Int32 Function(IntPtr hWnd);
typedef _OpenClipboard = int Function(int hWnd);

typedef _CloseClipboardNative = Int32 Function();
typedef _CloseClipboard = int Function();

typedef _EmptyClipboardNative = Int32 Function();
typedef _EmptyClipboard = int Function();

typedef _GetClipboardDataNative = IntPtr Function(Uint32 uFormat);
typedef _GetClipboardData = int Function(int uFormat);

typedef _SetClipboardDataNative = IntPtr Function(Uint32 uFormat, IntPtr hMem);
typedef _SetClipboardData = int Function(int uFormat, int hMem);

typedef _IsClipboardFormatAvailableNative = Int32 Function(Uint32 format);
typedef _IsClipboardFormatAvailable = int Function(int format);

typedef _RegisterClipboardFormatWNative = Uint32 Function(
    Pointer<Utf16> lpszFormat);
typedef _RegisterClipboardFormatW = int Function(Pointer<Utf16> lpszFormat);

typedef _GlobalAllocNative = IntPtr Function(Uint32 uFlags, IntPtr dwBytes);
typedef _GlobalAlloc = int Function(int uFlags, int dwBytes);

typedef _GlobalFreeNative = IntPtr Function(IntPtr hMem);
typedef _GlobalFree = int Function(int hMem);

typedef _GlobalLockNative = Pointer<NativeType> Function(IntPtr hMem);
typedef _GlobalLock = Pointer<NativeType> Function(int hMem);

typedef _GlobalUnlockNative = Int32 Function(IntPtr hMem);
typedef _GlobalUnlock = int Function(int hMem);

typedef _GlobalSizeNative = IntPtr Function(IntPtr hMem);
typedef _GlobalSize = int Function(int hMem);

// ─── DLLs — top-level final em Dart é lazy ───────────────────────────────────

final _user32 = DynamicLibrary.open('user32.dll');
final _kernel32 = DynamicLibrary.open('kernel32.dll');

// ─── Bindings ────────────────────────────────────────────────────────────────

final _openClipboard =
    _user32.lookupFunction<_OpenClipboardNative, _OpenClipboard>(
        'OpenClipboard');
final _closeClipboard =
    _user32.lookupFunction<_CloseClipboardNative, _CloseClipboard>(
        'CloseClipboard');
final _emptyClipboard =
    _user32.lookupFunction<_EmptyClipboardNative, _EmptyClipboard>(
        'EmptyClipboard');
final _getClipboardData =
    _user32.lookupFunction<_GetClipboardDataNative, _GetClipboardData>(
        'GetClipboardData');
final _setClipboardData =
    _user32.lookupFunction<_SetClipboardDataNative, _SetClipboardData>(
        'SetClipboardData');
final _isClipboardFormatAvailable = _user32.lookupFunction<
    _IsClipboardFormatAvailableNative,
    _IsClipboardFormatAvailable>('IsClipboardFormatAvailable');
final _registerClipboardFormatW = _user32.lookupFunction<
    _RegisterClipboardFormatWNative,
    _RegisterClipboardFormatW>('RegisterClipboardFormatW');

final _globalAlloc =
    _kernel32.lookupFunction<_GlobalAllocNative, _GlobalAlloc>('GlobalAlloc');
final _globalFree =
    _kernel32.lookupFunction<_GlobalFreeNative, _GlobalFree>('GlobalFree');
final _globalLock =
    _kernel32.lookupFunction<_GlobalLockNative, _GlobalLock>('GlobalLock');
final _globalUnlock =
    _kernel32.lookupFunction<_GlobalUnlockNative, _GlobalUnlock>(
        'GlobalUnlock');
final _globalSize =
    _kernel32.lookupFunction<_GlobalSizeNative, _GlobalSize>('GlobalSize');

// ─── Constantes Windows ──────────────────────────────────────────────────────

const _gmemMoveable = 0x0002;
const _cfDib = 8;    // CF_DIB   — BMP sem cabeçalho de arquivo
const _cfDibV5 = 17; // CF_DIBV5 — BMP v5 sem cabeçalho de arquivo

// ─── API pública ─────────────────────────────────────────────────────────────

/// Verifica sincronamente se o clipboard tem imagem (Windows).
/// Cobre PNG registrado, CF_DIBV5 e CF_DIB (screenshots, Paint, etc.).
/// No Linux retorna sempre false — a detecção acontece ao tentar ler.
bool temImagemPngNoClipboard() {
  if (!Platform.isWindows) return false;
  return using((arena) {
    final fmt = _fmtPng(arena);
    return _isClipboardFormatAvailable(fmt) != 0 ||
        _isClipboardFormatAvailable(_cfDibV5) != 0 ||
        _isClipboardFormatAvailable(_cfDib) != 0;
  });
}

/// Lê bytes PNG do clipboard.
/// Retorna null se não houver imagem disponível.
Future<Uint8List?> lerPngDoClipboard() async {
  if (Platform.isWindows) return _lerPngWindows();
  if (Platform.isLinux) return _lerPngLinux();
  return null;
}

/// Escreve bytes PNG no clipboard.
/// Retorna true em caso de sucesso.
Future<bool> escreverPngNoClipboard(Uint8List bytes) async {
  if (Platform.isWindows) return _escreverPngWindows(bytes);
  if (Platform.isLinux) return _escreverPngLinux(bytes);
  return false;
}

// ─── Windows — helpers ───────────────────────────────────────────────────────

int _fmtPng(Arena arena) =>
    _registerClipboardFormatW('PNG'.toNativeUtf16(allocator: arena));

/// Lê um bloco do clipboard e retorna os bytes, sem fechar o clipboard.
/// O caller é responsável por chamar CloseClipboard.
Uint8List? _lerBloco(int format) {
  final hData = _getClipboardData(format);
  if (hData == 0) return null;

  final pData = _globalLock(hData);
  if (pData.address == 0) return null;

  final size = _globalSize(hData);
  if (size == 0) {
    _globalUnlock(hData);
    return null;
  }

  final bytes = Uint8List.fromList(pData.cast<Uint8>().asTypedList(size));
  _globalUnlock(hData);
  return bytes;
}

// ─── Windows — ler ───────────────────────────────────────────────────────────

Future<Uint8List?> _lerPngWindows() async {
  // 1) Tenta formato PNG explícito (copiado pelo app, browsers, GIMP, etc.)
  final pngBytes = _lerFormatoDoPng();
  if (pngBytes != null) return pngBytes;

  // 2) Fallback: CF_DIBV5 / CF_DIB → converte BMP para PNG via dart:ui
  final dib = _lerDib();
  if (dib == null) return null;
  return _dibParaPng(dib);
}

Uint8List? _lerFormatoDoPng() {
  return using((arena) {
    final fmt = _fmtPng(arena);
    if (_isClipboardFormatAvailable(fmt) == 0) return null;
    if (_openClipboard(0) == 0) return null;
    try {
      return _lerBloco(fmt);
    } finally {
      _closeClipboard();
    }
  });
}

Uint8List? _lerDib() {
  final dibFmt = _isClipboardFormatAvailable(_cfDibV5) != 0
      ? _cfDibV5
      : _isClipboardFormatAvailable(_cfDib) != 0
          ? _cfDib
          : 0;
  if (dibFmt == 0) return null;

  if (_openClipboard(0) == 0) return null;
  try {
    return _lerBloco(dibFmt);
  } finally {
    _closeClipboard();
  }
}

// ─── Windows — escrever ──────────────────────────────────────────────────────

bool _escreverPngWindows(Uint8List bytes) {
  return using((arena) {
    final fmt = _fmtPng(arena);

    if (_openClipboard(0) == 0) return false;

    try {
      _emptyClipboard();

      final hMem = _globalAlloc(_gmemMoveable, bytes.length);
      if (hMem == 0) return false;

      final pMem = _globalLock(hMem);
      if (pMem.address == 0) {
        _globalFree(hMem);
        return false;
      }

      // Cópia em bloco (equivalente a memcpy) — sem loop FFI byte a byte.
      pMem.cast<Uint8>().asTypedList(bytes.length).setAll(0, bytes);

      _globalUnlock(hMem);
      // Após SetClipboardData com sucesso o clipboard é dono do hMem.
      return _setClipboardData(fmt, hMem) != 0;
    } finally {
      _closeClipboard();
    }
  });
}

// ─── Conversão DIB → PNG ─────────────────────────────────────────────────────

Future<Uint8List?> _dibParaPng(Uint8List dib) async {
  try {
    if (dib.length < 40) return null;

    final bd = dib.buffer.asByteData();

    // Tamanho do cabeçalho DIB (BITMAPINFOHEADER=40, BITMAPV5HEADER=124, etc.)
    final headerSize = bd.getUint32(0, Endian.little);

    // Número de entradas da tabela de cores
    int colorTableEntries = 0;
    if (dib.length >= 36) {
      final biBitCount = bd.getUint16(14, Endian.little);
      final biClrUsed = bd.getUint32(32, Endian.little);
      if (biClrUsed > 0) {
        colorTableEntries = biClrUsed;
      } else if (biBitCount > 0 && biBitCount <= 8) {
        colorTableEntries = 1 << biBitCount;
      }
    }

    // Offset do início dos pixels no arquivo BMP (cabeçalho de arquivo + DIB)
    final pixelOffset = 14 + headerSize + colorTableEntries * 4;
    final fileSize = 14 + dib.length;

    final bmp = Uint8List(fileSize);
    final bmpBd = bmp.buffer.asByteData();
    bmpBd.setUint16(0, 0x4D42, Endian.little); // 'BM'
    bmpBd.setUint32(2, fileSize, Endian.little);
    bmpBd.setUint32(6, 0, Endian.little);
    bmpBd.setUint32(10, pixelOffset, Endian.little);
    bmp.setAll(14, dib);

    final codec = await ui.instantiateImageCodec(bmp);
    final frame = await codec.getNextFrame();
    final byteData =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}

// ─── Linux ───────────────────────────────────────────────────────────────────

Future<Uint8List?> _lerPngLinux() async {
  try {
    final r = await Process.run(
      'xclip',
      ['-selection', 'clipboard', '-t', 'image/png', '-o'],
      stdoutEncoding: null,
    );
    if (r.exitCode == 0) {
      final data = r.stdout as List<int>;
      if (data.isNotEmpty) return Uint8List.fromList(data);
    }
  } catch (_) {}

  try {
    final r = await Process.run(
      'wl-paste',
      ['--type', 'image/png'],
      stdoutEncoding: null,
    );
    if (r.exitCode == 0) {
      final data = r.stdout as List<int>;
      if (data.isNotEmpty) return Uint8List.fromList(data);
    }
  } catch (_) {}

  return null;
}

Future<bool> _escreverPngLinux(Uint8List bytes) async {
  try {
    final p = await Process.start(
      'xclip',
      ['-selection', 'clipboard', '-t', 'image/png', '-i'],
    );
    p.stdin.add(bytes);
    await p.stdin.close();
    if (await p.exitCode == 0) return true;
  } catch (_) {}

  try {
    final p = await Process.start('wl-copy', ['--type', 'image/png']);
    p.stdin.add(bytes);
    await p.stdin.close();
    if (await p.exitCode == 0) return true;
  } catch (_) {}

  return false;
}
