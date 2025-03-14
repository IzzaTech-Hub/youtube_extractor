import 'package:get/get.dart';

import '../controllers/transcript_controller.dart';

class TranscriptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TranscriptController>(
      () => TranscriptController(),
    );
  }
}
