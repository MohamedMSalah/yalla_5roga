import 'package:flutter/material.dart';

/// Scales fonts, paddings, and widget sizes from a 375x812 design
/// so the UI stays consistent on phones, tablets, and desktops.
class Responsive {
  Responsive._();

  static const double designWidth = 375;
  static const double designHeight = 812;
  static const double minScale = 0.82;
  static const double maxScale = 1.28;
  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;

  static double _width = designWidth;
  static double _height = designHeight;
  static double _textScale = 1;

  static void init(BuildContext context) {
    final data = MediaQuery.of(context);
    _width = data.size.width;
    _height = data.size.height;
    _textScale = data.textScaler.scale(1);
  }

  static double get width => _width;
  static double get height => _height;

  static double get scale {
    return (_width / designWidth).clamp(minScale, maxScale);
  }

  static double get verticalScale {
    return (_height / designHeight).clamp(minScale, maxScale);
  }

  static bool get isMobile => _width < tabletBreakpoint;
  static bool get isTablet => _width >= tabletBreakpoint && _width < desktopBreakpoint;
  static bool get isDesktop => _width >= desktopBreakpoint;

  /// Width-based size (containers, icons, horizontal padding).
  static double w(num value) => value * scale;

  /// Height-based size (vertical gaps, bar heights).
  static double h(num value) => value * verticalScale;

  /// Font size, lightly respecting system text scale.
  static double sp(num value) {
    return (value * scale) * _textScale.clamp(0.9, 1.15);
  }

  /// Radius / border size.
  static double r(num value) => value * scale;

  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) return EdgeInsets.all(w(all));
    return EdgeInsets.only(
      left: w(left ?? horizontal ?? 0),
      right: w(right ?? horizontal ?? 0),
      top: h(top ?? vertical ?? 0),
      bottom: h(bottom ?? vertical ?? 0),
    );
  }

  static EdgeInsets pagePadding({double horizontal = 20, double top = 12, double bottom = 24}) {
    return padding(horizontal: horizontal, top: top, bottom: bottom);
  }

  // Spacing tokens
  static double get spaceXs => w(4);
  static double get spaceSm => w(8);
  static double get spaceMd => w(16);
  static double get spaceLg => w(20);
  static double get spaceXl => w(24);
  static double get spaceXxl => w(32);

  // Font tokens
  static double get fontXs => sp(8);
  static double get fontCaption => sp(9);
  static double get fontSm => sp(11);
  static double get fontBody => sp(14);
  static double get fontMd => sp(16);
  static double get fontLg => sp(22);
  static double get fontXl => sp(32);

  // Widget tokens
  static double get iconSm => w(14);
  static double get iconMd => w(20);
  static double get iconLg => w(28);
  static double get radiusSm => r(10);
  static double get radiusMd => r(14);
  static double get radiusLg => r(22);
  static double get buttonHeight => h(52);
  static double get navHeight => h(76);
  static double get avatarSm => w(28);
  static double get avatarMd => w(40);
  static double get avatarLg => w(84);
}

extension ResponsiveNumX on num {
  double get w => Responsive.w(this);
  double get h => Responsive.h(this);
  double get sp => Responsive.sp(this);
  double get r => Responsive.r(this);

  EdgeInsets get p => EdgeInsets.all(w);
  EdgeInsets get px => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get py => EdgeInsets.symmetric(vertical: h);

  SizedBox get gapW => SizedBox(width: w);
  SizedBox get gapH => SizedBox(height: h);
}

extension ResponsiveContextX on BuildContext {
  Responsive get responsive {
    Responsive.init(this);
    return Responsive._();
  }

  double rw(num value) => Responsive.w(value);
  double rh(num value) => Responsive.h(value);
  double rsp(num value) => Responsive.sp(value);
  double rr(num value) => Responsive.r(value);
}
