import 'package:get/get.dart';
import 'package:youtube_extracter/app/modules/controller/splash_ctl.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
