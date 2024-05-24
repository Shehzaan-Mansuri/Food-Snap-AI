import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_snap/model/food_macros.dart';
import 'package:food_snap/screens/home.dart';
import 'package:food_snap/utils/constants.dart';
import 'package:food_snap/utils/responsive.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shimmer/shimmer.dart';

/// A screen that displays the result of analyzing a food image for its nutritional content.
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.file});
  final XFile file;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-1.5-pro-latest',
    apiKey: googleGeminiAPIKey,
  );

  final String prompt = '''
Identify image and give the macros in JSON format 
{
  "title": "Apple 🍎",
  "nutrition": {
    "serving_size": "100g",
    "calories": 52,
    "carbohydrates": 14,
    "fiber": 2.4,
    "protein": 0.3,
    "fat": 0.2
  }
}
do not change the data type and do not add any extra information
''';

  /// Fetches the response from the generative model based on the image provided.
  Future<String> getResponse() async {
    final image = await widget.file.readAsBytes();
    try {
      final response = await model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart(
            'image/jpeg',
            image.buffer.asUint8List(),
          ),
        ]),
      ]);
      debugPrint("Response: ${response.text}");
      return response.text ?? 'No response';
    } catch (e) {
      debugPrint("Error $e");
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.file(
            File(widget.file.path),
            height: context.height,
            width: context.width,
            fit: BoxFit.cover,
          ),
          FutureBuilder<String>(
            future: getResponse(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildDataResponse(context: context, isLoading: true);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found.'));
              } else {
                final FoodMacros foodMacros =
                    FoodMacros.fromJson(snapshot.data!);
                return _buildDataResponse(
                  context: context,
                  data: foodMacros,
                  isLoading: false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Builds the UI for displaying the nutritional information or loading indicator.
  SafeArea _buildDataResponse({
    required BuildContext context,
    FoodMacros? data,
    bool isLoading = false,
  }) {
    return SafeArea(
      child: SizedBox(
        height: context.height,
        width: context.width,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.3),
                        highlightColor: Colors.grey.withOpacity(0.1),
                        child: Container(
                          width: 100,
                          height: 30,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        data?.title == null
                            ? 'Unknown Food 🤔'
                            : (data!.title![0].toUpperCase() +
                                data.title!.substring(1)),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 30,
                      alignment: WrapAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      runSpacing: 20,
                      children: [
                        _nameAndValue(
                          title: 'Calories',
                          value: data?.nutrition?.calories == null
                              ? null
                              : "${data!.nutrition!.calories} kcal",
                          isLoading: isLoading,
                        ),
                        _nameAndValue(
                          title: 'Protein',
                          value: data?.nutrition?.protein == null
                              ? null
                              : "${data!.nutrition!.protein} g",
                          isLoading: isLoading,
                        ),
                        _nameAndValue(
                          title: 'Carbs',
                          value: data?.nutrition?.carbohydrates == null
                              ? null
                              : "${data!.nutrition!.carbohydrates} g",
                          isLoading: isLoading,
                        ),
                        _nameAndValue(
                          title: 'Fibre',
                          value: data?.nutrition?.fiber == null
                              ? null
                              : "${data!.nutrition!.fiber} g",
                          isLoading: isLoading,
                        ),
                        _nameAndValue(
                          title: 'Energy',
                          value: data?.nutrition?.calories == null
                              ? null
                              : "${data!.nutrition!.calories} kcal",
                          isLoading: isLoading,
                        ),
                        _nameAndValue(
                          title: 'Fat',
                          value: data?.nutrition?.fat == null
                              ? null
                              : "${data!.nutrition!.fat} g",
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    _nameAndValue(
                      title: 'Serving Size',
                      value: data?.nutrition?.servingSize == null
                          ? null
                          : "${data!.nutrition!.servingSize}",
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: isLoading
                          ? null
                          : () async {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Thanks for the info! 🎉 Shehzaan'),
                                ),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.3),
                                highlightColor: Colors.grey.withOpacity(0.1),
                                child: Container(
                                  width: context.width * .5,
                                  height: 18,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Thanks for the info!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A helper widget to display a title and value pair.
  Column _nameAndValue({
    required String title,
    String? value,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 5),
        isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.3),
                highlightColor: Colors.grey.withOpacity(0.1),
                child: Container(
                  width: 50,
                  height: 18,
                  color: Colors.white,
                ),
              )
            : Text(
                value ?? '--',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
      ],
    );
  }
}
