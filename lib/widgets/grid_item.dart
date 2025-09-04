import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.onPress,
    required this.onDelete,
    required this.fileBytes,
    required this.fileId,
  });

  final VoidCallback onPress;
  final VoidCallback onDelete;
  final Uint8List? fileBytes;
  final String fileId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: context.color.cardBackgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.color.cardBorderColor, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: TextButton(
            onPressed: onPress,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: fileBytes == null
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 38,
                          color: AppColors.errorColor,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Ошибка загрузки изображения',
                          textAlign: TextAlign.center,
                          style: context.theme.memeRegular12.copyWith(
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          fileId,
                          textAlign: TextAlign.center,
                          style: context.theme.memeRegular12.copyWith(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.memory(
                      fileBytes!,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.scaleDown,
                      gaplessPlayback: true,
                    ),
                  ),
          ),
        ),
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: GridItemActionButton(
            onPress: onDelete,
            icon: Icons.delete_outline,
          ),
        ),
      ],
    );
  }
}

class GridItemActionButton extends StatefulWidget {
  const GridItemActionButton({
    super.key,
    required this.onPress,
    required this.icon,
  });

  final VoidCallback onPress;
  final IconData icon;

  @override
  State<GridItemActionButton> createState() => _GridItemActionButtonState();
}

class _GridItemActionButtonState extends State<GridItemActionButton> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4.0),
      child: IconButton(
        onPressed: () {
          widget.onPress();
          setState(() => scale = 1.2);
        },
        style: IconButton.styleFrom(
          alignment: Alignment.center,
          shape: CircleBorder(),
          backgroundColor: context.color.accentColor.withValues(alpha: 0.68),
          padding: EdgeInsets.zero,
        ),
        icon: AnimatedScale(
          scale: scale,
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          child: Icon(widget.icon, color: Colors.white, size: 16),
          onEnd: () => setState(() => scale = 1.0),
        ),
      ),
    );
  }
}
