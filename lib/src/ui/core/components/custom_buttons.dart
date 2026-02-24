import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtons {
  static TextButton textButton({
    required String text,
    required Function() onPressed,
    Color? color,
    IconData? icon,
    Color? iconColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 25, color: iconColor ?? verdePadrao),
          SizedBox(width: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color ?? azulPadrao,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
