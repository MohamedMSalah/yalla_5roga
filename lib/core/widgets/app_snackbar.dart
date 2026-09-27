import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void show(String message) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        messageText: _ToastBubble(message: message),
        backgroundColor: Colors.transparent,
        snackStyle: SnackStyle.FLOATING,
        margin: Responsive.padding(horizontal: 36, bottom: 28),
        padding: EdgeInsets.zero,
        duration: const Duration(milliseconds: 1800),
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class _ToastBubble extends StatelessWidget {
  const _ToastBubble({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280.w),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.slate950.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
