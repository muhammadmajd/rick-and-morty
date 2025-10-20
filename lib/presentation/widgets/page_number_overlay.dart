import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rickmorty/core/constents/colors.dart';

import '../controller/character_controller.dart';

class PageNumberOverlay extends StatelessWidget {
  const PageNumberOverlay({
    super.key,
    required this.controller,
    this.isDark = false,
  });

  final CharacterController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPage = controller.currentPage.value;
      final totalPages = controller.paginationInfo.value?.pages ?? 1;
      final progress = currentPage / totalPages;

      return Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(3),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Outer progress circle
            SizedBox(
              width: 53, // Match container size minus padding
              height: 53,
              child: CircularProgressIndicator(
                value: progress,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.red : Colors.red),
                strokeWidth: 4, // Slightly thicker for better visibility
              ),
            ),

            /// Inner content circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? TColors.dark : TColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? TColors.secondary : TColors.secondary,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentPage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? TColors.white : TColors.white,
                      ),
                    ),
                    Text(
                      'of $totalPages',
                      style: TextStyle(
                        fontSize: 8,
                        color: isDark ? TColors.white : TColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}