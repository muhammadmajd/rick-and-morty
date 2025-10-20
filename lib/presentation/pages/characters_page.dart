import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../core/constents/colors.dart';
import '../../core/constents/sizes.dart';
import '../../core/constents/text_strings.dart';
import '../../core/utils/helper/helper_functions.dart';
import '../controller/character_controller.dart';
import '../widgets/charecter_list.dart';
import '../widgets/home_appbar.dart';
import '../widgets/page_number_overlay.dart';
import '../widgets/search_field.dart';
import '../widgets/sort_dropdown.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController controller = Get.find<CharacterController>();
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              TPrimaryHeaderContainer(
                color: dark?TColors.darkerGrey:TColors.primary,
                  child: Column(
                    children: [
                      ///-- Appbar --
                      const THomeAppBar(title: TTexts.homeAppbarTitle),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      /// -- Searchbar --
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TSearchContainer(
                          text: "Search characters...",
                          onSearch: controller.searchCharacters,
                          icon: Iconsax.search_normal,
                          showBackground: true,
                          showBorder: true,
                        ),
                      ),
                      const SizedBox(height: TSizes.spacesBtwsections),
                    ],
                  )
              ),
              /// -- Sorting  --
              SortDropdown(),

              const SizedBox(height: TSizes.spaceBtwItems),
              Expanded(
                child:  CharacterList(controller: controller),
              ),
            ],
          ),
          /// Page Number Overlay
          Positioned(
            bottom: 20,
            right: 20,
            child: PageNumberOverlay(controller: controller,isDark: dark,),
          ),
        ],
      ),
    );
  }


}

