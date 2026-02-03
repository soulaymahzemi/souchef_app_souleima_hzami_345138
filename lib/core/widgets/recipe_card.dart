import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/features/home/model/recipe_model.dart';
import 'package:esame/features/home/viewmodel/recipe_viewmodel.dart';
import 'package:esame/core/widgets/favorite_button.dart';
import 'package:esame/core/widgets/category_tag.dart';
import 'package:esame/core/widgets/time_badge.dart';
import 'package:esame/features/home/view/recipe_detail_view.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isPopular;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, viewModel, child) {
        bool isFav = viewModel.isFavorite(recipe.id);
        

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailView(recipeId: recipe.id),
              ),
            );
          },
          child: _buildCardContent(isFav, viewModel),
        );
      },
    );
  }

  Widget _buildCardContent(bool isFav, RecipeViewModel viewModel) {

    if (isPopular) {
      return Container(
        width: 180.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      child: Image.network(
                        recipe.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: FavoriteButton(
                      isFav: isFav,
                      onTap: () => viewModel.toggleFavorite(recipe.id),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: titleTextStyle.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        recipe.category,
                        style: bodyTextStyle.copyWith(color: empty, fontSize: 12.sp),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: secondary, size: 14.sp),
                          SizedBox(width: 4.w),
                          Text('4.8', style: bodyTextStyle.copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }


    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              bottomLeft: Radius.circular(20.r),
            ),
            child: Image.network(
              recipe.imageUrl,
              height: 100.h,
              width: 100.h,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          recipe.name,
                          style: titleTextStyle.copyWith(fontSize: 15.sp, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      FavoriteButton(
                        isFav: isFav,
                        onTap: () => viewModel.toggleFavorite(recipe.id),
                        isSmall: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'by Chef Mario',
                    style: bodyTextStyle.copyWith(color: empty, fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryTag(label: recipe.category),
                      const TimeBadge(time: '25 min'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
