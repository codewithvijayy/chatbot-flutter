import 'package:chatbot/theme/colors.dart';
import 'package:flutter/material.dart';

class SideBarButton extends StatelessWidget {
  final bool isCollapsed;
  final IconData icon;
  final String text;

  const SideBarButton({
    super.key,
    required this.isCollapsed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Optional: spacing
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor, size: size.width * 0.020),
          SizedBox(width: size.width * 0.01),
          if (!isCollapsed) ...[
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.010,
                color: AppColors.whiteColor, // make it match sidebar
              ),
            ),
          ],
        ],
      ),
    );
  }
}
