import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';

class AppAlert {
  const AppAlert._();

  static Future<bool> confirm({
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
        content: Text(message, style: TextStyle(fontSize: Responsive.fontBody)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              CustomButton(
                label: confirmText,
                onPressed: () => Get.back(result: true),
              ),
              Responsive.spaceSm.gapH,
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  cancelText,
                  style: TextStyle(color: Get.context?.palette.textMuted ?? AppColors.slate500, fontSize: Responsive.fontBody),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: true,
    );
    return result ?? false;
  }

  static Future<void> info({
    required String title,
    required String message,
    required String okText,
  }) {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
        content: Text(message, style: TextStyle(fontSize: Responsive.fontBody)),
        actions: [
          CustomButton(label: okText, onPressed: Get.back),
        ],
      ),
    );
  }
}
