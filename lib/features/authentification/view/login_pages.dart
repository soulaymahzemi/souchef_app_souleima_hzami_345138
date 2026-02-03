import 'package:esame/features/home/view/animated_nav_bar.dart';
import 'package:esame/core/widgets/custom_button.dart';
import 'package:esame/core/widgets/custom_text_field.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/core/widgets/social_button.dart';
import 'package:esame/features/authentification/view/sign_up_pages.dart';
import 'package:esame/features/authentification/view/forgot_password_page.dart';
import 'package:esame/features/authentification/viewmodel/login_viewmodel.dart';
import 'package:esame/features/authentification/viewmodel/sign_up_viewmodel.dart';
import 'package:esame/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.45.sh,
            child: Image.asset(
              'assets/images/auth_header.png',
              fit: BoxFit.cover,
            ),
          ),


          Positioned.fill(
            top: 0.35.sh,
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Text(
                        'Sign In',
                        style: titleTextStyle.copyWith(
                          fontSize: 28.sp,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),


                      CustomTextField(
                        controller: emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            (value == null || !value.contains('@'))
                                ? 'Enter a valid email'
                                : null,
                      ),
                      SizedBox(height: 24.h),


                      CustomTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: empty,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) =>
                            (value == null || value.length < 6)
                                ? 'Password too short'
                                : null,
                      ),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: bodyTextStyle.copyWith(
                              color: secondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),


                      CustomButton(
                        text: 'Signin',
                        isLoading: loginViewModel.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();


                            final errorMessage = await loginViewModel.loginUser(email, password);

                            if (errorMessage == null) {

                              emailController.clear();
                              passwordController.clear();


                              if (context.mounted) {
                                SnackBarHelper.showSuccess(
                                  context,
                                  "Login successful!",
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AnimatedNavBar()),
                                );
                              }
                            } else {
                              SnackBarHelper.showError(
                                context,
                                errorMessage,
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const SignUpPage())),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: bodyTextStyle.copyWith(
                              color: empty,
                              fontSize: 15.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: bodyTextStyle.copyWith(
                                  color: secondary,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
