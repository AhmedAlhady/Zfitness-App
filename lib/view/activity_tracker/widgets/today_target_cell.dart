import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/app_colors.dart';

class TodayTargetCell extends StatelessWidget {
  final String icon;
  final String? value;
  final String title;
  final Widget? customChild;

  const TodayTargetCell({
    Key? key,
    required this.icon,
    this.value,
    required this.title,
    this.customChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (customChild != null) ...[
                  customChild!,
                ] else ...[
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: AppColors.primaryG,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(
                        Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                      );
                    },
                    child: Text(
                      value ?? '',
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
