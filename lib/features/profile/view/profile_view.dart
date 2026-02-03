import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:esame/features/authentification/viewmodel/login_viewmodel.dart';
import 'package:esame/features/authentification/view/login_pages.dart';
import 'package:esame/features/home/viewmodel/chef_viewmodel.dart';
import 'package:esame/features/home/viewmodel/recipe_viewmodel.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/core/widgets/profile_avatar.dart';
import 'package:esame/core/widgets/profile_option.dart';
import 'package:esame/core/widgets/logout_button.dart';
import 'package:esame/core/widgets/custom_bottom_sheet.dart';
import 'package:esame/core/widgets/custom_dialog.dart';
import 'package:esame/core/widgets/custom_appbar.dart';
import 'package:esame/core/utils/snackbar_helper.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: const CustomAppBar(
        title: 'My Profile',
        automaticallyImplyLeading: false,

      ),
      body: Consumer<LoginViewModel>(
        builder: (context, loginVM, child) {
          final user = loginVM.currentUser;


          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 80.sp,
                    color: empty,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No user logged in',
                    style: bodyTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: empty,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: bodyTextStyle.copyWith(color: white),
                    ),
                  ),
                ],
              ),
            );
          }


          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                

                GestureDetector(
                  onTap: () => _showChangePhotoDialog(context),
                  child: Stack(
                    children: [
                      ProfileAvatar(
                        name: user.displayName ?? 'User',
                        imageUrl: user.photoURL ?? '',
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                

                Text(
                  user.displayName ?? 'User',
                  style: titleTextStyle.copyWith(
                    fontSize: 24.sp,
                    color: black,
                  ),
                ),
                
                SizedBox(height: 8.h),
                

                Text(
                  user.email ?? '',
                  style: bodyTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: empty,
                  ),
                ),
                
                SizedBox(height: 24.h),
                

                Consumer2<RecipeViewModel, ChefViewModel>(
                  builder: (context, recipeVM, chefVM, child) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          _buildStatItem(
                            icon: Icons.favorite,
                            count: recipeVM.favoriteRecipes.length,
                            label: 'Favorites',
                            color: red,
                          ),
                          
                          Container(
                            height: 40.h,
                            width: 1,
                            color: empty.withOpacity(0.3),
                          ),
                          

                          _buildStatItem(
                            icon: Icons.people,
                            count: chefVM.followingCount,
                            label: 'Following',
                            color: secondary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 30.h),
                

                ProfileOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Change Photo',
                  onTap: () => _showChangePhotoDialog(context),
                ),
                
                ProfileOption(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => _showEditNameDialog(context, user.displayName ?? ''),
                ),
                

           
          
                SizedBox(height: 30.h),
                

                LogoutButton(
                  onPressed: () => _showLogoutDialog(context),
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditNameDialog(BuildContext context, String currentName) async {
    final newName = await CustomDialog.showInput(
      context: context,
      title: 'Edit Name',
      hintText: 'Enter your name',
      initialValue: currentName,
    );
    
    if (newName != null && newName.isNotEmpty && newName != currentName) {

      context.read<LoginViewModel>().updateDisplayName(newName);
      
      SnackBarHelper.showInfo(
        context,
        'Name updated: $newName',
      );
    }
  }

  void _showChangePhotoDialog(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      title: 'Change Profile Photo',
      options: [
        BottomSheetOption(
          icon: Icons.photo_library,
          title: 'Gallery',
          subtitle: 'Choose from gallery',
          onTap: () => _pickImage(context, ImageSource.gallery),
        ),
        BottomSheetOption(
          icon: Icons.camera_alt,
          title: 'Camera',
          subtitle: 'Take a photo',
          onTap: () => _pickImage(context, ImageSource.camera),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image != null && context.mounted) {
        context.read<LoginViewModel>().updateProfileImage(image.path);
        

        SnackBarHelper.showSuccess(
          context,
          'Profile photo updated',
        );
      }
    } catch (e) {
      print('Error selecting image: $e');
      
      if (context.mounted) {
        SnackBarHelper.showError(
          context,
          'Error: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await CustomDialog.showConfirmation(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      confirmColor: empty,
    );
    
    if (confirmed == true) {
      context.read<LoginViewModel>().logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 6.w),
            Text(
              count.toString(),
              style: titleTextStyle.copyWith(
                fontSize: 22.sp,
                color: black,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: bodyTextStyle.copyWith(
            fontSize: 12.sp,
            color: empty,
          ),
        ),
      ],
    );
  }
}
