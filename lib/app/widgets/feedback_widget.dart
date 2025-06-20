import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_extracter/app/services/firestore_service.dart';
import 'package:youtube_extracter/app/utills/colors.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({Key? key}) : super(key: key);

  @override
  State<FeedbackWidget> createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  String? selectedFeedback; // Stores selected feedback
  String? submittedFeedback; // Stores submitted feedback type (up/down)

  // Feedback options
  final List<String> negativeOptions = [
    "Hate speech",
    "Contains sexual content",
    "Misinformation",
    "Irrelevant content",
    "Offensive or inappropriate",
    "Poorly structured slides",
    "Other"
  ];
  final List<String> positiveOptions = [
    "Quick response",
    "Well-designed slides",
    "Accurate and relevant content",
    "Easy to understand",
    "Useful and informative",
    "Unique and creative",
    "Other"
  ];

  // Function to show feedback popup
  void showFeedbackDialog(String feedbackType) {
    List<String> options =
        feedbackType == "thumbs_up" ? positiveOptions : negativeOptions;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Feedback"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedFeedback,
                onChanged: (value) {
                  setState(() {
                    selectedFeedback = value;
                    submittedFeedback =
                        feedbackType; // Save submitted feedback type
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  FirestoreService()
                      .submitFeedback(feedbackType, value!); // Submit feedback
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      children: [
        if (submittedFeedback !=
            "thumbs_down") // Show thumbs up only if not submitted thumbs down
          Container(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
            child: GestureDetector(
              child: Icon(Icons.thumb_up,
                  color: submittedFeedback == "thumbs_up"
                      ? AppColors.thumbsUp
                      : Colors.grey,
                  size: submittedFeedback == "thumbs_up"
                      ? SizeConfig.blockSizeHorizontal * 5
                      : SizeConfig.blockSizeHorizontal * 4.3),
              onTap: () => showFeedbackDialog("thumbs_up"),
            ),
          ),
        if (submittedFeedback !=
            "thumbs_up") // Show thumbs down only if not submitted thumbs up
          Container(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 4),
            child: GestureDetector(
              child: Icon(Icons.thumb_down,
                  color: submittedFeedback == "thumbs_down"
                      ? AppColors.thumbsDown
                      : Colors.grey,
                  size: submittedFeedback == "thumbs_down"
                      ? SizeConfig.blockSizeHorizontal * 5
                      : SizeConfig.blockSizeHorizontal * 4.3),
              onTap: () => showFeedbackDialog("thumbs_down"),
            ),
          ),
      ],
    );
  }
}
