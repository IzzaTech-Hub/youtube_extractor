import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_extracter/app/data/video_details.dart';
import 'package:youtube_extracter/app/routes/app_pages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer' as developer;

import 'package:youtube_extracter/app/utills/remoteconfig_variables.dart';

class HomeViewCtl extends GetxController {
  final urlController = TextEditingController();
  var isLoading = false.obs;
  var loadingMessage = "".obs;
  var transcriptList = <String>[].obs;
  var videoTitle = "".obs;
  var videoAuthor = "".obs;
  var videoDescription = "".obs;
  Rx<int> responseStatus = 0.obs;
  RxMap<String, dynamic> mappedTranscript = <String, dynamic>{}.obs;
  var isUrlProcessed = false.obs;
  late VideoDetails transcript;
  bool isBackPressed = false;
  List<String> loadingMotivationMessages = [
    "Your time matters. We make it count.",
    "Simplify. Summarize. Stay ahead.",
    "Less waiting, more creating.",
    "Designed for you, powered by AI.",
    "Because every second counts."
  ];

  Future<void> fetchVideoDetails(String videoUrl) async {
    try {
      final yt = YoutubeExplode();
      final video = await yt.videos.get(videoUrl);
      print("video title : $video");
      videoTitle.value = video.title;
      videoAuthor.value = video.author;
      videoDescription.value = video.description;
      yt.close();
    } catch (e) {
      videoTitle.value = "Unknown Title";
    }
  }

  void startExtraction() async {
    if (urlController.text == "") {
      Get.snackbar(
        'Empty URL',
        'Please enter the url.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[400],
        colorText: Colors.white,
      );
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard
    loadingMessage.value = "Checking network connectivty...";
    isLoading.value = true;
    final videoUrl = urlController.text.trim();
    final youtubeRegex = RegExp(
        r'^(https?:\/\/)?(www\.)?(youtube\.com\/(watch\?v=|shorts\/)|youtu\.be\/)([A-Za-z0-9_-]{11})');
    if (videoUrl.isEmpty || !youtubeRegex.hasMatch(videoUrl)) {
      Get.snackbar(
        'Invalid url',
        'Please enter a valid YouTube URL.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      setToDefault();
      return;
    }
    if (await checkNetworkConnection()) {
      loadingMessage.value = "Validating the URL...";
      // YouTube URL validation regex
      try {
        // await Future.delayed(Duration(seconds: 1));
        loadingMessage.value = "Analyzing video content...";
        // Fetch video details
        await fetchVideoDetails(videoUrl);
        transcriptList.clear();

        final captionScraper = YouTubeCaptionScraper();
        final captionTracks = await captionScraper.getCaptionTracks(videoUrl);
        developer.log("caption tracks: ${captionTracks[0]}");

        if (captionTracks.isEmpty) {
          Get.snackbar(
            'Oops!',
            "Unable to process the selected video. Please try again with a different one.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[400],
            colorText: Colors.white,
          );
          throw Exception("No captions available for this video.");
        }

        final subtitle = await captionScraper.getSubtitles(captionTracks[0]);
        // print("subtitle: $subtitle");
        // print("videoUrl: $videoUrl");
        // var yt = YoutubeExplode();

        // var trackManifest =
        //     await yt.videos.closedCaptions.getManifest(videoUrl);
        // // await yt.videos.closedCaptions.getManifest(videoUrl);
        // print("trackManifest: ${trackManifest.tracks[0].language}");
        // var trackInfo = trackManifest.tracks; // Get all caption.
        // // var trackInfo =
        // //     trackManifest.getByLanguage('Englisg'); // Get english caption.
        // print("trackInfo: $trackInfo");
        // // String subtitle = "";
        // if (trackInfo != null) {
        //   print("here"); // Get the actual closed caption track.
        //   // var track = await yt.videos.closedCaptions.get(trackInfo[0]);
        //   // print("track: $track");
        //   // // Get the caption displayed at 1:01
        //   // var caption = track.getByTime(Duration(seconds: 61));
        //   // print("caption: $caption");
        //   // subtitle = caption?.text ?? ""; // "And the game was afoot."
        //   // print("subtitle: $subtitle");
        // }

        // loadingMessage.value = "Initializing your AI assistant...";
        // await Future.delayed(Duration(milliseconds: 1000));
//-------------------------------------------------------------------------------------------------------------------------------------
        // Use Gemini to generate subtitles from video details
//         final model = GenerativeModel(
//           model: 'gemini-2.5-pro',
//           apiKey: RCVariables.apiKey,
//         );

//         final prompt = '''
// This is vedio Url: $videoUrl
// Give me exact word by word transcript nerator is saying in this vedio
// ''';

//         final response = await model.generateContent([Content.text(prompt)]);
//         final subtitle = response.text ?? '';
//         print("prompt: $prompt");
//         print("subtitle: $subtitle");
//-------------------------------------------------------------------------------------------------------------------------------------

        responseStatus.value = 200;
        mappedTranscript.value = {
          "transcriptList": subtitle,
          "videoAuthor": videoAuthor.value,
          "videoTitle": videoTitle.value,
          "videoDescription": videoDescription.value
        };
        // loadingMessage.value = "Finalizing setup – almost ready!";
        // await Future.delayed(Duration(seconds: 2));

        transcript = VideoDetails.fromMap(mappedTranscript);
        transcriptList.value = transcript.transcriptStringWithTime();
        videoTitle.value = transcript.videoTitle;
        videoAuthor.value = transcript.videoAuthor;
        developer.log(
            "transcriptList length ${transcriptList.length}, transcript ${transcript.transcriptList}");
        // loadingMessage.value = "Your AI assistant is ready! 🎯";
        // await Future.delayed(Duration(seconds: 1));
        isUrlProcessed.value = true;
        // navigateToChat();
      } catch (e) {
        responseStatus.value = 400;
        Get.snackbar(
          'Oops!',
          "Unable to process the selected video. Please try again with a different one.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
        );
        setToDefault();
      } finally {
        setToDefault(
            setVideoAuthor: false,
            setVideoTitle: false,
            setIsUrlProcessed: false);
      }
    } else {
      setToDefault();
      Get.snackbar(
        'No Internet',
        'Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[400],
        colorText: Colors.white,
      );
    }
  }

  Future<void> generateSummary() async {
    try {
      final model = GenerativeModel(
        model: RCVariables.geminiModel,
        apiKey: RCVariables.apiKey,
      );
      // Indicate processing (if using a loading state)
      isLoading.value = true;
      loadingMessage.value = "Checking internet connection...";
      if (!await checkNetworkConnection()) {
        Get.snackbar(
          'No Internet',
          'Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[400],
          colorText: Colors.white,
        );
      }
      loadingMessage.value = "Building summary...";

      List<Content> transcriptList = await transcript.transcriptForSummary();

      if (transcriptList.isEmpty) {
        throw Exception("No transcript data available.");
      }

      // final chat = model.startChat(history: transcriptList);
      final videoUrl = urlController.text.trim();

      var prompt =
          """Generate a well-structured and clearly formatted summary of youtube vedio $videoUrl  
Ensure the summary is segmented into paragraphs for readability.  
title of vedio is $videoTitle, Description: $videoDescription, Author: $videoAuthor
Use Markdown formatting as follows:  
- **Bold** speaker names, followed by a **relevant** timestamp in `[hh:mm:ss]` format to indicate major topic shifts.  
- Use headings (`#`, `##`, `###`, etc.) to indicate key sections of the discussion.  
- Highlight key points using bullet points or numbered lists when necessary.  
- Format technical terms or significant phrases using code blocks.  
- Use blockquotes to emphasize important statements or takeaways.  

""";
//       var prompt =
//           """Generate a well-structured and clearly formatted summary of the given transcript.
// Ensure the summary is segmented into paragraphs for readability.

// Use Markdown formatting as follows:
// - **Bold** speaker names, followed by a **relevant** timestamp in `[hh:mm:ss]` format to indicate major topic shifts.
// - Use headings (`#`, `##`, `###`, etc.) to indicate key sections of the discussion.
// - Highlight key points using bullet points or numbered lists when necessary.
// - Format technical terms or significant phrases using code blocks.
// - Use blockquotes to emphasize important statements or takeaways.

// Timestamps should be placed only at points where the topic significantly shifts, **not for every sentence**.
// Ensure the summary flows naturally, maintaining clarity and coherence.
// Deliver the response **as plain text**, without enclosing it in any container.
// Do not include any introductory or concluding messages—only the structured summary itself.

// """;

      GenerateContentResponse response =
          await model.generateContent([Content.text(prompt)]);
      // await chat.sendMessage(Content.text(prompt));
      print("This is summary: ${response.text}");

      if (response.text == null || response.text!.trim().isEmpty) {
        // Retry once before throwing an error
        response = await model.generateContent([Content.text(prompt)]);

        // response = await chat.sendMessage(Content.text(prompt));
        if (response.text == null || response.text!.trim().isEmpty) {
          Get.snackbar(
            'Server error',
            'Please try again later.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(206, 255, 17, 17),
            colorText: Colors.white,
          );
          throw Exception("AI response was empty. Please try again.");
        }
      }

      loadingMessage.value = "Your transcript is ready! ";
      await Future.delayed(Duration(seconds: 1));
      Get.toNamed(Routes.SUMMARY,
          arguments: [response.text, transcript], preventDuplicates: false);

      // return response.text!;
    } catch (e) {
      String errorMessage = e.toString();
      // String errorTitle = "";

      // if (errorMessage.contains("No transcript data available")) {
      //   errorTitle = "Transcript Missing";
      // } else if (errorMessage.contains("AI response was empty")) {
      //   errorTitle = "AI Response Error";
      // } else {
      //   errorTitle = "Summary Generation Failed";
      // }

      Get.snackbar(
        "Server Error",
        "Please try again later..",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        // mainButton: TextButton(
        //   onPressed: () => generateSummary(), // Retry button
        //   child: Text("Retry", style: TextStyle(color: Colors.white)),
        // ),
      );

      print("Error generating summary: $errorMessage");
      setToDefault(
          setVideoAuthor: false,
          setVideoTitle: false,
          setIsUrlProcessed: false);
      // return "An issue occurred while generating the summary. Please try again.";
    } finally {
      // Remove loading state after execution
      await setToDefault(
          setVideoAuthor: false,
          setVideoTitle: false,
          setIsUrlProcessed: false);
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

  void navigateToChat() async {
    isLoading.value = true;
    loadingMessage.value = "Initializing your AI assistant...";
    await Future.delayed(Duration(milliseconds: 1000));
    loadingMessage.value = "Your AI assistant is ready! 🎯";
    await Future.delayed(Duration(seconds: 1));
    Get.toNamed(Routes.CHAT,
        arguments: [mappedTranscript.value], preventDuplicates: false);
    await setToDefault(
        setVideoAuthor: false, setVideoTitle: false, setIsUrlProcessed: false);
  }

  void navigateToTranscript() async {
    isLoading.value = true;
    loadingMessage.value = "Processing the transcript...";
    await Future.delayed(Duration(milliseconds: 1000));
    loadingMessage.value = "Your transcript is ready! 🎯";
    await Future.delayed(Duration(seconds: 1));
    Get.toNamed(Routes.TRANSCRIPT,
        arguments: [mappedTranscript.value], preventDuplicates: false);
    await setToDefault(
        setVideoAuthor: false, setVideoTitle: false, setIsUrlProcessed: false);
  }

  Future<void> setToDefault(
      {bool setLoading = true,
      bool setLoadingMessage = true,
      bool setTranscriptList = true,
      bool setVideoTitle = true,
      bool setVideoAuthor = true,
      bool setIsUrlProcessed = true}) async {
    isLoading.value = setLoading ? false : isLoading.value;

    loadingMessage.value = setLoadingMessage ? "" : loadingMessage.value;

    transcriptList.value = setTranscriptList ? <String>[] : transcriptList;

    videoTitle.value = setVideoTitle ? "" : videoTitle.value;

    videoAuthor.value = setVideoAuthor ? "" : videoAuthor.value;

    isUrlProcessed.value = setIsUrlProcessed ? false : isUrlProcessed.value;
  }

  Future<bool> backButtonHandle() async {
    if (isBackPressed) {
      return true; // Exit app if pressed within 1.5 sec
    }

    isBackPressed = true;
    Fluttertoast.showToast(
      msg: "Press back again to exit",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );

    // Reset back press state after 1.5 seconds
    Future.delayed(Duration(milliseconds: 1500), () {
      isBackPressed = false;
    });

    return false; // Prevent exit on first press
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
  //     setToDefault();
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
