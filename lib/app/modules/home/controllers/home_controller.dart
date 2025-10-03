import 'dart:typed_data';
import 'package:flutter_application_2/app/data/services/google_ai_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final RxList<XFile> images = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  final GeminiImageService _geminiService = GeminiImageService();
  
  final RxBool isGenerating = false.obs;
  final RxString currentCategory = "".obs;
  final RxList<Uint8List> generatedImages = <Uint8List>[].obs;

  @override
  void onInit() {
    super.onInit();
    _geminiService.initialize('AIzaSyAgx8gD7PTqcKJLS_7RnvDxQUiMHtmmo1I');
  }

  Future<void> pickImagesFromGallery() async {
    final List<XFile>? picked = await _picker.pickMultiImage();
    if (picked != null) {
      images.assignAll(picked);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      images.add(photo);
    }
  }

  // Method to generate image based on category and selected images
  Future<void> generateImageForCategory(String category) async {
    if (images.isEmpty) {
      Get.snackbar(
        "No Images Selected",
        "Please select or capture images first",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isGenerating.value = true;
      currentCategory.value = category;

      // Convert XFile images to Uint8List
      List<Uint8List> imageBytes = [];
      for (XFile image in images) {
        Uint8List bytes = await image.readAsBytes();
        imageBytes.add(bytes);
      }

      // Generate prompt based on category
      String prompt = _generatePromptForCategory(category);

      // Call Gemini API
      final response = await _geminiService.generateGeminiImage(
        prompt: prompt,
        images: imageBytes,
      );

      if (response.success && response.imageBytes != null) {
        generatedImages.add(response.imageBytes!);
        Get.snackbar(
          "Success!",
          "Image generated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Navigate to results page or show generated image
        _showGeneratedImage(response.imageBytes!);
      } else {
        Get.snackbar(
          "Generation Failed",
          response.error ?? "Unknown error occurred",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to generate image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGenerating.value = false;
    }
  }

  // Generate specific prompts based on category
  String _generatePromptForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'age':
        return 'Transform this person to show different age progression - make them look older or younger while maintaining facial features and identity';
      case 'gender':
        return 'Create a gender-swapped version of this person, changing masculine/feminine features while keeping the core identity recognizable';
      case 'baby face':
        return 'Transform this face to have baby-like features - larger eyes, softer features, rounder face, more youthful appearance';
      case 'makeup':
        return 'Apply professional makeup to this face - enhance eyes with eyeshadow and mascara, add lipstick, foundation, and contouring for a glamorous look';
      case 'hair':
        return 'Change the hairstyle of this person - try different hair colors, lengths, and styles while keeping the face unchanged';
      case 'smile':
        return 'Transform this face to have a bright, natural smile - adjust mouth, cheeks, and eye expression to show genuine happiness';
      default:
        return 'Transform this image based on the $category category, enhancing and modifying relevant facial features';
    }
  }

  // Show generated image in a dialog or navigate to results page
  void _showGeneratedImage(Uint8List imageBytes) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Generated Image - ${currentCategory.value}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const Text("Close"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement save functionality
                      _saveGeneratedImage(imageBytes);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                    ),
                    child: const Text("Save", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Save generated image to device
  Future<void> _saveGeneratedImage(Uint8List imageBytes) async {
    // Implement image saving logic here
    // You can use packages like image_gallery_saver or path_provider
    Get.snackbar(
      "Saved",
      "Image saved to gallery",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Clear all images
  void clearImages() {
    images.clear();
    generatedImages.clear();
  }
}