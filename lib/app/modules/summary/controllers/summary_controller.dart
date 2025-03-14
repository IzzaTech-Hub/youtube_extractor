import 'package:get/get.dart';
import 'package:youtube_extracter/app/data/video_details.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';

class SummaryController extends GetxController {
  //TODO: Implement SummaryController
  var summary = "".obs;
  late VideoDetails transcriptDetails;

  @override
  void onInit() {
    super.onInit();
    summary.value = Get.arguments[0];
    transcriptDetails = Get.arguments[1];
  }

  @override
  void onClose() {
    super.onClose();
  }

  void navigateToChat() {
    Get.toNamed(Routes.CHAT,
        arguments: [transcriptDetails.toMap()], preventDuplicates: false);
  }
}
