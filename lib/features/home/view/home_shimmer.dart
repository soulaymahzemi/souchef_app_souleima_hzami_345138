import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/widgets/common_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(width: 80),
                  SizedBox(height: 8),
                  ShimmerText(width: 200, height: 28),
                ],
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: ShimmerContainer(height: 50.h, borderRadius: 15),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: 5,
                  itemBuilder: (context, index) => ShimmerContainer(
                    width: 80.w,
                    height: 40.h,
                    borderRadius: 25,
                    margin: EdgeInsets.only(right: 12.w),
                  ),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerText(width: 120, height: 20),
                  ShimmerText(width: 50, height: 14),
                ],
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: 3,
                itemBuilder: (context, index) => ShimmerContainer(
                  width: 180.w,
                  height: 220.h,
                  borderRadius: 20,
                  margin: EdgeInsets.only(right: 16.w),
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
              child: const ShimmerText(width: 150, height: 20),
            ),
          ),


          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: ShimmerContainer(height: 100.h, borderRadius: 20),
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
