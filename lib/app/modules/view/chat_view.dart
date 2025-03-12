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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            controller.transcript.videoTitle,
            softWrap: true,
            textScaler: TextScaler.linear(0.8),
            overflow: TextOverflow.clip,
            maxLines: 2,
            textAlign: TextAlign.justify,
          )),
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
                  // if (index >= controller.initalMessagesCount) {
                  final message = controller.messages[index];
                  return _chatBubble(
                      message.parts!.isNotEmpty
                          ? (message.parts!.first as TextPart).text
                          : "No content",
                      message.role == 'user',
                      index,
                      controller.promptMessagesCount);
                  // }
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
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              constraints: BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: MarkdownBody(
                data: text,
                selectable: true, // Allows text selection
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
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Typing", style: TextStyle(color: Colors.black)),
            SizedBox(width: 6),
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
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
                        borderRadius: BorderRadius.circular(24)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            controller.isConnected.value
                ? IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      _sendMessage();
                    },
                  )
                : IconButton(
                    onPressed: controller.showConnectionPopup,
                    icon: Icon(
                      Icons.signal_cellular_connected_no_internet_0_bar,
                    ),
                    highlightColor: Colors.white,
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
