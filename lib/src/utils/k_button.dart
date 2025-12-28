import 'package:flutter/material.dart';
import 'package:m_app/src/utils/app_colors.dart';

class KButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double height;
  final double? width; // Made width optional
  final IconData? icon;
  final double? textSize;
  final FontWeight? fontWeight;

  const KButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.height = 50,
    this.width, // Removed default value
    this.icon,
    this.textSize = 18,
    this.fontWeight,
    Color backgroundColor = AppColors.appSecondaryGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: textColor),
            label: Text(
              text,
              style: TextStyle(
                  color: textColor,
                  letterSpacing: 1,
                  fontSize: textSize,
                  fontWeight: fontWeight),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 4,
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 4,
            ),
            child: Text(
              text,
              style: TextStyle(
                  color: textColor,
                  letterSpacing: 1,
                  fontSize: textSize,
                  fontWeight: fontWeight),
            ),
          );

    // Use SizedBox only if a width is provided
    return width != null
        ? SizedBox(
            width: width,
            height: height,
            child: button,
          )
        : SizedBox(
            height: height,
            child: button,
          );
  }
}
