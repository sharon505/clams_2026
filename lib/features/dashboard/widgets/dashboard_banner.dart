import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/app_colors.dart';

class DashboardBanner extends StatefulWidget {
  const DashboardBanner({super.key});

  @override
  State<DashboardBanner> createState() => _DashboardBannerState();
}

class _DashboardBannerState extends State<DashboardBanner> {
  int currentIndex = 0;

  static const List<String> banners = [
    'assets/images/dashBord/bannerSample.png',
    'assets/images/dashBord/bannerSample.png',
    'assets/images/dashBord/bannerSample.png',
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 7.h,
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 130.h,
            autoPlay: true,
            viewportFraction: 1,
            enlargeCenterPage: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration:
            const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemBuilder: (
              context,
              index,
              realIndex,
              ) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                banners[index],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: 4.w,
              ),
              width: currentIndex == index
                  ? 22.w
                  : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.primaryColor
                    : Colors.white.withValues(alpha: 0.6),
                borderRadius:
                BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}