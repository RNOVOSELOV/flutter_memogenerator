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
        TextButton(
          onPressed: onPress,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 20,
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
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: Container(
            height: 28,
            width: 28,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                elevation: 1,
                alignment: Alignment.center,
                shape: CircleBorder(),
                backgroundColor: AppColors.fuchsia50,
                padding: EdgeInsets.zero,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
