import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

import '../../resources/app_colors.dart';

class FullScreenImagesWidget extends StatelessWidget {
  const FullScreenImagesWidget({
    super.key,
    required this.onEmptyAreaTap,
    required this.imageData,
  });

  final VoidCallback onEmptyAreaTap;
  final String imageData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEmptyAreaTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: context.color.accentColor.withValues(alpha: 0.48),
            child: Dismissible(
              key: const ValueKey('imageConstKey'),
              direction: DismissDirection.vertical,
              onDismissed: (direction) => onEmptyAreaTap(),
              child: GestureDetector(
                onTap: onEmptyAreaTap,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 80,
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Builder(
                      builder: (context) {
                        return CachedNetworkImage(
                          imageUrl: imageData,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.scaleDown,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
