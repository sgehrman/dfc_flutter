import 'package:flutter/material.dart';

enum TxtStyle {
  headlineMedium,
  headlineSmall,
  bodySmall,
  bodyLarge,
  bodyMedium,
  titleMedium,
  titleSmall,
  labelSmall
}

class Font {
  static const huge = 24.0;
  static const xlarge = huge - 4;
  static const large = xlarge - 2;
  static const medium = large - 1;
  static const small = medium - 2;
  static const tiny = small - 1;

  static const bold = FontWeight.bold;
  static const normal = FontWeight.normal;
}

const double lightOpacity = 0.7;

class Txt {
  static TextStyle textFieldStyle(BuildContext context) {
    return const TextStyle(
      fontSize: Font.xlarge,
      fontWeight: Font.bold,
    );
  }

  static Color? textColor({
    required BuildContext context,
    Color? color,
    bool lighten = false,
    bool primary = false,
  }) {
    Color? result;

    if (primary) {
      final Color startColor = color ?? Theme.of(context).primaryColor;

      result = lighten ? startColor.withOpacity(lightOpacity) : startColor;
    } else {
      if (color != null) {
        result = lighten ? color.withOpacity(lightOpacity) : color;
      } else {
        result = lighten ? Theme.of(context).textTheme.bodySmall!.color : null;
      }
    }

    return result;
  }

  static Widget sectionHeader(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4, bottom: 10),
      child: Txt.labelSmall(
        text,
      ),
    );
  }

  static Widget txt(
    String? text, {
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    double fontSize = Font.medium,
    bool lighten = false,
    bool bold = false,
    bool center = false,
    double? height,
    Color? color,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text ?? '',
          textAlign: center ? TextAlign.center : null,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? Font.bold : Font.normal,
            color: textColor(
              color: color,
              lighten: lighten,
              context: context,
            ),
            height: height,
          ),
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
        );
      },
    );
  }

  static Widget multiLineTitle(
    String? text, {
    bool center = false,
  }) {
    return Builder(
      builder: (context) {
        return txt(
          text,
          center: center,
          fontSize: Font.large,
          bold: true,
          maxLines: 20,
        );
      },
    );
  }

  static Widget multiLine(
    String? text, {
    bool center = false,
  }) {
    return Builder(
      builder: (context) {
        return txt(
          text,
          lighten: true,
          maxLines: 20,
          center: center,
        );
      },
    );
  }

  static Widget headlineSmall(
    String? text, {
    bool center = false,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.headlineSmall,
      color: color,
      center: center,
    );
  }

  static Widget headlineMedium(
    String? text, {
    bool center = false,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.headlineMedium,
      color: color,
      center: center,
    );
  }

  static Widget titleMedium(
    String? text, {
    bool center = false,
    bool wrap = true,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.titleMedium,
      color: color,
      center: center,
      wrap: wrap,
    );
  }

  static Widget titleSmall(
    String? text, {
    bool center = false,
    bool wrap = true,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.titleSmall,
      color: color,
      center: center,
      wrap: wrap,
    );
  }

  static Widget bodyLarge(
    String? text, {
    bool center = false,
    bool wrap = true,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.bodyLarge,
      color: color,
      center: center,
      wrap: wrap,
    );
  }

  static Widget bodyMedium(
    String? text, {
    bool center = false,
    bool wrap = true,
    Color? color,
  }) {
    return _buildText(
      text,
      txtStyle: TxtStyle.bodyMedium,
      color: color,
      center: center,
      wrap: wrap,
    );
  }

  static Widget button(
    String? text, {
    bool small = false,
  }) {
    return Builder(
      builder: (context) {
        final style = TextStyle(
          fontSize: small ? Font.small : null,
        );

        // text color doesn't work with this.  I assume the button is setting
        // the default styles and has already copied the button style
        // but this might only work inside a button
        // Theme.of(context).textTheme.labelLarge!.copyWith(
        //       fontSize: small ? Font.small : null ,
        //     );

        return Text(
          text ?? '',
          style: style,
        );
      },
    );
  }

  static Widget bodySmall(String? text) {
    return Builder(
      builder: (context) {
        return Text(
          text ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }

  static Widget labelSmall(String? text) {
    return Builder(
      builder: (context) {
        return Text(
          (text ?? '').toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        );
      },
    );
  }

  // ============================================================

  static Widget _buildText(
    String? text, {
    required TxtStyle txtStyle,
    bool center = false,
    Color? color,
    bool wrap = true,
  }) {
    TextStyle baseStyle;

    return Builder(
      builder: (context) {
        switch (txtStyle) {
          case TxtStyle.headlineMedium:
            baseStyle = Theme.of(context).textTheme.headlineMedium!;
            break;
          case TxtStyle.headlineSmall:
            baseStyle = Theme.of(context).textTheme.headlineSmall!;
            break;
          case TxtStyle.bodyLarge:
            baseStyle = Theme.of(context).textTheme.bodyLarge!;
            break;
          case TxtStyle.bodyMedium:
            baseStyle = Theme.of(context).textTheme.bodyMedium!;
            break;
          case TxtStyle.titleMedium:
            baseStyle = Theme.of(context).textTheme.titleMedium!;
            break;
          case TxtStyle.titleSmall:
            baseStyle = Theme.of(context).textTheme.titleSmall!;
            break;
          case TxtStyle.labelSmall:
            baseStyle = Theme.of(context).textTheme.labelSmall!;
            break;
          case TxtStyle.bodySmall:
            baseStyle = Theme.of(context).textTheme.bodySmall!;
            break;
        }

        final textStyle = baseStyle.copyWith(
          color: (color != null) ? color : null,
        );

        return Text(
          text ?? '',
          textAlign: center ? TextAlign.center : null,
          style: textStyle,
          overflow: wrap ? null : TextOverflow.ellipsis,
        );
      },
    );
  }
}
