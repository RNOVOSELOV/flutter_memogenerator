import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

import '../generated/l10n.dart';

Future<int?> showItemsBottomSheet(
  final BuildContext context, {
  required final int? selectedItemCode,
  required final Map<int, String> items,
  required final String title,
}) async {
  return await showModalBottomSheet<int?>(
    context: context,
    barrierColor: Color(0xCC1A1C24),
    isDismissible: true,
    enableDrag: true,
    elevation: 3,
    isScrollControlled: true,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 32, right: 32),
          child: _ItemsWidget(
            selectedCode: selectedItemCode,
            items: items,
            title: title,
          ),
        ),
      );
    },
  );
}

class _ItemsWidget extends StatefulWidget {
  const _ItemsWidget({
    required this.selectedCode,
    required this.items,
    required this.title,
  });

  final int? selectedCode;
  final Map<int, String> items;
  final String title;

  @override
  State<_ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<_ItemsWidget> {
  late int? selectedCode;
  late final List<MapEntry<int, String>> items;

  @override
  void initState() {
    super.initState();
    items = widget.items.entries.toList();
    selectedCode = widget.selectedCode; // ?? items.first.key;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BottomSheetTitleWidget(title: widget.title),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => SizedBox(height: 4),
          itemBuilder: (context, index) {
            final data = items.elementAt(index);
            return _ListItemWidget(
              key: ValueKey(
                'ListItemWidgetNumber_${index}_${data.key}_${data.value}',
              ),
              text: data.value,
              isSelected: selectedCode == data.key,
              onPress: () => setState(() {
                selectedCode = data.key;
                Future.delayed(Duration(milliseconds: 400), () {
                  if (context.mounted) {
                    Navigator.of(context).pop((selectedCode));
                  }
                });
              }),
            );
          },
        ),
        _BottomSheetCancelButtonWidget(),
      ],
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  const _ListItemWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPress,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
          alignment: Alignment.centerLeft,
          backgroundColor: WidgetStatePropertyAll(
            context.color.cardBackgroundColor,
          ),
          foregroundColor: WidgetStatePropertyAll(
            context.color.textPrimaryColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          textStyle: WidgetStatePropertyAll(context.theme.memeRegular16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(text)),
            if (isSelected) SizedBox(width: 8),
            if (isSelected)
              Icon(Icons.check, size: 36, color: Color(0xFF56BF67)),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetTitleWidget extends StatelessWidget {
  const _BottomSheetTitleWidget({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        DragElementWidget(),
        SizedBox(height: 24),
        Text(title, style: context.theme.memeSemiBold20),
        SizedBox(height: 16),
      ],
    );
  }
}

class _BottomSheetCancelButtonWidget extends StatelessWidget {
  const _BottomSheetCancelButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18),
        TextButton(
          onPressed: () => Future.delayed(Duration(milliseconds: 200), () {
            if (context.mounted) {
              Navigator.of(context).pop(null);
            }
          }),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              S.of(context).cancel,
              textAlign: TextAlign.center,
              style: context.theme.memeSemiBold20.copyWith(
                color: context.color.accentColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 36),
      ],
    );
  }
}

class DragElementWidget extends StatelessWidget {
  const DragElementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: context.color.textSecondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        height: 4,
        width: 28,
      ),
    );
  }
}
