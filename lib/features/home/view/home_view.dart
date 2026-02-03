import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/features/home/viewmodel/recipe_viewmodel.dart';
import 'package:esame/features/home/model/recipe_model.dart';
import 'package:esame/core/widgets/sticky_header_delegate.dart';
import 'package:esame/features/home/view/home_shimmer.dart';
import 'package:esame/core/widgets/recipe_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeViewModel>().initializeHome();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Consumer<RecipeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.recipes.isEmpty) {
              return const HomeShimmer();
            }

            return LayoutBuilder(
              builder: (context, constraints) {

                int crossAxisCount = 1;
                if (constraints.maxWidth > 900) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 2;
                }

                return OrientationBuilder(
                  builder: (context, orientation) {
                    bool isLandscape = orientation == Orientation.landscape;

                    if (isLandscape && crossAxisCount < 2) crossAxisCount = 2;

                    return CustomScrollView(
                      slivers: [

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello! 👋',
                                      style: bodyTextStyle.copyWith(color: empty, fontSize: 16.sp),
                                    ),
                                    Text(
                                      'What to cook today?',
                                      style: titleTextStyle.copyWith(fontSize: 24.sp, color: primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),


                        SliverPersistentHeader(
                          pinned: true,
                          delegate: StickyHeaderDelegate(
                            child: Container(
                              color: white,
                              padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                                    child: Container(
                                      height: 50.h,
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      decoration: BoxDecoration(
                                        color: background,
                                        borderRadius: BorderRadius.circular(15.r),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) => viewModel.searchRecipes(value),
                                        decoration: InputDecoration(
                                          hintText: 'Search for recipes...',
                                          hintStyle: hintTextStyle.copyWith(fontSize: 13.sp),
                                          icon: const Icon(Icons.search, color: primary, size: 20),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  if (viewModel.categories.isNotEmpty)
                                    SizedBox(
                                      height: 40.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                                        itemCount: viewModel.categories.length,
                                        itemBuilder: (context, index) {
                                          bool isSelected = viewModel.selectedCategory == viewModel.categories[index];
                                          return GestureDetector(
                                            onTap: () => viewModel.filterByCategory(viewModel.categories[index]),
                                            child: Container(
                                              margin: EdgeInsets.only(right: 12.w),
                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: isSelected ? secondary : white,
                                                borderRadius: BorderRadius.circular(25.r),
                                                border: Border.all(color: isSelected ? secondary : background),
                                              ),
                                              child: Text(
                                                viewModel.categories[index],
                                                style: bodyTextStyle.copyWith(
                                                  color: isSelected ? white : black,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),


                        if (viewModel.popularRecipes.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Popular Recipes', style: titleTextStyle.copyWith(fontSize: 18.sp)),
                                  Text('See all', style: bodyTextStyle.copyWith(color: secondary, fontSize: 14.sp, fontWeight: FontWeight.bold)),
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
                                itemCount: viewModel.popularRecipes.length,
                                itemBuilder: (context, index) => RecipeCard(
                                  recipe: viewModel.popularRecipes[index],
                                  isPopular: true,
                                ),
                              ),
                            ),
                          ),
                        ],


                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
                            child: Text(
                              viewModel.selectedCategory == 'All' ? 'Featured Recipes' : '${viewModel.selectedCategory} Recipes',
                              style: titleTextStyle.copyWith(fontSize: 18.sp),
                            ),
                          ),
                        ),

                        if (viewModel.recipes.isEmpty && !viewModel.isLoading)
                          const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('No recipes found.'))))
                        else
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            sliver: crossAxisCount > 1
                              ? SliverGrid(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 16.h,
                                    mainAxisExtent: 220.h,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => RecipeCard(recipe: viewModel.recipes[index]),
                                    childCount: viewModel.recipes.length,
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => RecipeCard(recipe: viewModel.recipes[index]),
                                    childCount: viewModel.recipes.length,
                                  ),
                                ),
                          ),

                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
