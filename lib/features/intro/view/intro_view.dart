import 'package:esame/core/widgets/custom_button.dart';
import 'package:esame/features/authentification/view/login_pages.dart';
import 'package:esame/features/intro/view/intro_video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodel/intro_viewmodel.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<IntroViewmodel>(context);

    final PageController pageController = PageController();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;

          return OrientationBuilder(
            builder: (context, orientation) {
              bool isLandscape = orientation == Orientation.landscape;
              
              if (isWide) {

                return Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: viewModel.onboardingData.length,
                        onPageChanged: (index) => viewModel.setPage(index),
                        itemBuilder: (context, index) {
                          final data = viewModel.onboardingData[index];
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(data["image"]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    viewModel.onboardingData[viewModel.currentPage]["title"]!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    viewModel.onboardingData[viewModel.currentPage]["subtitle"]!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      viewModel.onboardingData.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                                        width: viewModel.currentPage == index ? 20.w : 12.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          color: viewModel.currentPage == index
                                              ? Colors.orange
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(3.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  CustomButton(
                                    text: viewModel.isLastPage ? "Get Started" : "Next",
                                    width: 250,
                                    onPressed: () {
                                      if (viewModel.isLastPage) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const IntroVideoView(),
                                          ),
                                        );
                                      } else {
                                        pageController.nextPage(
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }


              return SingleChildScrollView(
                child: SizedBox(
                  height: isLandscape ? 1.2.sh : 1.sh,
                  child: Column(
                    children: [
                      SizedBox(
                        height: isLandscape ? 0.5.sh : 0.6.sh,
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: viewModel.onboardingData.length,
                          onPageChanged: (index) => viewModel.setPage(index),
                          itemBuilder: (context, index) {
                            final data = viewModel.onboardingData[index];
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(data["image"]!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                viewModel.onboardingData[viewModel.currentPage]["title"]!,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                viewModel.onboardingData[viewModel.currentPage]["subtitle"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  viewModel.onboardingData.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                                    width: viewModel.currentPage == index ? 16.w : 12.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: viewModel.currentPage == index
                                          ? Colors.orange
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomButton(
                                text: viewModel.isLastPage ? "Get Started" : "Next",
                                height: 50,
                                borderRadius: 12,
                                onPressed: () {
                                  if (viewModel.isLastPage) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const IntroVideoView(),
                                      ),
                                    );
                                  } else {
                                    pageController.nextPage(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
