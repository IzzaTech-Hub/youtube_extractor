import 'package:get/get.dart';
import 'package:youtube_extracter/app/data/video_details.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';

class TranscriptController extends GetxController {
  //TODO: Implement TranscriptController
  late VideoDetails transcriptDetails;
  var transcriptString = "".obs;

  @override
  void onInit() {
    super.onInit();
    transcriptDetails = VideoDetails.fromMap(Get.arguments[0]);
    transcriptDetails
        .transcriptStringWithTime()
        .forEach((element) => transcriptString.value = """${element}
${transcriptString.value}""");
    print(
        "Transcript inside oninit : ${transcriptDetails.transcriptToString()}");
  }

  void navigateToChat() {
    Get.toNamed(Routes.CHAT,
        arguments: [transcriptDetails.toMap()], preventDuplicates: false);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
