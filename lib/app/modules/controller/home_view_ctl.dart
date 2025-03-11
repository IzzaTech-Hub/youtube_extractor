import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeViewCtl extends GetxController{

   final urlController = TextEditingController();
  var isLoading = false.obs;

  void startExtraction() {
    final url = urlController.text.trim();
    if (url.isEmpty) {
      Get.snackbar(
        'Error',
        'Please paste a valid YouTube URL.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call (replace with actual API call)
    Future.delayed(Duration(seconds: 3), () {
      isLoading.value = false;
      Get.snackbar(
        'Success',
        'Extraction complete! Check your results.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );
    });
  }

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