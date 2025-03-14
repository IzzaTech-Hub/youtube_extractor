import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:youtube_extracter/app/modules/controller/home_view_ctl.dart';
import 'package:youtube_extracter/app/utills/colors.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class HomeView extends GetView<HomeViewCtl> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          return controller.backButtonHandle();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Transcript Extractor",
              style: TextStyle(
                fontSize: SizeConfig.blockSizeHorizontal * 5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFFFF2828),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: controller.isLoading.value
              ? loadingWidget()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 8),
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.all(
                              SizeConfig.blockSizeHorizontal * 6.2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              // colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              // colors: [Color(0xFFFF6D00), Color.fromARGB(255, 255, 208, 0)],
                              colors: [Color(0xFFFF2828), Color(0xFFC40000)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeHorizontal * 6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_filled,
                                size: SizeConfig.blockSizeHorizontal * 15.7,
                                color: Colors.white,
                              ),
                              verticalSpace(SizeConfig.blockSizeVertical * 2),
                              Text(
                                controller.videoAuthor.value != ""
                                    ? controller.videoAuthor.value
                                    : 'AI YouTube Extractor',
                                style: GoogleFonts.akatab(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 7.3,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              verticalSpace(SizeConfig.blockSizeVertical * 3),
                              controller.isUrlProcessed.value
                                  ? optionsWidget()
                                  : urlAndExtract(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Column urlAndExtract() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
          ),
          child: TextField(
            cursorColor: Colors.white,
            controller: controller.urlController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Paste YouTube URL here...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: GestureDetector(
                onTap: () async {
                  ClipboardData? clipboardData =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  if (clipboardData != null && clipboardData.text != null) {
                    controller.urlController.text =
                        clipboardData.text!; // Set text to controller
                    controller.urlController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: controller.urlController.text.length),
                    ); // Move cursor to the end
                  }
                },
                child: Icon(
                  Icons.link,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        verticalSpace(SizeConfig.blockSizeVertical * 3),
        Obx(() {
          return controller.isLoading.value
              ? Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    verticalSpace(SizeConfig.blockSizeVertical * 2),
                    Text(
                      'Processing...',
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 3,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  onTap: () {
                    controller.startExtraction();
                  },
                  child: Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      width: SizeConfig.blockSizeHorizontal * 48,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 2),
                              child: Icon(
                                Icons.autorenew,
                                color: Colors.red,
                                size: SizeConfig.blockSizeHorizontal * 6.3,
                              ),
                            ),
                            Text('Begin Processing',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.1,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',
                                )),
                          ],
                        ),
                      )),
                );
        }),
      ],
    );
  }

  Widget optionsWidget() {
    return Obx(
      () => Column(
        children: [
          controller.videoTitle.value != ""
              ? Container(
                  padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 150, 150)
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 8),
                  ),
                  child: Text(
                    controller.videoTitle.value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.alata(
                        color: Colors.white,
                        fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                        fontWeight: FontWeight.w600),
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
                bottom: SizeConfig.blockSizeVertical * 4.5,
                top: SizeConfig.blockSizeVertical * 4),
            child: GestureDetector(
              onTap: () {
                controller.setToDefault();
              },
              child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 10),
                      ),
                    ],
                    color: const Color.fromARGB(255, 255, 56, 42),
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal * 1.5),
                          child: Icon(
                            size: SizeConfig.blockSizeHorizontal * 7,
                            Icons.restart_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Text('Try Another Video',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4.1,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            )),
                      ],
                    ),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.generateSummary();
                  },
                  child: Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      width: SizeConfig.blockSizeHorizontal * 38,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 9,
                            offset: Offset(0, 12),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 2),
                              child: Icon(
                                Icons.feed_outlined,
                                color: Colors.red,
                                size: SizeConfig.blockSizeHorizontal * 6.5,
                              ),
                            ),
                            Text('Summarize',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.1,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',
                                )),
                          ],
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    controller.navigateToTranscript();
                  },
                  child: Container(
                      height: SizeConfig.blockSizeVertical * 5,
                      width: SizeConfig.blockSizeHorizontal * 36,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 9,
                            offset: Offset(0, 12),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeHorizontal * 10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.blockSizeHorizontal * 3),
                              child: Icon(Icons.format_list_bulleted_outlined,
                                  color: Colors.red),
                            ),
                            Text('Transcript',
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 4.1,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',
                                )),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
            child: GestureDetector(
              onTap: () {
                controller.navigateToChat();
              },
              child: Container(
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal * 32,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 9,
                        offset: Offset(0, 12),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeHorizontal * 10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.blockSizeHorizontal * 3),
                          child: Icon(
                            SimpleIcons.microbit,
                            color: Colors.red,
                            size: SizeConfig.blockSizeHorizontal * 6,
                          ),
                        ),
                        Text('Ask AI',
                            style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4.1,
                              color: Colors.red,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            )),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFFFF2828),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color.fromARGB(255, 255, 255, 255),
                size: SizeConfig.blockSizeHorizontal * 30,
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4.5),
              child: Text(
                controller.loadingMessage.value,
                textAlign: TextAlign.center,
                style: GoogleFonts.actor(
                    color: Colors.white,
                    textStyle: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                      fontWeight: FontWeight.w900,
                    )),
              ))
        ],
      ),
    );
  }
}
