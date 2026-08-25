import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class ProductHtmlSanitizer {
  const ProductHtmlSanitizer._();

  static String sanitize(String rawHtml) {
    final value = rawHtml.trim();

    if (value.isEmpty || value.toLowerCase() == 'null') {
      return '';
    }

    try {
      final document = html_parser.parse(value);

      _cleanInlineStyles(document);
      _cleanStyleBlocks(document);

      return document.body?.innerHtml.trim() ?? value;
    } catch (error) {


      return _fallbackSanitize(value);
    }
  }

  static void _cleanInlineStyles(dom.Document document) {
    for (final element in document.querySelectorAll('[style]')) {
      final inlineStyle = element.attributes['style'];

      if (inlineStyle == null || inlineStyle.trim().isEmpty) {
        continue;
      }

      final safeDeclarations = inlineStyle
          .split(';')
          .map((declaration) => declaration.trim())
          .where((declaration) => declaration.isNotEmpty)
          .where(_isSafeDeclaration)
          .toList();

      if (safeDeclarations.isEmpty) {
        element.attributes.remove('style');
      } else {
        element.attributes['style'] =
        '${safeDeclarations.join('; ')};';
      }
    }
  }

  static bool _isSafeDeclaration(String declaration) {
    final separatorIndex = declaration.indexOf(':');

    if (separatorIndex <= 0) {
      return true;
    }

    final property = declaration
        .substring(0, separatorIndex)
        .trim()
        .toLowerCase();

    return property != 'font-feature-settings' &&
        property != '-webkit-font-feature-settings' &&
        property != '-moz-font-feature-settings' &&
        property != 'font-variation-settings';
  }

  static void _cleanStyleBlocks(dom.Document document) {
    for (final styleElement in document.querySelectorAll('style')) {
      var css = styleElement.text;

      css = css.replaceAll(
        RegExp(
          r'(?:-webkit-|-moz-)?font-feature-settings\s*:\s*[^;}]*;?',
          caseSensitive: false,
        ),
        '',
      );

      css = css.replaceAll(
        RegExp(
          r'font-variation-settings\s*:\s*[^;}]*;?',
          caseSensitive: false,
        ),
        '',
      );

      styleElement.text = css;
    }
  }

  static String _fallbackSanitize(String html) {
    return html
        .replaceAll(
      RegExp(
        r'(?:-webkit-|-moz-)?font-feature-settings\s*:\s*[^;}]*;?',
        caseSensitive: false,
      ),
      '',
    )
        .replaceAll(
      RegExp(
        r'font-variation-settings\s*:\s*[^;}]*;?',
        caseSensitive: false,
      ),
      '',
    );
  }
}