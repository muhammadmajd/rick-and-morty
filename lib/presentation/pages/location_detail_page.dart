
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constents/colors.dart';
import '../../core/utils/helper/helper_functions.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/location.dart';
import '../../domain/usecases/get_location_detail.dart';
import '../controller/location_detail_controller.dart';
import 'character_detail_page.dart';

class LocationDetailPage extends StatelessWidget {
  final String locationId;

  const LocationDetailPage({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GetBuilder<LocationDetailController>(
      init: LocationDetailController(
        getLocationDetail: Get.find<GetLocationDetail>(),
        locationId: locationId,
      ),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Location Details', style: TextStyle(color: TColors.white),),
            backgroundColor:dark? TColors.darkerGrey: TColors.primary ,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: TColors.white, // Set your desired color
              ),
              onPressed: () {
                Get.back(); // Or Navigator.pop(context);
              },
            ),
          ),
          body: Obx(()=> controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.hasError.value
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${controller.errorMessage.value}'),
                  ElevatedButton(
                    onPressed: controller.loadLocationDetail,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : _buildLocationDetail(controller,context),
          ),
        );
      },
    );
  }

  Widget _buildLocationDetail(LocationDetailController controller, BuildContext context) {
    final location = controller.locationDetail.value!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location header
          Center(
            child: Column(
              children: [
                Icon(Icons.location_on, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  location.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${location.type} - ${location.dimension}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Details
          _buildDetailSection('Location Details', [
            _buildDetailItem('Type', location.type),
            _buildDetailItem('Dimension', location.dimension),
            _buildDetailItem('Residents', '${location.residents.length}'),
            _buildDetailItem('Created', _formatDate(location.created)),
          ]),

          // Residents Section
          _buildResidentsSection(location, context),
        ],
      ),
    );
  }

  Widget _buildResidentsSection(Location location, BuildContext context) {
    final residents = location.residents;

    return _buildDetailSection('Residents (${residents.length})', [
      if (residents.isEmpty)
        const ListTile(
          leading: Icon(Icons.person_off, color: Colors.grey),
          title: Text('No residents found in this location'),
        ),

      for (final resident in residents.take(10))
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(resident.image),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading errors
              },
            ),
            title: Text(
              resident.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${resident.status} - ${resident.species}'),
                if (resident.type.isNotEmpty) Text('Type: ${resident.type}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
             // Get.to(() => CharacterDetailPage(characterId: resident.id));
            },
          ),
        ),

      if (residents.length > 10)
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                _showAllResidentsDialog(residents);
              },
              child: Text('View all ${residents.length} residents'),
            ),
          ),
        ),
    ]);
  }

  void _showAllResidentsDialog(List<Character> residents) {
    Get.dialog(
      Dialog(
        child: Column(
          children: [
            AppBar(
              title: Text('All Residents (${residents.length})'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: residents.length,
                itemBuilder: (context, index) {
                  final resident = residents[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(resident.image),
                    ),
                    title: Text(resident.name),
                    subtitle: Text('${resident.status} - ${resident.species}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.back(); // Close dialog
                     // Get.to(() => CharacterDetailPage(characterId: resident.id));
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


  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }


}