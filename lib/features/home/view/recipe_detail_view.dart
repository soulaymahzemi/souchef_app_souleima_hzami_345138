import 'package:esame/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/features/home/model/recipe_model.dart';
import 'package:esame/features/home/viewmodel/recipe_viewmodel.dart';
import 'package:esame/core/widgets/favorite_button.dart';
import 'package:esame/core/widgets/category_tag.dart';
import 'package:esame/core/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailView extends StatefulWidget {
  final String recipeId;
  const RecipeDetailView({super.key, required this.recipeId});

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  RecipeModel? _recipe;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    final viewModel = context.read<RecipeViewModel>();
    final recipe = await viewModel.fetchDetailedRecipe(widget.recipeId);
    if (mounted) {
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch YouTube')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: white,
        body: Center(child: CircularProgressIndicator(color: secondary)),
      );
    }

    if (_recipe == null) {
      return const Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(title: 'Recipe Details'),
        body: Center(child: Text("Recipe not found.")),
      );
    }

    final recipe = _recipe!;

    return Scaffold(
      backgroundColor: white,
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 350.h,
            pinned: true,
            backgroundColor: white,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: CircleAvatar(
                backgroundColor: white.withOpacity(0.9),
                child: BackButton(color: black, onPressed: () => Navigator.pop(context)),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: Consumer<RecipeViewModel>(
                  builder: (context, viewModel, child) {
                    return FavoriteButton(
                      isFav: viewModel.isFavorite(recipe.id),
                      onTap: () => viewModel.toggleFavorite(recipe.id),
                    );
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(recipe.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recipe.name, style: titleTextStyle.copyWith(fontSize: 24.sp)),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: empty, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(recipe.area, style: bodyTextStyle.copyWith(color: empty, fontSize: 14.sp)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        CategoryTag(label: recipe.category),
                      ],
                    ),

                    SizedBox(height: 32.h),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(Icons.timer_outlined, recipe.time, "Time"),
                        _buildStatCard(Icons.star_outline, recipe.rating, "Rating"),
                        _buildStatCard(Icons.local_fire_department_outlined, recipe.calories, "kcal"),
                      ],
                    ),

                    SizedBox(height: 32.h),


                    Text("Ingredients", style: titleTextStyle.copyWith(fontSize: 18.sp)),
                    SizedBox(height: 16.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipe.ingredients.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: const BoxDecoration(color: secondary, shape: BoxShape.circle),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(child: Text(recipe.ingredients[index], style: bodyTextStyle.copyWith(fontSize: 15.sp))),
                            Text(recipe.measures[index], style: bodyTextStyle.copyWith(color: empty, fontSize: 14.sp)),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 32.h),


                    Text("Instructions", style: titleTextStyle.copyWith(fontSize: 18.sp)),
                    SizedBox(height: 16.h),
                    Text(
                      recipe.instructions,
                      style: bodyTextStyle.copyWith(fontSize: 15.sp, height: 1.5),
                    ),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: recipe.youtubeUrl.isNotEmpty
          ? Container(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              decoration: const BoxDecoration(
                color: white,
              ),
              child: CustomButton(
                text: 'Watch Video Tutorial',
                icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                onPressed: () => _launchYoutube(recipe.youtubeUrl),
              ),
            )
          : null,
    );
  }

  Widget _buildStatCard(IconData icon, String value, String unit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: primary, size: 24.sp),
          SizedBox(height: 8.h),
          Text(value, style: titleTextStyle.copyWith(fontSize: 14.sp, color: black)),
          Text(unit, style: bodyTextStyle.copyWith(fontSize: 12.sp, color: empty)),
        ],
      ),
    );
  }
}
