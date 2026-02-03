import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esame/features/home/viewmodel/chef_viewmodel.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/widgets/custom_appbar.dart';

import 'package:esame/features/home/view/chefs_list_shimmer.dart';

class ChefsListView extends StatefulWidget {
  const ChefsListView({super.key});

  @override
  State<ChefsListView> createState() => _ChefsListViewState();
}

class _ChefsListViewState extends State<ChefsListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChefViewModel>().fetchChefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const CustomAppBar(
        title: 'Discover Chefs',
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ChefViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const ChefsListShimmer();
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 50.sp, color: Colors.red),
                  SizedBox(height: 15.h),
                  Text('Error loading chefs', style: bodyTextStyle),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchChefs(),
                    style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.chefs.isEmpty) {
            return Center(
              child: Text('No chefs found', style: bodyTextStyle),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  'Popular Chefs Around the World',
                  style: bodyTextStyle.copyWith(color: empty, fontSize: 14.sp),
                ),
              ),


              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount: viewModel.chefs.length,
                  itemBuilder: (context, index) {
                    final chef = viewModel.chefs[index];
                    final isFollowing = viewModel.isFollowing(chef.id);

                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 70.w,
                            height: 70.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: secondary, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(chef.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),


                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chef.name,
                                  style: titleTextStyle.copyWith(fontSize: 16.sp, color: black),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  chef.specialty,
                                  style: bodyTextStyle.copyWith(fontSize: 13.sp, color: secondary),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(Icons.restaurant_menu, size: 14.sp, color: empty),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${chef.recipesCount} recipes',
                                      style: bodyTextStyle.copyWith(fontSize: 12.sp, color: empty),
                                    ),
                                    SizedBox(width: 12.w),
                                    Icon(Icons.star, size: 14.sp, color: Colors.amber),
                                    SizedBox(width: 4.w),
                                    Text(
                                      chef.rating.toStringAsFixed(1),
                                      style: bodyTextStyle.copyWith(fontSize: 12.sp, color: empty),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),


                          GestureDetector(
                            onTap: () => viewModel.toggleFollow(chef.id),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isFollowing ? Colors.grey[300] : secondary,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                isFollowing ? 'Following' : 'Follow',
                                style: bodyTextStyle.copyWith(
                                  color: isFollowing ? black : white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
