import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/character_controller.dart';
import '../widgets/character_card.dart';

class CharacterList extends StatelessWidget {
  final CharacterController controller;

  const CharacterList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.characters.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.hasError.value && controller.characters.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${controller.errorMessage.value}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshCharacters,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.characters.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No characters found'),
            ],
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !controller.isLoading.value) {
            controller.loadNextPage();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: controller.characters.length + (controller.isLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.characters.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final character = controller.characters[index];
            return CharacterCard(character: character);
          },
        ),
      );
    });
  }
}