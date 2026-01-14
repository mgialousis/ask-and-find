import 'package:flutter/material.dart';

/// Breakpoint for tablet layouts (600dp as per Material Design guidelines)
const double _kTabletBreakpoint = 600.0;

/// Device form factor enumeration
enum DeviceType {
  phone,
  tablet,
}

/// Responsive layout builder that adapts to phone vs tablet
///
/// Provides different builders for phone and tablet layouts.
/// Falls back to phone builder if tablet builder is not provided.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.phoneBuilder,
    this.tabletBuilder,
  });

  final Widget Function(BuildContext context) phoneBuilder;
  final Widget Function(BuildContext context)? tabletBuilder;

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _kTabletBreakpoint ? DeviceType.tablet : DeviceType.phone;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isPhone(BuildContext context) {
    return getDeviceType(context) == DeviceType.phone;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _kTabletBreakpoint) {
          return (tabletBuilder ?? phoneBuilder)(context);
        }
        return phoneBuilder(context);
      },
    );
  }
}

/// Provides responsive values based on device type
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.phone,
    this.tablet,
  });

  final T phone;
  final T? tablet;

  T getValue(BuildContext context) {
    if (ResponsiveLayout.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return phone;
  }
}
