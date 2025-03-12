import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_extracter/app/data/video_details.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';

class HomeViewCtl extends GetxController {
  final urlController = TextEditingController();
  var isLoading = false.obs;

  var transcriptList = <String>[].obs;
  var videoTitle = "".obs;
  var videoAuthor = "".obs;
  Rx<int> responseStatus = 0.obs;
  RxMap<String, dynamic> mappedTranscript = <String, dynamic>{}.obs;

  Future<void> fetchVideoDetails(String videoUrl) async {
    try {
      final yt = YoutubeExplode();
      final video = await yt.videos.get(videoUrl);
      print("video title : $video");
      videoTitle.value = video.title;
      videoAuthor.value = video.author;
      yt.close();
    } catch (e) {
      videoTitle.value = "Unknown Title";
    }
  }
  
void startExtraction() async {
  FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard
  isLoading.value = true;

  if (await checkNetworkConnection()) {
    final videoUrl = urlController.text.trim();

    // YouTube URL validation regex
    final youtubeRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|shorts\/)|youtu\.be\/)([A-Za-z0-9_-]{11})'
    );

    try {
      if (videoUrl.isEmpty || !youtubeRegex.hasMatch(videoUrl)) {
        Get.snackbar(
          'Error',
          'Please enter a valid YouTube URL.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Fetch video details
      await fetchVideoDetails(videoUrl);
      transcriptList.clear();

      final captionScraper = YouTubeCaptionScraper();
      final captionTracks = await captionScraper.getCaptionTracks(videoUrl);

      if (captionTracks.isEmpty) {
        throw Exception("No captions available for this video.");
      }

      final subtitles = await captionScraper.getSubtitles(captionTracks[0]);

      responseStatus.value = 200;
      mappedTranscript.value = {
        "transcriptList": subtitles,
        "videoAuthor": videoAuthor.value,
        "videoTitle": videoTitle.value
      };

      VideoDetails transcript = VideoDetails.fromMap(mappedTranscript);
      transcriptList.value = transcript.transcriptStringWithTime();

      print("transcriptList length ${transcriptList.length}");
      navigateToChat();
    } catch (e) {
      responseStatus.value = 400;
      Get.snackbar(
        'Error',
        'Could not fetch transcript. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  } else {
    isLoading.value = false;
    Get.snackbar(
      'No Internet',
      'Please check your internet connection.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange[400],
      colorText: Colors.white,
    );
  }
}



  Future<bool> checkNetworkConnection() async {
    final bool isConnected =
        await InternetConnectionChecker.instance.hasConnection;
    if (isConnected) {
      print('Device is connected to the internet');
      return true;
    } else {
      Get.snackbar("Internet Connection Failed",
          "Failed to connect to internet, Please try again later.");
      print('Device is not connected to the internet');
      return false;
    }
  }

  void navigateToChat() {
    Get.toNamed(Routes.CHAT, arguments: [mappedTranscript.value]);
  }

  // void startExtraction() {
  //   final url = urlController.text.trim();
  //   if (url.isEmpty) {
  //     Get.snackbar(
  //       'Error',
  //       'Please paste a valid YouTube URL.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red[400],
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   isLoading.value = true;

  //   // Simulate API call (replace with actual API call)
  //   Future.delayed(Duration(seconds: 3), () {
  //     isLoading.value = false;
  //     Get.snackbar(
  //       'Success',
  //       'Extraction complete! Check your results.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green[400],
  //       colorText: Colors.white,
  //     );
  //   });
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
