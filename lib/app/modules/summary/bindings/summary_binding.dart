import 'package:get/get.dart';

import '../controllers/summary_controller.dart';

class SummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SummaryController>(
      () => SummaryController(),
    );
  }
}
