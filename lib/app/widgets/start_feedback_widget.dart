import 'package:flutter/material.dart';
import 'package:youtube_extracter/app/services/firestore_service.dart';
import 'package:youtube_extracter/app/utills/colors.dart';
import 'package:youtube_extracter/app/utills/size_config.dart';

class StarFeedbackWidget extends StatefulWidget {
  final int size;
  final BuildContext mainContext;

  const StarFeedbackWidget(
      {Key? key, required this.size, required this.mainContext})
      : super(key: key);

  @override
  State<StarFeedbackWidget> createState() => _StarFeedbackWidgetState();
}

class _StarFeedbackWidgetState extends State<StarFeedbackWidget> {
  bool isStarred = false; // Track if feedback is given
  String? selectedFeedback; // Selected feedback option
  String? feedbackType = "Positive"; // Default feedback type
  TextEditingController customFeedbackController = TextEditingController();

  final Map<String, List<String>> feedbackOptions = {
    "Positive": [
      "Great content",
      "Easy to understand",
      "Visually appealing",
      "Informative",
      "Well structured",
      "Other"
    ],
    "Negative": [
      "Difficult to understand",
      "Too complex",
      "Not visually appealing",
      "Lacks information",
      "Not well structured",
      "Other"
    ],
  };

  void showFeedbackDialog(BuildContext mainContext) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Provide Feedback"),
          content: SizedBox(
            width: SizeConfig.screenWidth * 0.8,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Positive/Negative Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Radio<String>(
                          value: "Positive",
                          groupValue: feedbackType,
                          onChanged: (value) {
                            setState(() {
                              feedbackType = value;
                              selectedFeedback = null;
                            });
                          },
                        ),
                        Text("Positive"),
                        SizedBox(width: 20),
                        Radio<String>(
                          value: "Negative",
                          groupValue: feedbackType,
                          onChanged: (value) {
                            setState(() {
                              feedbackType = value;
                              selectedFeedback = null;
                            });
                          },
                        ),
                        Text("Negative"),
                      ],
                    ),

                    // Feedback Options
                    ...feedbackOptions[feedbackType]!.map((option) {
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedFeedback,
                        onChanged: (value) {
                          setState(() {
                            selectedFeedback = value;
                          });
                        },
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String finalFeedback = selectedFeedback == "Other"
                    ? customFeedbackController.text
                    : selectedFeedback ?? "";
                setState(() {
                  isStarred = true;
                });
                FirestoreService().submitFeedback("star", finalFeedback);

                // Show "Thank You" message in the AlertDialog
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevents user from closing it manually
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Thank You!"),
                      content: Text("Your feedback has been submitted."),
                    );
                  },
                );

                // Close the dialog after 1 second
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop(); // Close Thank You dialog
                  Navigator.of(context).pop(); // Close original feedback dialog
                });
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int size = widget.size;
    final buildContext = widget.mainContext;
    return GestureDetector(
      onTap: () {
        showFeedbackDialog(buildContext);
      },
      child: Container(
        width: SizeConfig.blockSizeHorizontal * size,
        height: SizeConfig.blockSizeHorizontal * size,
        decoration: BoxDecoration(
          color: AppColors.fabSideButtonBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Icon(
            Icons.star,
            color: Colors.white,
            size: SizeConfig.blockSizeHorizontal * 6,
          ),
        ),
      ),
    );
  }
}
