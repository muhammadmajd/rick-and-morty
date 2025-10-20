import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constents/colors.dart' show TColors;
import '../../core/constents/sizes.dart';
import '../../core/utils/device/device_utality.dart';
import '../../core/utils/helper/helper_functions.dart';
import '../../core/utils/sort/sort_options.dart';
import '../controller/character_controller.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController controller = Get.find<CharacterController>();
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      return Container(
        width: TDeviceUtils.getScreenWidth(context) * 0.5, // Adjust width as needed
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.light,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: Border.all(color: TColors.grey),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.sort, color: TColors.darkerGrey, size: 20),
            const SizedBox(width: TSizes.spaceBtwItems),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CharacterSortOption>(
                  value: controller.currentSortOption.value,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(Iconsax.arrow_down_1, size: 16, color: TColors.darkerGrey),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: dark ? TColors.white : TColors.black,
                  ),
                  dropdownColor: dark ? TColors.dark : TColors.white,
                  onChanged: (CharacterSortOption? newValue) {
                    if (newValue != null) {
                      controller.changeSortOption(newValue);
                    }
                  },
                  items: CharacterSortOption.values.map((CharacterSortOption option) {
                    return DropdownMenuItem<CharacterSortOption>(
                      value: option,
                      child: Text(
                        option.displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: dark ? TColors.white : TColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}