import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../them/color.dart';
import '../them/text_style.dart';

class BottomSheetOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  BottomSheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required List<BottomSheetOption> options,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            

            Text(
              title,
              style: titleTextStyle.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            

            ...options.map((option) => Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(option.icon, color: secondary),
                  ),
                  title: Text(
                    option.title,
                    style: bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    option.subtitle,
                    style: bodyTextStyle.copyWith(color: empty, fontSize: 12.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    option.onTap();
                  },
                ),
                if (option != options.last) SizedBox(height: 10.h),
              ],
            )),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
