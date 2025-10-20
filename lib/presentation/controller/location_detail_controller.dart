
import 'package:get/get.dart';
import '../../domain/usecases/get_location_detail.dart';
import '../../domain/entities/location.dart';

class LocationDetailController extends GetxController {
  final GetLocationDetail getLocationDetail;
  final String locationId;

  LocationDetailController({
    required this.getLocationDetail,
    required this.locationId,
  });

  final Rx<Location?> locationDetail = Rx<Location?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadLocationDetail();
  }

  Future<void> loadLocationDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = null;

      final location = await getLocationDetail(locationId);
      locationDetail.value = location;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}