import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'English.dart';
import 'Korean.dart';

class Messages {
  static const Map<String, Map<String, String>> translations = {
    English.Code: English.translations,
    Korean.Code: Korean.translations,
  };

  static String _replaceParams(String message, Map<String, String> params) {
    return params.entries.fold(message, (prev, entry) =>
        prev.replaceAll('{${entry.key}}', entry.value));
  }

  static List<TextSpan> _parseColoredText(String text) {
    final RegExp colorRegex = RegExp(r'<c=#(\w{6})>(.*?)</c>');
    final List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final Match match in colorRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(2),
        style: TextStyle(color: Color(int.parse('0xFF${match.group(1)}'))),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return spans;
  }

  static String get(String key, {Map<String, String> params = const {}}) {
    final String message = translations[Get.locale?.languageCode]?[key] ?? key;
    return _replaceParams(message, params);
  }

  static List<TextSpan> getSpan(String key, {Map<String, String> params = const {}}) {
    final String message = get(key, params: params);
    final List<TextSpan> textSpans = _parseColoredText(message);
    Logger().i('Message: $message\nSpans: $textSpans');
    return textSpans;
  }
}