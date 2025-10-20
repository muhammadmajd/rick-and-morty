
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rickmorty/core/utils/formatter/formatter.dart';

import '../../core/constents/colors.dart';
import '../../core/utils/helper/helper_functions.dart';
import '../../domain/entities/character_detail.dart';
import '../../domain/entities/episode.dart';
import '../../domain/usecases/get_character_detail.dart';
import '../bindings/character_binding.dart';
import '../controller/character_detail_controller.dart';
import '../widgets/all_episodes_dialog.dart';
import 'location_detail_page.dart';

class CharacterDetailPage extends StatelessWidget {
  final String characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CharacterDetailController>(
      init: CharacterDetailController(
        getCharacterDetail: Get.find<GetCharacterDetail>(),
        characterId: characterId,
      ),
      builder: (controller) {
        final dark = THelperFunctions.isDarkMode(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Character Details', style: TextStyle(color: TColors.white),),
            backgroundColor:dark? TColors.darkerGrey: TColors.primary ,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: TColors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh , color: TColors.white,),
                onPressed: controller.refreshCharacterDetail,
              ),
            ],
          ),
          body: Obx(()=> controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.hasError.value
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${controller.errorMessage.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshCharacterDetail,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : controller.characterDetail.value == null
                ? const Center(child: Text('No character data found'))
                : _buildCharacterDetail(controller.characterDetail.value!),
          ),
        );
      },
    );
  }

  Widget _buildCharacterDetail111(CharacterDetail character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character image and basic info
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(character.image),
                  radius: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  character.name,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${character.status} - ${character.species}',
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Details Section
          _buildDetailSection('Details', [
            _buildDetailItem('Type', character.type.isNotEmpty ? character.type : 'None'),
            _buildDetailItem('Gender', character.gender),
            _buildDetailItem('Created', TFormatter.formatDate(character.created)),
          ]),

          /// Origin Section
          if (character.origin != null)
            _buildDetailSection('Origin', [
              ListTile(
                leading: const Icon(Icons.public, color: Colors.blue),
                title: Text(character.origin!.name),
                subtitle: Text('${character.origin!.type} • ${character.origin!.dimension}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (character.origin!.id.isNotEmpty) {
                    Get.to(() => LocationDetailPage(locationId: character.origin!.id),
                        binding: CharacterBinding());
                  }
                },
              ),
            ]),

          // Location Section
          if (character.location != null)
            _buildDetailSection('Current Location', [
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: Text(character.location!.name),
                subtitle: Text('${character.location!.type} • ${character.location!.dimension}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (character.location!.id.isNotEmpty) {

                    Get.to(
                          () => LocationDetailPage(locationId: character.location!.id),
                      binding: CharacterBinding(),
                    );
                  }
                },
              ),
            ]),

          // Episodes Section
          _buildDetailSection('Episodes (${character.episodes.length})', [
            if (character.episodes.isEmpty)
              const ListTile(
                title: Text('No episodes found'),
              ),
            for (final episode in character.episodes.take(5))
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.purple),
                title: Text(episode.name),
                subtitle: Text('${episode.episode} • ${episode.airDate}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Get.to(() => EpisodeDetailPage(episodeId: episode.id));
                },
              ),
            if (character.episodes.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {
                    /// listview of Episodes in dialog
                    Get.dialog(AllEpisodesDialog( episodes: character.episodes ));

                  },
                  child: Text(
                    'View all ${character.episodes.length} episodes',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }
  Widget _buildCharacterDetail(CharacterDetail character) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character image and basic info
          Center(
            child: Column(
              children: [
                // Clickable avatar that opens full image
                GestureDetector(
                  onTap: () {
                    _showFullImageOverlay(character.image, character.name);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(character.image),
                        radius: 80,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.zoom_in,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  character.name,
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${character.status} - ${character.species}',
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),


          _buildDetailSection('Details', [
            _buildDetailItem('Type', character.type.isNotEmpty ? character.type : 'None'),
            _buildDetailItem('Gender', character.gender),
            _buildDetailItem('Created', TFormatter.formatDate(character.created)),
          ]),

          /// Origin Section
          if (character.origin != null)
            _buildDetailSection('Origin', [
              ListTile(
                leading: const Icon(Icons.public, color: Colors.blue),
                title: Text(character.origin!.name),
                subtitle: Text('${character.origin!.type} • ${character.origin!.dimension}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (character.origin!.id.isNotEmpty) {
                    Get.to(() => LocationDetailPage(locationId: character.origin!.id),
                        binding: CharacterBinding());
                  }
                },
              ),
            ]),

          /// Location Section
          if (character.location != null)
            _buildDetailSection('Current Location', [
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: Text(character.location!.name),
                subtitle: Text('${character.location!.type} • ${character.location!.dimension}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (character.location!.id.isNotEmpty) {
                    Get.to(
                          () => LocationDetailPage(locationId: character.location!.id),
                      binding: CharacterBinding(),
                    );
                  }
                },
              ),
            ]),

          // Episodes Section
          _buildDetailSection('Episodes (${character.episodes.length})', [
            if (character.episodes.isEmpty)
              const ListTile(
                title: Text('No episodes found'),
              ),
            for (final episode in character.episodes.take(5))
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.purple),
                title: Text(episode.name),
                subtitle: Text('${episode.episode} • ${episode.airDate}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {

                },
              ),
            if (character.episodes.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {

                    /// listview of Episodes in dialog
                    Get.dialog(AllEpisodesDialog( episodes: character.episodes ));
                    },
                  child: Text(
                    'View all ${character.episodes.length} episodes',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
          ]),
        ],
      ),
    );
  }

  void _showFullImageOverlay(String imageUrl, String characterName) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            characterName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: Hero(
              tag: 'character-image-$imageUrl',
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.white, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }



}