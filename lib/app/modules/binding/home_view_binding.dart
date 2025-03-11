import 'package:get/get.dart';
import 'package:youtube_extracter/app/modules/controller/home_view_ctl.dart';

class HomeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewCtl());
  }
}
