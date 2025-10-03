import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
 
class HomeView extends GetView<HomeController> {
  final RxString selectedImagePath = "".obs;


  final List<String> cardImages = [
    'assets/card1.png',
    'assets/card 2.png',
    'assets/baby face.png',
    'assets/card 6.png',
    'assets/card 3.png',
    'assets/card 5.png',
  ];

  final List<String> categories = [
    "Age",
    "Gender",
    "Baby Face",
    "Makeup",
    "Hair",
    "Smile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Face App",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF003366),
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // Show selected images count
          Obx(() => controller.images.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B3EFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.images.length} images',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              : const SizedBox()),
        ],
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Show selected images preview
                Obx(() => controller.images.isNotEmpty
                    ? Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            final image = controller.images[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF003366), width: 2),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      File(image.path),
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Remove button
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.images.removeAt(index);
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox()),

                // Main grid
                Expanded(
                  child: GridView.builder(
                    itemCount: cardImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final imgPath = cardImages[index];
                      final categoryName = categories[index];
                      return GestureDetector(
                        onTap: () {
                          _showImageOptionDialog(context, categoryName);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(imgPath, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.1),
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    categoryName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          Obx(() => controller.isGenerating.value
              ? Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF003366),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Generating ${controller.currentCategory.value} Image...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003366),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This may take a few moments',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),

      // Floating action button to clear images
      floatingActionButton: Obx(() => controller.images.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Clear Images",
                  middleText: "Are you sure you want to clear all selected images?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    controller.clearImages();
                    Get.back();
                  },
                );
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.clear, color: Colors.white),
            )
          : const SizedBox()),
    );
  }

  void _showImageOptionDialog(BuildContext context, String category) {
    Get.defaultDialog(
      title: " pick image for $category",
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF003366),
      ),
      content: Column(
        children: [
          // Camera option
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              controller.pickImageFromCamera().then((_) {
                if (controller.images.isNotEmpty) {
                  _showGenerateOption(category);
                }
              });
            },
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text("Open Camera",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003366),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Gallery option
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              controller.pickImagesFromGallery().then((_) {
                if (controller.images.isNotEmpty) {
                  _showGenerateOption(category);
                }
              });
            },
            icon: const Icon(Icons.photo_library, color: Colors.white),
            label: const Text("Select from Gallery",
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B3EFF),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Generate option (if images already selected)
          Obx(() => controller.images.isNotEmpty
              ? ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    controller.generateImageForCategory(category);
                  },
                  icon: const Icon(Icons.auto_awesome, color: Colors.white),
                  label: Text("Generate $category",
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      radius: 12,
    );
  }

  void _showGenerateOption(String category) {
    Get.defaultDialog(
      title: "Generate $category Image?",
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF003366),
      ),
      middleText: "Do you want to generate a $category transformation using the selected images?",
      textConfirm: "Generate",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF003366),
      onConfirm: () {
        Get.back();
        controller.generateImageForCategory(category);
      },
    );
  }
}