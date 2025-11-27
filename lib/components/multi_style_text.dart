import 'package:flutter/material.dart';
import 'package:hop/app_styles/app_text_styles.dart';

class MultiStyleTextFirstLight extends StatelessWidget {
  const MultiStyleTextFirstLight(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      this.height,
      this.letterSpacing,
      this.textAlign});
  final String text;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");
    textSpans.add(
      textParts.length <= 1
          ? TextSpan(
              text: " ${textParts[0]}",
              style: AppTextStyles.manropeBold(
                fontSize: fontSize,
                color: color,
                height: height,
                letterSpacing: letterSpacing,
              ),
            )
          : TextSpan(
              text: textParts[0],
              style: AppTextStyles.manropeBold(
                fontSize: fontSize,
                color: color,
                height: height,
                letterSpacing: letterSpacing,
              ),
            ),
    );
    for (int i = 1; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: " ${textParts[i]}",
          style: AppTextStyles.manropeBold(
            fontSize: fontSize,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
          ),
        ),
      );
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextLastBold extends StatelessWidget {
  const MultiStyleTextLastBold({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.boldStartPosition,
    required this.boldWordCount,
    this.height,
    this.letterSpacing,
    this.textAlign,
  });

  final String text;
  final int boldStartPosition; // Start index for bold text
  final int boldWordCount; // Number of words to make bold
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: '${textParts[i]} ',
          style:
              (i >= boldStartPosition && i < boldStartPosition + boldWordCount)
                  ? AppTextStyles.manropeBold(
                      fontSize: fontSize,
                      color: color,
                      height: height,
                      letterSpacing: letterSpacing,
                    )
                  : AppTextStyles.manropeBold(
                      fontSize: fontSize,
                      color: color,
                      height: height,
                      letterSpacing: letterSpacing,
                    ),
        ),
      );
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextFirstBold extends StatelessWidget {
  const MultiStyleTextFirstBold(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      this.height,
      this.letterSpacing,
      this.textAlign});
  final String text;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");
    textSpans.add(
      TextSpan(
        text: textParts[0],
        style: AppTextStyles.manropeBold(
          fontSize: fontSize,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        ),
      ),
    );
    for (int i = 1; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: " ${textParts[i]}",
          style: AppTextStyles.manropeBold(
            fontSize: fontSize,
            color: color,
            height: height,
            letterSpacing: letterSpacing,
          ),
        ),
      );
    }
    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextPositionLight extends StatelessWidget {
  const MultiStyleTextPositionLight(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      required this.textBoldPosition,
      this.height,
      this.letterSpacing,
      this.textAlign});
  final String text;
  final int textBoldPosition;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: '${textParts[i]} ',
          style: i < textBoldPosition
              ? AppTextStyles.manropeBold(
                  fontSize: fontSize,
                  color: color,
                  height: height,
                  letterSpacing: letterSpacing,
                )
              : AppTextStyles.manropeBold(
                  fontSize: fontSize,
                  color: color,
                  height: height,
                  letterSpacing: letterSpacing,
                ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextFirstPositionBold extends StatelessWidget {
  const MultiStyleTextFirstPositionBold(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      required this.textBoldPosition,
      this.height,
      this.letterSpacing,
      this.textAlign});
  final String text;
  final int textBoldPosition;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: '${textParts[i]} ',
          style: i < textBoldPosition
              ? AppTextStyles.manropeBold(
                  fontSize: fontSize,
                  color: color,
                  height: height,
                  letterSpacing: letterSpacing,
                )
              : AppTextStyles.manropeBold(
                  fontSize: fontSize,
                  color: color,
                  height: height,
                  letterSpacing: letterSpacing,
                ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextAeonikPositionLight extends StatelessWidget {
  const MultiStyleTextAeonikPositionLight(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.color,
      required this.textBoldPosition,
      this.height,
      this.letterSpacing,
      this.textAlign});
  final String text;
  final int textBoldPosition;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: '${textParts[i]} ',
          style: i < textBoldPosition
              ? AppTextStyles.manropeMedium(
                  fontSize: fontSize,
                  color: color,
                )
              : AppTextStyles.manropeMedium(),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextFirstLastLight extends StatelessWidget {
  const MultiStyleTextFirstLastLight({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.boldStartPosition,
    required this.boldWordCount,
    this.height,
    this.letterSpacing,
    this.textAlign,
  });

  final String text;
  final int boldStartPosition; // Start index for bold text
  final int boldWordCount; // Number of words to make bold
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
          text: '${textParts[i]} ',
          style:
              (i >= boldStartPosition && i < boldStartPosition + boldWordCount)
                  ? AppTextStyles.manropeBold(
                      fontSize: fontSize,
                      color: color,
                      height: height,
                      letterSpacing: letterSpacing,
                    )
                  : AppTextStyles.manropeBold(
                      fontSize: fontSize,
                      color: color,
                      height: height,
                      letterSpacing: letterSpacing,
                    ),
        ),
      );
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}

class MultiStyleTextPositionBoldFromEnd extends StatelessWidget {
  const MultiStyleTextPositionBoldFromEnd({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
    required this.boldWordCount,
    this.height,
    this.letterSpacing,
    this.textAlign,
  });

  final String text;
  final int boldWordCount;
  final double fontSize;
  final Color color;
  final double? height;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    final List<String> textParts = text.split(" ");
    final int boldStartPosition = textParts.length - boldWordCount;

    for (int i = 0; i < textParts.length; i++) {
      textSpans.add(
        TextSpan(
            text: '${textParts[i]} ',
            style: (i < boldStartPosition)
                ? AppTextStyles.manropeBold(
                    fontSize: fontSize,
                    color: color,
                  )
                : AppTextStyles.manropeBold(
                    fontSize: fontSize,
                    color: color,
                    height: height,
                    letterSpacing: letterSpacing,
                  )),
      );
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.center,
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
