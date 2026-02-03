import 'package:esame/features/authentification/view/sign_up_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../viewmodel/intro_video_viewmodel.dart';
import '../../authentification/view/login_pages.dart';

class IntroVideoView extends StatelessWidget {
  const IntroVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IntroVideoViewModel(),
      child: const _IntroVideoBody(),
    );
  }
}

class _IntroVideoBody extends StatelessWidget {
  const _IntroVideoBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IntroVideoViewModel>();

    return Scaffold(
      body: Stack(
        children: [

          SizedBox.expand(
            child: Image.asset(
              viewModel.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),


          Container(color: Colors.black.withOpacity(0.55)),


          Positioned.fill(
            child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DELIVERED\nFAST FOOD\nTO YOUR\nRECIPES.",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Follow all recipes to get best experience",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40.h),


                CustomButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>  const LoginPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),


                CustomButton(
                  text: "Register",
                  onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    );                  },
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
      )],
      ),
    );
  }
}
