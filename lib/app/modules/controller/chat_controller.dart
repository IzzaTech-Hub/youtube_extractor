import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:youtube_extracter/app/data/video_details.dart';
import 'package:youtube_extracter/app/widgets/no_connection_widget.dart';

class ChatController extends GetxController {
  var isTyping = false.obs;
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: "AIzaSyAMqyKN3V21hNVLqYwpMBhVb2aZ2Yi0Jn4",
  );
  final RxList<Content> messages = <Content>[].obs;
  late VideoDetails transcript;
  late int promptMessagesCount;
  Rx<bool> isConnected = true.obs;
  late StreamSubscription<InternetConnectionStatus> _connectionSubscription;

  @override
  void onInit() {
    super.onInit();
    internetConnectionCheck();
    transcript = VideoDetails.fromMap(Get.arguments[0]);
    messages.addAll(_getInitialTranscript(transcript));
    promptMessagesCount = messages.length;
    print("inital messages count $promptMessagesCount");
    messages.add(
      Content(
        'model',
        [
          TextPart(
              """Hello! I am your AI assistant, here to help you with any questions regarding '${transcript.videoTitle}'. 
Feel free to ask anything, and I'll do my best to assist you.😊

Note: All responses are generated from the video’s content to ensure accuracy and relevance.""")
        ],
      ),
    );
  }

  @override
  void onClose() {
    _connectionSubscription.cancel();
    super.onClose();
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty || isTyping.value)
      return; // Prevent duplicate calls

    isTyping.value = true;

    try {
      final chat = model.startChat(history: messages);

      // ✅ Manually add user message to messages (so it appears instantly)
      messages.add(Content('user', [TextPart(userMessage)]));
      update();

      // ✅ Fetch AI response
      final GenerateContentResponse response =
          await chat.sendMessage(Content.text(userMessage));
      // messages.removeWhere((item) => item.role == 'user');

      final String? aiResponse = response.text;

      if (aiResponse != null && aiResponse.isNotEmpty) {}
    } catch (e) {
      messages.add(
          Content('model', [TextPart("⚠️ Error: Unable to fetch response.")]));
    }
    messages.removeAt(messages.length - 2);

    isTyping.value = false;
  }

  void internetConnectionCheck() {
    final connectionChecker = InternetConnectionChecker.instance;

    _connectionSubscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          FocusManager.instance.primaryFocus?.unfocus();
          isConnected.value = true;
          print('Connected to the internet');
        } else {
          Get.bottomSheet(noConnectionWidget());
          FocusManager.instance.primaryFocus?.unfocus();
          // Get.defaultDialog();
          isConnected.value = false;
          print('Disconnected from the internet');
        }
      },
    );
  }

  void showConnectionPopup() {
    if (isConnected.value) {
    } else {
      Get.bottomSheet(noConnectionWidget());
    }
  }

  // Initial transcript messages
  List<Content> _getInitialTranscript(VideoDetails transcript) {
    return transcript.completeTranscriptHistory();
  }
}
