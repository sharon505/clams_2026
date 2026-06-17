import 'dart:typed_data';
import 'dart:ui';

import 'package:clams_ciinfos/constants/app_colors.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CropImageScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const CropImageScreen({
    super.key,
    required this.imageBytes,
  });

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final CropController _controller = CropController();

  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111111),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff111111),
        title: Text(
          "Crop Image",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10.h),

              /// Crop Area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: Colors.black,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Crop(
                      image: widget.imageBytes,
                      controller: _controller,
                      aspectRatio: 1,
                      withCircleUi: true,

                      baseColor: Colors.black,
                      maskColor: Colors.black.withOpacity(.65),

                      cornerDotBuilder: (_, __) {
                        return Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                        );
                      },

                      onCropped: (CropResult result) {
                        setState(() => _cropping = false);

                        switch (result) {
                          case CropSuccess(:final croppedImage):
                            Navigator.pop(context, croppedImage);
                            break;

                          case CropFailure(:final cause):
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(cause.toString()),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              /// Bottom Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 55.h),
                          side: BorderSide(
                            color: Colors.white24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 15.w),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _cropping = true);
                          _controller.crop();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 55.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),
            ],
          ),

          /// Loading Overlay
          if (_cropping)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.black45,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff222222),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          SizedBox(height: 18.h),
                          Text(
                            "Cropping image...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}