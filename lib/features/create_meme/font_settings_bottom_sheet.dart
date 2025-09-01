import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:memogenerator/features/create_meme/create_meme_bloc.dart';
import 'package:memogenerator/features/create_meme/meme_text_on_canvas.dart';
import 'package:memogenerator/features/create_meme/models/meme_text.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/confirmation_dialog.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:provider/provider.dart';

class FontSettingBottomSheet extends StatefulWidget {
  const FontSettingBottomSheet({super.key, required this.memeText});

  final MemeText memeText;

  @override
  State<FontSettingBottomSheet> createState() => _FontSettingBottomSheetState();
}

class _FontSettingBottomSheetState extends State<FontSettingBottomSheet> {
  late double fontSize;
  late Color color;
  late FontWeight fontWeight;

  @override
  void initState() {
    super.initState();
    fontSize = widget.memeText.fontSize;
    color = widget.memeText.color;
    fontWeight = widget.memeText.fontWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            height: 4,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        MemeTextOnCanvas(
          parentConstraints: const BoxConstraints.expand(),
          padding: 8,
          selected: true,
          text: widget.memeText.text,
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
        const SizedBox(height: 48),
        FontSizeSlider(
          changeFontSize: (value) => setState(() => fontSize = value),
          initialFontSize: fontSize,
        ),
        const SizedBox(height: 16),
        ColorSelection(
          changeColor: (color) => setState(() => this.color = color),
        ),
        const SizedBox(height: 16),
        FontWeightSlider(
          changeFontWeight: (value) => setState(() => fontWeight = value),
          initialFontWeight: fontWeight,
        ),
        const SizedBox(height: 36),
        Align(
          alignment: Alignment.centerRight,
          child: Buttons(
            memeId: widget.memeText.id,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  final Color color;
  final double fontSize;
  final String memeId;
  final FontWeight fontWeight;

  const Buttons({
    Key? key,
    required this.color,
    required this.fontSize,
    required this.memeId,
    required this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CreateMemeBloc>(context, listen: false);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          onTap: () => Navigator.of(context).pop(),
          labelText: "Отмена",
          color: context.color.textIconColor,
        ),
        const SizedBox(width: 24),
        AppButton(
          onTap: () {
            bloc.changeFontSettings(memeId, color, fontSize, fontWeight);
            Navigator.of(context).pop();
          },
          labelText: "Сохранить",
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class ColorSelection extends StatelessWidget {
  final ValueChanged<Color> changeColor;

  const ColorSelection({super.key, required this.changeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 16),
        const Text(
          "Color:",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(width: 16),
        ColorSelectionBox(changeColor: changeColor, color: Colors.white),
        const SizedBox(width: 16),
        ColorSelectionBox(changeColor: changeColor, color: Colors.black),
        const SizedBox(width: 16),
        ColorPickerWidget(changeColor: changeColor),
      ],
    );
  }
}

class ColorPickerWidget extends StatefulWidget {
  const ColorPickerWidget({super.key, required this.changeColor});

  final ValueChanged<Color> changeColor;

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => setState(() => selectedColor = context.theme.primaryColor,),
            );
            return AlertDialog(
              title: Text('Выберите цвет'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: selectedColor ?? context.theme.primaryColor,
                  onColorChanged: (value) =>
                      setState(() => selectedColor = value),
                  labelTypes: [],
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedColor != null) {
                      widget.changeColor(selectedColor!);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Готово'.toUpperCase(),
                    style: TextStyle(color: context.color.accentColor),
                  ),
                ),
              ],
            );
          },
        );

        //widget.changeColor(color)
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: selectedColor,
          gradient: selectedColor == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    context.theme.primaryColor,
                    context.color.accentColor,
                    Colors.black,
                  ],
                )
              : null,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}

class ColorSelectionBox extends StatelessWidget {
  const ColorSelectionBox({
    super.key,
    required this.changeColor,
    required this.color,
  });

  final ValueChanged<Color> changeColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => changeColor(color),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}

class FontSizeSlider extends StatefulWidget {
  const FontSizeSlider({
    Key? key,
    required this.initialFontSize,
    required this.changeFontSize,
  }) : super(key: key);

  final ValueChanged<double> changeFontSize;
  final double initialFontSize;

  @override
  State<FontSizeSlider> createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends State<FontSizeSlider> {
  late double fontSize;

  @override
  void initState() {
    super.initState();
    fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            "Size:",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: context.color.accentColor,
              inactiveTrackColor: context.color.accentColor.withValues(alpha: 0.38),
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              thumbColor: context.color.accentColor,
              inactiveTickMarkColor: context.color.accentColor,
              valueIndicatorColor: context.color.accentColor,
            ),
            child: Slider(
              min: 16,
              max: 32,
              divisions: 10,
              label: fontSize.round().toString(),
              value: fontSize,
              onChanged: (value) {
                setState(() {
                  fontSize = value;
                  widget.changeFontSize(value);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class FontWeightSlider extends StatefulWidget {
  const FontWeightSlider({
    super.key,
    required this.changeFontWeight,
    required this.initialFontWeight,
  });

  final ValueChanged<FontWeight> changeFontWeight;
  final FontWeight initialFontWeight;

  @override
  State<FontWeightSlider> createState() => _FontWeightSliderState();
}

class _FontWeightSliderState extends State<FontWeightSlider> {
  late FontWeight fontWeight;

  @override
  void initState() {
    super.initState();
    fontWeight = widget.initialFontWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            "Font Weight:",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: context.color.accentColor,
              inactiveTrackColor: context.color.accentColor.withValues(alpha: 0.38),
              thumbColor: context.color.accentColor,
              inactiveTickMarkColor: context.color.accentColor,
            ),
            child: Slider(
              min: 0,
              max: 8,
              divisions: 8,
              value: fontWeight.index.toDouble(),
              onChanged: (value) {
                setState(() {
                  fontWeight = FontWeight.values.elementAt(value.round());
                  widget.changeFontWeight(fontWeight);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
