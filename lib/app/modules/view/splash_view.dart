
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:youtube_extracter/app/modules/controller/splash_ctl.dart';
import 'package:youtube_extracter/app/provider/admob_ads_provider.dart';
import 'package:youtube_extracter/app/utills/app_images.dart';
import 'package:youtube_extracter/app/utills/app_string.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({Key? key}) : super(key: key);

    // // // Banner Ad Implementation start // // //
//? Commented by jamal start
  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

  initBanner() {
    BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        isBannerLoaded.value = true;
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) {
        print('Ad opened.');
      },
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Ad closed.');
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) {
        print('Ad impression.');
      },
    );

    myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
    myBanner.load();
  } //? Commented by jamal end

  /// Banner Ad Implementation End ///

  // Obtain shared preferences.
  bool? b;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    initBanner();
    // b = controller.isFirstTime;
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        color: Colors.white,
       
        child: Column(
          children: [
           
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 12),
              width: SizeConfig.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      AppImages.main_icon,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: SizeConfig.blockSizeHorizontal * 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            // Opacity(
            //   opacity: 0.7,
            //   child: Container(
            //     width: SizeConfig.screenWidth,
            //     height: SizeConfig.screenHeight,
            //     color: Colors.black,
            //   ),
            // ),
      
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // verticalSpace(SizeConfig.blockSizeVertical * 5),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 10),
                    child: Text("VidAssist AI",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeHorizontal * 6,
                            fontWeight: FontWeight.bold)),
                  ),
                  verticalSpace(SizeConfig.blockSizeVertical * 1),
                  Text("AI Video Summarizer",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.blockSizeHorizontal * 3,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 5),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 15,
                            right: SizeConfig.blockSizeHorizontal * 15,
                            left: SizeConfig.blockSizeHorizontal * 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as per your requirement
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Same radius as the container
                            child:  Obx(() => LinearProgressIndicator(
        value: controller.percent.value / 100,
        backgroundColor: Colors.grey.shade100,
        color: Color(0xFFE33130),
        minHeight: 6,
      )),
                            // LinearProgressIndicator(
                            //     minHeight: 6,
                            //     backgroundColor: Colors.grey.shade100,
                            //     color: AppColors.primaryColor),
                          ),
                        )),

                         verticalSpace(SizeConfig.blockSizeVertical * 10),

                          Obx(() => isBannerLoaded.value &&
                    AdMobAdsProvider.instance.isAdEnable.value
                ? Container(
                    height: AdSize.banner.height.toDouble(),
                    child: AdWidget(ad: myBanner))
                : Container(
                 
                )), 
                    // Container(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: SizeConfig.blockSizeHorizontal * 15),
                    //   width: SizeConfig.screenWidth,
                    //   child: Center(
                    //     child: Obx(() => LinearPercentIndicator(
                    //           width: SizeConfig.screenWidth * .65,
                    //           lineHeight: SizeConfig.blockSizeVertical,
                    //           percent: controller.percent.value / 100,
      
                    //           // center: new Text("${controller.percent.value} %"),
                    //           backgroundColor: Colors.white,
                    //           progressColor: Colors.red,
                    //         )),
                    //   ),
                    // ),
      
                    // verticalSpace(SizeConfig.blockSizeVertical * 5),
                    // Text("All Video Downloader",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold)),
                    // Text("(Download Your favorite videos)",
                    //     style: TextStyle(
                    //         color: Colors.black,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            // _nativeAd(),
            // Align(
            //     alignment: Alignment.topCenter,
            //     child: Container(
            //       margin:
            //           EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            //       child: Container(
            //           width: SizeConfig.screenWidth,
            //           height: controller
            //               .googleAdsCT.myBannersplashScreen!.size.height
            //               .toDouble(),
            //           child: Center(
            //             child: AdWidget(
            //               ad: controller.googleAdsCT.myBannersplashScreen!,
            //             ),
            //           )),
      
            //       // ),
            //     )),
          ],
        ),
      ),
      // floatingActionButton: Obx(() => controller.isLoaded.value
      //     ? FloatingActionButton(
      //         backgroundColor: Color(0xFFF12073),
      //         onPressed: () {
      //           print("Is First Time: ${controller.isFirstTime}");
      //           // controller.appLovin_CTL.showInterAd();

      //           if (controller.isFirstTime!) {
      //             controller.setFirstTime(false);
      //             Get.offAndToNamed(Routes.HOW_TO_SCREEN);
      //           } else {
      //             Get.offAndToNamed(Routes.TabsScreenView);
      //           }
      //         },
      //         child: Icon(
      //           Icons.arrow_forward,
      //           color: Colors.white,
      //         ),
      //       )
      //     : Container()),
    );
  }
}
