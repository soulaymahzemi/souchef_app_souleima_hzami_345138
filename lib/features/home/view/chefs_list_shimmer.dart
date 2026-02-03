import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/widgets/common_shimmer.dart';

class ChefsListShimmer extends StatelessWidget {
  const ChefsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: const ShimmerText(width: 200, height: 14),
          ),


          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15.h),
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [

                      const ShimmerCircle(size: 70),
                      SizedBox(width: 15.w),


                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerText(width: 120, height: 16),
                            SizedBox(height: 4),
                            ShimmerText(width: 100, height: 13),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                ShimmerText(width: 60, height: 12),
                                SizedBox(width: 12),
                                ShimmerText(width: 40, height: 12),
                              ],
                            ),
                          ],
                        ),
                      ),


                      ShimmerContainer(
                        width: 80.w,
                        height: 35.h,
                        borderRadius: 25,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
