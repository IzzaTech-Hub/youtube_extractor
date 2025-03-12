import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_extracter/app/modules/controller/home_view_ctl.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class HomeView extends GetView<HomeViewCtl> {
 const HomeView({super.key});



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Transcript Extractor",style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          
          
        ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF2828),
      ),
  body: SingleChildScrollView(
    child: Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6.2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                // colors: [Color(0xFFFF6D00), Color.fromARGB(255, 255, 208, 0)],
                colors: [Color(0xFFFF2828), Color(0xFFC40000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6),
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
                  'AI YouTube Extractor',
                  style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 7.3,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                verticalSpace(SizeConfig.blockSizeVertical * 3),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 8),
                  ),
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: controller.urlController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Paste YouTube URL here...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      prefixIcon: GestureDetector(
                        onTap: ()async{
                           ClipboardData? clipboardData =
                                  await Clipboard.getData(Clipboard.kTextPlain);
                              if (clipboardData != null &&
                                  clipboardData.text != null) {
                                controller.urlController.text = clipboardData
                                    .text!; // Set text to controller
                                controller.urlController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: controller
                                          .urlController.text.length),
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
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
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
                          onTap: (){
                             controller.startExtraction();
                          },
                          child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.blockSizeHorizontal * 28,
                          decoration: BoxDecoration(
                          boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                          
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeHorizontal * 10),
                          ),
                          child: Center(
                            child: Text( 'Extract',
                                style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 4.1,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins',)),
                          )),
                        );
                      
                }),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
    );
  }
}