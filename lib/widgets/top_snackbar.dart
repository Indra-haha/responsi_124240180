import 'package:flutter/material.dart';

/// Calculates the floating margin so that [SnackBar] appears at the top of the screen
/// below the status bar and/or AppBar, while safely preventing overflow on screens
/// with or without BottomNavigationBar.
EdgeInsets topSnackBarMargin(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final screenHeight = mediaQuery.size.height;
  final topPadding = mediaQuery.padding.top;

  // Account for status bar and optional app bar
  final bool hasAppBar = Scaffold.maybeOf(context)?.hasAppBar ?? false;
  final double topOffset = topPadding + (hasAppBar ? kToolbarHeight : 0);

  // Approximate height of snackbar ~ 70px
  const double estimatedSnackBarHeight = 70.0;

  // Safe bottom clearance accounting for system navigation and potential bottom navigation bar
  final double bottomClearance =
      kBottomNavigationBarHeight + mediaQuery.padding.bottom + 24.0;

  final double bottomMargin =
      screenHeight - topOffset - estimatedSnackBarHeight - bottomClearance;

  return EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: bottomMargin > 20 ? bottomMargin : 20,
  );
}

/// Helper to display a SnackBar positioned at the top of the screen.
void showTopSnackBar(
  BuildContext context, {
  required Widget content,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: duration,
      margin: topSnackBarMargin(context),
    ),
  );
}
