import 'package:cacha_test/theme/colors.dart';
import 'package:cacha_test/theme/sizes.dart';
import 'package:flutter/material.dart';


/// A customizable button widget that follows the app's design system.
/// This widget provides consistent styling and behavior across the application
/// with support for custom colors, sizes, and optional prefix icons.
class AppButton extends StatelessWidget {

  const AppButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.prefix, // Optional prefix widget
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.verticalPadding = AppSizes.pagePadding,
    this.borderRadius = AppSizes.radiusLg,
    this.width = double.infinity,
    this.height = AppSizes.buttonHeight,
    this.textStyle

  });

  /// The button text that supports internationalization via GetX
  final Widget child;
  
  /// Callback function triggered when the button is pressed
  final Future<void> Function()? onPressed;

  
  /// Background color of the button
  final Color backgroundColor;
  
  /// Text color of the button
  final Color? textColor;

  /// Vertical padding inside the button for proper spacing
  final double verticalPadding;
  
  /// Border radius for rounded corners
  final double borderRadius;
  
  /// Width of the button (defaults to full width)
  final double? width;
  
  /// Height of the button
  final double height;
  
  /// Optional widget to display before the text (e.g., icons, images)
  final Widget? prefix;
  
  /// Custom text style that overrides the default button text styling
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => SizedBox(
        // Use responsive sizing for width and height
        width: width,
        height: height,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            // Apply responsive vertical padding
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            shape: RoundedRectangleBorder(
              // Apply responsive border radius
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Conditionally show prefix widget if provided
              if (prefix != null) ...[
                prefix!, // Display the prefix if provided
                const SizedBox(width: 8), // Space between prefix and text
              ],
            child,
            ],
          ),
        ),
      );
}
