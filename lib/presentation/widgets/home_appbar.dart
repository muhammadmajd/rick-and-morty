import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../core/constents/colors.dart';
import '../../../../core/constents/text_strings.dart';
import '../../../../core/utils/theme/controller/theme_controller.dart';


class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key, required this.title,
  });
 final String title;
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return TAppBar(
      title:   Center(
        child: Text(
         title,
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.grey),
        ),
      ),
     // leading: const SizedBox(), // This removes the back arrow
      actions: [
        // Theme toggle button
        Obx(() => IconButton(
          icon: Icon(
            themeController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode,
            color: TColors.white,
          ),
          onPressed: () {
            themeController.toggleTheme();
          },
        )),
      ],
    );
  }
}