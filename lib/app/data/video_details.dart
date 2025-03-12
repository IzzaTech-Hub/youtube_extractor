// import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:youtube_caption_scraper/youtube_caption_scraper.dart';
import 'dart:developer' as developer;

class VideoDetails {
  List<SubtitleLine> transcriptList;
  String videoTitle;
  String videoAuthor;
  VideoDetails(
      {required this.transcriptList,
      required this.videoAuthor,
      required this.videoTitle});

  static fromMap(Map<String, dynamic> mappedTranscript) {
    return VideoDetails(
        transcriptList: mappedTranscript["transcriptList"],
        videoAuthor: mappedTranscript["videoAuthor"],
        videoTitle: mappedTranscript["videoTitle"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "transcriptList": transcriptList,
      "videoAuthor": videoAuthor,
      "videoTitle": videoTitle
    };
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  String formatEndTime(Duration start, Duration duration) {
    Duration endTime = start + duration;
    return formatDuration(endTime);
  }

  List<String> transcriptStringWithTime() {
    return transcriptList.map((subtitle) {
      return "${formatDuration(subtitle.start)} - ${formatEndTime(subtitle.start, subtitle.duration)} : ${subtitle.text}";
    }).toList();
  }

  String transcriptToString() {
    String transcriptString = "";
    transcriptList.forEach((transcript) => transcriptString + transcript.text);
    return transcriptString;
  }

  String patchToString(List<String> patchTranscript) {
    return patchTranscript.join(' ');
  }

  List<List<String>> transcriptToPatches() {
    List<String> transcriptWithTime = transcriptStringWithTime();
    int transcriptLength = transcriptWithTime.length;
    List<List<String>> patchedTranscript = [];

    if (transcriptLength <= 80) {
      return [transcriptWithTime]; // If length is <= 80, return as single patch
    }

    int startIndex = 0;
    while (startIndex < transcriptLength) {
      int endIndex =
          (startIndex + 80).clamp(0, transcriptLength); // Prevent overflow
      patchedTranscript.add(transcriptWithTime.sublist(startIndex, endIndex));
      startIndex += 80;
    }

    // Debugging logs
    developer.log("Patched transcript count: ${patchedTranscript.length}");
    developer.log(
        "Total transcript length in patches: ${patchedTranscript.fold(0, (prev, element) => prev + element.length)}");

    return patchedTranscript;
  }

  List<Content> completeTranscriptHistory() {
    List<List<String>> transcriptInPatches = transcriptToPatches();
    List<Content> transcriptHistory = [
      Content.text(
          "The transcript will be provided in multiple segments, including video title and author/channel name. Please wait for the final confirmation before responding to the user's queries."),
      Content.text(
          "Understood. I will wait for the full transcript before proceeding.")
    ];

    for (var patch in transcriptInPatches) {
      transcriptHistory.addAll([
        Content.text(patchToString(patch)),
        Content.text("Acknowledged. Awaiting the final transcript.")
      ]);
    }

    transcriptHistory.addAll([
      Content.text(
          "The author/channel name of this video is $videoAuthor and Title of this video is $videoTitle"),
      Content.text("Noted. Thanks for providing information about the video"),
      Content.text(
          "The full transcript and details have been provided. You may now proceed with answering the user's questions."),
      Content.text("Noted. Ready to respond to the user's queries."),
    ]);

    return transcriptHistory;
  }
}
