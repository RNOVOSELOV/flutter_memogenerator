import 'dart:io';
import 'package:flutter/material.dart';
import '../resources/app_colors.dart';

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.onPress,
    required this.onDelete,
    required this.fileUri,
    required this.fileId,
  });

  final VoidCallback onPress;
  final VoidCallback onDelete;
  final String fileUri;
  final String fileId;

  @override
  Widget build(BuildContext context) {
    final imageFile = File(fileUri);
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.darkGrey16, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: TextButton(
            onPressed: onPress,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.darkGrey16, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: imageFile.existsSync()
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.file(
                      imageFile,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : Text(fileId),
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
          backgroundColor: AppColors.fuchsia50,
          padding: EdgeInsets.zero,
        ),
        icon: AnimatedScale(
          scale: scale,
          duration: Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
          child: Icon(widget.icon, color: AppColors.white, size: 16),
          onEnd: () => setState(() => scale = 1.0),
        ),
      ),
    );
  }
}
