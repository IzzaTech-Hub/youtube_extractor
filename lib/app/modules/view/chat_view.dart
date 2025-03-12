import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:youtube_extracter/app/modules/controller/chat_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class ChatView extends GetView<ChatController> {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  centerTitle: true,
  title: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "Chat View",
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeConfig.blockSizeHorizontal * 5,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: 8), // Space between title and bottom text
    ],
  ),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(10),
    child: Padding(
      padding: EdgeInsets.only(bottom: 8,right: 8,left: 8),
      child: Text(
        "Title: ${controller.transcript.videoTitle}",
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ),
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFFF2828), Color(0xFFD32F2F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
    onPressed: () => Get.back(),
  ),
),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(12),
                itemCount: controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  print("current on going index $index");
                  if (index == controller.messages.length) {
                    return _typingIndicator();
                  }
                  final message = controller.messages[index];
                  return _chatBubble(
                      message.parts!.isNotEmpty
                          ? (message.parts!.first as TextPart).text
                          : "No content",
                      message.role == 'user',
                      index,
                      controller.promptMessagesCount);
                },
              );
            }),
          ),

          // Message Input Field
          Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
              child: _chatInputField()),
        ],
      ),
    );
  }

  Widget _chatBubble(
      String text, bool isUser, int currentIndex, int promptMessageCount) {
    return currentIndex <= promptMessageCount - 1
        ? Container()
        : Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isUser ? Color(0xFFFF2828) : Color(0xFFF1F1F1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20 : 0),
                  topRight: Radius.circular(isUser ? 0 : 20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: MarkdownBody(
                data: text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(color: isUser ? Colors.white : Colors.black),
                ),
              ),
            ),
          );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(width: 8),
            Text("Typing...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _chatInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                absorbing: !controller.isConnected.value,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            controller.isConnected.value
                ? IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFFF2828)),
                    onPressed: _sendMessage,
                  )
                : IconButton(
                    onPressed: controller.showConnectionPopup,
                    icon: Icon(
                      Icons.signal_cellular_connected_no_internet_0_bar,
                      color: Colors.grey,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    Future.delayed(Duration(milliseconds: 300), () => _scrollToBottom());

    if (textController.text.trim().isNotEmpty) {
      String message = textController.text.trim();
      textController.clear();
      FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard

      controller.sendMessage(message).then((_) {
        // Wait for response, then scroll
        Future.delayed(Duration(milliseconds: 300), () => _scrollToBottom());
      });
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }
}
