import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rickmorty/core/constents/colors.dart' show TColors;
import 'package:rickmorty/core/constents/sizes.dart';

import '../../../../core/utils/device/device_utality.dart';
import '../../../../core/utils/helper/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
    required this.text,
    required this.onSearch,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.spacesBtwsections),
    this.onTap,
  });

  final String text;
  final Function(String) onSearch;
  final IconData? icon;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final TextEditingController searchController = TextEditingController();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: showBackground ? dark ? TColors.dark : TColors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: TColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: TColors.darkerGrey),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(
                child: SizedBox(
                  height: 24, // Match the container height or adjust as needed
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: text,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: InputBorder.none, // Remove border
                      enabledBorder: InputBorder.none, // Remove enabled border
                      focusedBorder: InputBorder.none, // Remove focused border
                      disabledBorder: InputBorder.none, // Remove disabled border
                      errorBorder: InputBorder.none, // Remove error border
                      focusedErrorBorder: InputBorder.none, // Remove focused error border
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium, // Optional: Set text style
                    onChanged: onSearch,
                    onSubmitted: onSearch,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}