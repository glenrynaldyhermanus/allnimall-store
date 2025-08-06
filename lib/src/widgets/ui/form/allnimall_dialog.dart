import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';

class AllnimallDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const AllnimallDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return shadcn.AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        AllnimallButton.outline(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          label: cancelText ?? 'Batal',
        ),
        isDestructive
            ? AllnimallButton.destructive(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                label: confirmText ?? 'Konfirmasi',
              )
            : AllnimallButton.primary(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                label: confirmText ?? 'Konfirmasi',
              ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return shadcn.showDialog<bool>(
      context: context,
      builder: (context) => AllnimallDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }
}
