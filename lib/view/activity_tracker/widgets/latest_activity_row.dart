import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LatestActivityRow extends StatelessWidget {
  final Map wObj;

  const LatestActivityRow({Key? key, required this.wObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrayColor.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            wObj["image"] ?? "assets/images/default_image.png",
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wObj["title"] ?? "Title not available",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  wObj["time"] ?? "Time not specified",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
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
