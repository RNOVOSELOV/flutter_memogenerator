import 'dart:math';

const _token = '-';
const _leftToken = ' ';
const _spaceToken = ' ';

final _additionalSpacesCount = 2;
final _maxSymbolsInLine = 70;
final _leftIndentCount = 2;

void fancyPrint(
  final String text, {
  final PrintType printType = PrintType.text,
}) {
  final dashesCount = printType.dashesCount;
  final dashesString = List.generate(dashesCount, (_) => _token).join();
  final leftIndentString =
      List.generate(_leftIndentCount, (_) => _leftToken).join();
  final reservedSymbolsCount = dashesCount * 2 + _additionalSpacesCount;
  final maxLineCount = _maxSymbolsInLine - reservedSymbolsCount;
  final lines = <String>[];
  var tempPhrase = '';
  var tempWord = '';
  for (int i = 0; i < text.length; i++) {
    final effectiveMaxLineCount =
        lines.isEmpty ? maxLineCount - _leftIndentCount : maxLineCount;
    if (text[i] == ' ') {
      tempPhrase = "$tempPhrase $tempWord".trim();
      tempWord = '';
    } else {
      tempWord = tempWord + text[i];
    }
    if (i == text.length - 1) {
      tempPhrase = "$tempPhrase $tempWord".trim();
      tempWord = '';
      lines.add(tempPhrase);
    } else if (tempPhrase.length + tempWord.length + 1 ==
        effectiveMaxLineCount) {
      lines.add(tempPhrase);
      tempPhrase = '';
    }
  }

  if (printType.addLineBefore) {
    print(List.generate(_maxSymbolsInLine, (_) => _token).join());
  }
  for (int i = 0; i < lines.length; i++) {
    final stringBuffer = StringBuffer();
    stringBuffer.write(dashesString);
    final needToAddLeftIndent =
        i == 0 && printType.addLeftIndentOnConsequentLines;
    if (needToAddLeftIndent) {
      stringBuffer.write(leftIndentString);
    }
    final techSymbolsCount = dashesCount +
        1 +
        (needToAddLeftIndent ? _leftIndentCount : 0) +
        1 +
        dashesCount;
    final overallSymbols = lines[i].length + techSymbolsCount;
    late int emptySpacesLeft;
    late int emptySpacesRight;
    final int blankTokensToAdd = max(0, _maxSymbolsInLine - overallSymbols);
    if (printType.alignLeft) {
      emptySpacesLeft = 0;
      emptySpacesRight = blankTokensToAdd;
    } else {
      emptySpacesLeft = (blankTokensToAdd / 2).floor();
      emptySpacesRight = (blankTokensToAdd / 2).ceil();
    }
    if (emptySpacesLeft > 0) {
      stringBuffer
          .write(List.generate(emptySpacesLeft, (_) => _spaceToken).join());
    }
    stringBuffer.write(_spaceToken);
    stringBuffer.write(lines[i]);
    stringBuffer.write(_spaceToken);

    if (emptySpacesRight > 0) {
      stringBuffer
          .write(List.generate(emptySpacesRight, (_) => _spaceToken).join());
    }
    stringBuffer.write(dashesString);

    print(stringBuffer.toString());
  }

  if (printType.addLineAfter) {
    print(List.generate(_maxSymbolsInLine, (_) => _token).join());
  }
}

class PrintType {
  final int dashesCount;
  final bool alignLeft;
  final bool addLeftIndentOnConsequentLines;
  final bool addLineBefore;
  final bool addLineAfter;

  const PrintType._({
    required this.dashesCount,
    required this.alignLeft,
    required this.addLeftIndentOnConsequentLines,
    required this.addLineBefore,
    required this.addLineAfter,
  });

  static const text = PrintType._(
    dashesCount: 1,
    alignLeft: true,
    addLeftIndentOnConsequentLines: true,
    addLineBefore: false,
    addLineAfter: false,
  );
  static const headline = PrintType._(
    dashesCount: 5,
    alignLeft: true,
    addLeftIndentOnConsequentLines: false,
    addLineBefore: true,
    addLineAfter: true,
  );
  static const startEnd = PrintType._(
    dashesCount: 10,
    alignLeft: false,
    addLeftIndentOnConsequentLines: false,
    addLineBefore: true,
    addLineAfter: true,
  );
}
