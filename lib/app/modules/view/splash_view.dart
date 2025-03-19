import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_extracter/app/modules/controller/splash_ctl.dart';
import 'package:youtube_extracter/app/utills/app_images.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({Key? key}) : super(key: key);
  // Obtain shared preferences.
  bool? b;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // b = controller.isFirstTime;
    return Scaffold(
    
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Expanded(
              child: Image.asset(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                AppImages.splash, // Ensure image is in assets folder
                fit: BoxFit.cover,
                      
              ),
            ),
            Positioned(
              bottom: 60,
              left: 40,
              right: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    // .grey.shade100,
                    color: Colors.grey.shade100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
