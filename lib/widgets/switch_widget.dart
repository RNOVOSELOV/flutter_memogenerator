import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({
    super.key,
    required this.text,
    required this.onStateChanged,
    required this.initialState,
  });

  final String text;
  final Function({required bool value}) onStateChanged;
  final bool initialState;

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialState;
  }

  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    value = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _pushStatusChanged(),
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        ),
        shape: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            );
          }
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide.none,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Color(0x66000000);
          }
          return context.color.textPrimaryColor;
        }),
        elevation: WidgetStatePropertyAll(0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(widget.text, style: context.theme.memeSemiBold20),
          ),
          SizedBox(width: 16),
          CupertinoSwitch(
            value: value,
            onChanged: (_) {
              _pushStatusChanged();
            },
            thumbColor: context.theme.scaffoldBackgroundColor,
            inactiveTrackColor: context.color.iconUnselectedColor,
            activeTrackColor: context.color.accentColor,
          ),
        ],
      ),
    );
  }

  void _pushStatusChanged() {
    setState(() {
      value = !value;
      widget.onStateChanged(value: value);
    });
  }
}
