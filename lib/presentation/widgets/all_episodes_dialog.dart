import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/episode.dart';



class AllEpisodesDialog extends StatelessWidget {
  final List<Episode> episodes;

  const AllEpisodesDialog({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final maxDialogHeight = mq.size.height * 0.8; // 80% of screen

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxDialogHeight,
          minWidth: min(320, mq.size.width - 32),
          maxWidth: min(600, mq.size.width - 32),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // custom header instead of AppBar (works reliably inside Dialog)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All Episodes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            //  Expanded so ListView gets definite height inside ConstrainedBox
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: episodes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ep = episodes[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(ep.name),
                    subtitle: Text('${ep.episode} • ${ep.airDate}'),
                    onTap: () {
                      // optional: close or handle tap
                      // Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}