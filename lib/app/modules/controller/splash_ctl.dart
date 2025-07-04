import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:youtube_extracter/app/provider/admob_ads_provider.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';

class SplashController extends GetxController {

  
  RxInt percent = 0.obs;
  RxBool isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // AdMobAdsProvider.instance.loadInterstitialAd();
    _startTimerAndAdSequence();
  }

  void _startTimerAndAdSequence() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      percent.value = i;
    }
bool adShown = false;

 AdMobAdsProvider.instance.showInterstitialAd(() {
    adShown = true;
    Get.offNamed(Routes.HOMEVIEW);
  });

  // Fallback: if ad not shown in 3 seconds, navigate anyway
  Future.delayed(const Duration(seconds: 3), () {
    if (!adShown) {
      Get.offNamed(Routes.HOMEVIEW);
    }
  });
  }







  // var tabIndex = 0.obs;
  // Rx<int> percent = 0.obs;
  // Rx<bool> isLoaded = false.obs;
  // @override
  // void onInit() async {
  //   super.onInit();
  //   // await RemoteConfigService().initialize();
  //   // AppLovinProvider.instance.init();

  //   // AppLovinProvider.instance.init();
  //   Timer? timer;
  //   timer = Timer.periodic(Duration(milliseconds: 500), (_) {
  //     int n = Random().nextInt(10) + 5;
  //     percent.value += n;
  //     if (percent.value >= 100) {
  //       percent.value = 100;
  //       Get.offNamed(Routes.HOMEVIEW);



  //       // isLoaded.value = true;

  //       timer!.cancel();
  //     }
  //   });

  //   // prefs.then((SharedPreferences pref) {
  //   //   isFirstTime = pref.getBool('first_time') ?? true;

  //   //   print("Is First Time from Init: $isFirstTime");
  //   // });
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {}

  // // void setFirstTime(bool bool) {
  // //   prefs.then((SharedPreferences pref) {
  // //     pref.setBool('first_time', bool);
  // //     print("Is First Time: $isFirstTime");
  // //   });
  // // }
}
