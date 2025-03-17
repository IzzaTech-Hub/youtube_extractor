import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:youtube_extracter/app/utills/colors.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

import '../controllers/transcript_controller.dart';

class TranscriptView extends GetView<TranscriptController> {
  const TranscriptView({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig
    AppColors();

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
            backgroundColor: AppColors.fabMainButtonBackground,
            foregroundColor: const Color.fromARGB(255, 243, 243, 243),
            child: Icon(
              SimpleIcons.element,
              size: SizeConfig.blockSizeHorizontal * 7,
            )),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.fabMainButtonBackground,
            child: Icon(Icons.close)),
        overlayStyle: ExpandableFabOverlayStyle(
            blur: 4, color: Color.fromARGB(64, 255, 255, 255)),
        children: [
          Material(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.fabSideButtonBackground,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                controller.navigateToChat();
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 13,
                height: SizeConfig.blockSizeHorizontal * 13,
                child: Icon(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: SizeConfig.blockSizeHorizontal * 6,
                  SimpleIcons.dependabot,
                ),
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.fabSideButtonBackground,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: controller.transcriptString.value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Transcript copied to clipboard!")),
                );
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 13,
                height: SizeConfig.blockSizeHorizontal * 13,
                child: Icon(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: SizeConfig.blockSizeHorizontal * 6,
                  Icons.copy,
                ),
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.fabSideButtonBackground,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Share.share(controller.transcriptString.value,
                    subject: "Video Transcript");
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * 13,
                height: SizeConfig.blockSizeHorizontal * 13,
                child: Icon(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: SizeConfig.blockSizeHorizontal * 6,
                  Icons.share,
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
          title: Text(
            controller.transcriptDetails.videoTitle,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          )),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        margin: EdgeInsets.only(
            right: SizeConfig.blockSizeHorizontal * 4,
            left: SizeConfig.blockSizeHorizontal * 4,
            top: SizeConfig.blockSizeHorizontal * 4),
        child: ListView.builder(
          itemCount: controller.transcriptDetails.transcriptList.length,
          itemBuilder: (context, index) {
            final subtitle = controller.transcriptDetails.transcriptList[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 1.1),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${controller.transcriptDetails.formatDuration(subtitle.start)} - "
                          "${controller.transcriptDetails.formatEndTime(subtitle.start, subtitle.duration)} : ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: subtitle.text,
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
