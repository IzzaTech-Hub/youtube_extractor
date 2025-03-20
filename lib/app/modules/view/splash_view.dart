import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_extracter/app/modules/controller/splash_ctl.dart';
import 'package:youtube_extracter/app/utills/images.dart';
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
    
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF8D0303),Color(0xFFD64847)],begin: Alignment.topLeft,end: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "VidAssist AI",
              style: GoogleFonts.lemonada(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 12),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 5
                  )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(AppImages.main_icon,
                
                width: SizeConfig.blockSizeHorizontal * 40,),
              ),
            ),
             verticalSpace(SizeConfig.blockSizeVertical * 8),
             Text(
              "Ai video Transcript\n & \nSummarizer",
              textAlign: TextAlign.center,
              
              style: GoogleFonts.lemonada(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.8
              ),
            ),
            // verticalSpace(
            //   SizeConfig.blockSizeVertical *5
            // ),
            Padding(
              padding:  EdgeInsets.only(top:150,right: 60,left: 60 ),
              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Same radius as the container
                                child: LinearProgressIndicator(
                                    minHeight: 6,
                                    backgroundColor: Colors.white.withOpacity(0.1),
                                    // color: Colors.purple
                                    color: 
                                    Colors.white,
                                    ),
                              ),
            ),
          ],
        ),
      )
    );
  }
}
