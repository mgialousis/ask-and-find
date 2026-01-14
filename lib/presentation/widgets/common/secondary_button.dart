import 'package:flutter/material.dart';

/// Secondary outlined button
///
/// Used for less prominent actions throughout the app.
/// Follows the theme's outlined button style.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isFullWidth = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      child: child,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
