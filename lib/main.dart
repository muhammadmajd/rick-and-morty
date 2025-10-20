import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:rickmorty/presentation/bindings/character_binding.dart';

import 'core/network/GraphQLClientService.dart';
import 'core/utils/theme/controller/theme_controller.dart';
import 'core/utils/theme/theme.dart';
import 'data/models/favorite_hive_model.dart';
import 'navigation_menu.dart';
void main() async {
  // Initialize Hive
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  // Register Hive adapters
  Hive.registerAdapter(FavoriteHiveModelAdapter());

  // Initialize ThemeController and set initial theme
  final themeController = ThemeController();
  Get.put(themeController);

  // Set initial theme based on system
  final Brightness platformBrightness = WidgetsBinding.instance.window.platformBrightness;
  themeController.isDarkMode.value = platformBrightness == Brightness.dark;
  Get.changeThemeMode(themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(GraphQLClientService.getClient()),
      child: GetMaterialApp(
        title: 'Rick and Morty',
        themeMode: ThemeMode.system,
        darkTheme: TAppTheme.darkTheme,
        theme: TAppTheme.lightTheme,
        initialBinding: CharacterBinding(),
        //home: const CharactersPage(),
        home: const NavigationMenu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
