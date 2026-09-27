import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
    this.radius,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: margin,
      padding: padding ?? EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color ?? context.palette.surface,
        borderRadius: BorderRadius.circular((radius ?? 22).r),
        border: Border.all(color: borderColor ?? context.palette.border),
        boxShadow: [
          BoxShadow(
            color: context.palette.shadow,
            blurRadius: 24.w,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.children,
    this.spacing,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final double? spacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? 10.h;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}
