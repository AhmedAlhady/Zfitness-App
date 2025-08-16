import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common_widgets/round_button.dart';
import 'package:flutter_application_1/common_widgets/round_gradient_button.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _showReminder = true;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> photoArr = [
    {
      "time": "2 June",
      "photo": [
        "assets/images/pp_1.png",
        "assets/images/pp_2.png",
        "assets/images/pp_3.png",
        "assets/images/pp_4.png",
      ],
    },
    {
      "time": "5 May",
      "photo": [
        "assets/images/pp_5.png",
        "assets/images/pp_6.png",
        "assets/images/pp_7.png",
        "assets/images/pp_8.png",
      ],
    },
  ];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? file = await _picker.pickImage(source: source, imageQuality: 80);
    if (file != null) {
      setState(() {
        photoArr[0]["photo"].insert(0, file.path);
      });
    }
  }

  void _openPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPickTwoImages(BuildContext context) async {
    List<String> allPhotos = photoArr
        .expand((g) => (g['photo'] as List<dynamic>))
        .cast<String>()
        .toList();
    List<String> selected = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: StatefulBuilder(
          builder: (_, setState) => Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                const Text(
                  "Select two photos to compare",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: allPhotos.length,
                    itemBuilder: (_, i) {
                      String path = allPhotos[i];
                      bool isSelected = selected.contains(path);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selected.remove(path);
                            } else if (selected.length < 2) {
                              selected.add(path);
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: File(path).existsSync()
                                    ? Image.file(File(path), fit: BoxFit.cover)
                                    : Image.asset(path, fit: BoxFit.cover),
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 4,
                                right: 4,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.check, size: 14, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: selected.length == 2
                      ? () {
                          Navigator.pop(context);
                          _navigateToComparison(context, selected[0], selected[1]);
                        }
                      : null,
                  child: const Text("Compare Selected"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToComparison(BuildContext context, String image1, String image2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComparisonScreen(
          image1Path: image1,
          image2Path: image2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "Progress Photo",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/icons/more_icon.png",
                width: 15,
                height: 15,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_showReminder)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFE5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset(
                          "assets/icons/date_notifi.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Reminder!",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Next Photos Fall On July 08",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _showReminder = false),
                        icon: Icon(Icons.close, color: AppColors.grayColor, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                height: media.width * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor2.withOpacity(0.4),
                      AppColors.primaryColor1.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "Track Your Progress Each\nMonth With Photo\nTo see The Difference",
                          style: TextStyle(color: AppColors.blackColor, fontSize: 14),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Image.asset(
                      "assets/images/progress_each_photo.png",
                      width: media.width * 0.35,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor2.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Compare my Photo",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 25,
                    child: RoundButton(
                      title: "Compare",
                      onPressed: () => _showPickTwoImages(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Gallery",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: photoArr.length,
              itemBuilder: (_, idx) {
                var group = photoArr[idx];
                var images = group["photo"] as List<dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        group["time"],
                        style: TextStyle(color: AppColors.grayColor, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (_, i) {
                          var item = images[i];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item is String && File(item).existsSync()
                                  ? Image.file(File(item), fit: BoxFit.cover)
                                  : Image.asset(item, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: _openPicker,
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.secondaryG),
            borderRadius: BorderRadius.circular(27.5),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(Icons.photo_camera, size: 20, color: AppColors.whiteColor),
        ),
      ),
    );
  }
}

class ComparisonScreen extends StatelessWidget {
  final String image1Path;
  final String image2Path;

  const ComparisonScreen({Key? key, required this.image1Path, required this.image2Path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Photo Comparison', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageWidget(imagePath: image1Path, width: media.width * 0.4, height: media.width * 0.4),
                ImageWidget(imagePath: image2Path, width: media.width * 0.4, height: media.width * 0.4),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Compare the two photos side by side',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
class ImageWidget extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  const ImageWidget({Key? key, required this.imagePath, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), width: width, height: height, fit: BoxFit.cover);
    } else {
      return Image.asset(imagePath, width: width, height: height, fit: BoxFit.cover);
    }
  }
}
