import 'dart:convert';
import 'dart:typed_data';

class QRUtils {
  static String normalizeBase64(String input, {bool keepUrlSafe = false}) {
    var s = input.trim();

    if ((s.startsWith('"') && s.endsWith('"')) || 
        (s.startsWith("'") && s.endsWith("'"))) {
      s = s.substring(1, s.length - 1);
    }

    try {
      if (s.contains('%')) s = Uri.decodeFull(s);
    } catch (_) {}

    final commaIndex = s.indexOf(',');
    if (s.startsWith('data:') && commaIndex != -1) {
      s = s.substring(commaIndex + 1);
    }

    s = s.replaceAll(r'\n', '').replaceAll(r'\r', '').replaceAll(r'\t', '');
    s = s.replaceAll(RegExp(r'\s+'), '');
    s = s.replaceAll('\u200B', '').replaceAll('\uFEFF', '');

    if (!keepUrlSafe) {
      s = s.replaceAll('-', '+').replaceAll('_', '/');
    }

    s = s.replaceAll(RegExp(r'[^A-Za-z0-9\+/=_-]'), '');
    s = s.replaceAll('=', '');
    final pad = (4 - (s.length % 4)) % 4;
    return s + ('=' * pad);
  }

  static Uint8List decodeBase64Robust(String raw) {
    final normalized = normalizeBase64(raw, keepUrlSafe: false);
    try {
      return base64Decode(normalized);
    } on FormatException {
      final urlLike = normalizeBase64(raw, keepUrlSafe: true).replaceAll('=', '');
      return base64Url.decode(urlLike);
    }
  }

  static String detectMime(Uint8List b) {
    if (b.length >= 12 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) {
      return 'image/png';
    }
    if (b.length >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (b.length >= 12 && b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 &&
        b[8] == 0x57 && b[9] == 0x45 && b[10] == 0x42 && b[11] == 0x50) {
      return 'image/webp';
    }
    if (b.length >= 6 && b[0] == 0x47 && b[1] == 0x49 && b[2] == 0x46) {
      return 'image/gif';
    }
    return 'image/png';
  }

  static String buildDataUri(String normalizedBase64, String mime) {
    return 'data:$mime;base64,$normalizedBase64';
  }
}