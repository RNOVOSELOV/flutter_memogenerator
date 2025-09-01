import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/domain/entities/message.dart';
import 'package:memogenerator/domain/entities/status.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

SnackBar generateSnackBarWidget({
  required BuildContext context,
  required Message message,
}) {
  return SnackBar(
    content: SnackBarWidget(
      text: message.message,
      contentState: message.status,
    ),
    backgroundColor: context.color.cardBackgroundColor.withValues(alpha: 1.0),
    duration: const Duration(seconds: 2),
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );
}

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget({
    super.key,
    required this.text,
    required this.contentState,
  });

  final String text;
  final Status contentState;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              contentState == Status.success
                  ? Icon(
                      Icons.info_outline_rounded,
                      size: 32,
                      color: AppColors.successColor,
                    )
                  : Icon(
                      Icons.error_outline_outlined,
                      size: 32,
                      color: AppColors.errorColor,
                    ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: 0.15,
                    color: context.color.textPrimaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  onPressed: () async {
                    await Future.delayed(Duration(milliseconds: 200), () {});
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                  },
                  style: IconButton.styleFrom(
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 28,
                    color: context.color.iconSelectedColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}
