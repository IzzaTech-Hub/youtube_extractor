import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:youtube_extracter/app/modules/summary/controllers/summary_controller.dart';
import 'package:youtube_extracter/app/utills/colors.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';
import 'package:youtube_extracter/app/widgets/start_feedback_widget.dart';

class SummaryView extends GetView<SummaryController> {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    int widgetSize = 12;
    SizeConfig().init(context); // Initialize SizeConfig
    AppColors();

    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        distance: 105,
        fanAngle: 100,
        duration: Durations.long1,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
            backgroundColor: AppColors.fabSideButtonBackground,
            foregroundColor: const Color.fromARGB(255, 243, 243, 243),
            child: Icon(
              SimpleIcons.element,
              size: SizeConfig.blockSizeHorizontal * 7.7,
            )),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.fabMainButtonBackground,
            child: Icon(Icons.close)),
        overlayStyle: ExpandableFabOverlayStyle(
            blur: 4, color: Color.fromARGB(64, 255, 255, 255)),
        children: [
          StarFeedbackWidget(
            size: widgetSize,
            mainContext: context,
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: AppColors.fabSideButtonBackground,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                controller.navigateToChat();
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * widgetSize,
                height: SizeConfig.blockSizeHorizontal * widgetSize,
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
                    ClipboardData(text: controller.summary.value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Summary copied to clipboard!")),
                );
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * widgetSize,
                height: SizeConfig.blockSizeHorizontal * widgetSize,
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
                Share.share(controller.summary.value, subject: "Video Summary");
              },
              child: Container(
                width: SizeConfig.blockSizeHorizontal * widgetSize,
                height: SizeConfig.blockSizeHorizontal * widgetSize,
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
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.copy,
          //         color: Colors.white,
          //         size: SizeConfig.blockSizeHorizontal * 6),
          //     onPressed: () {
          //       Clipboard.setData(
          //           ClipboardData(text: controller.summary.value));
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text("Summary copied to clipboard!")),
          //       );
          //     },
          //   ),
          // ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          )),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: Markdown(
          data: controller.summary.value,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 6,
                fontWeight: FontWeight.bold),
            p: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 4, height: 1.5),
            strong: TextStyle(fontWeight: FontWeight.bold),
            blockquote: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
              fontSize: SizeConfig.blockSizeHorizontal * 4,
            ),
          ),
        ),
      ),
    );
  }
}
