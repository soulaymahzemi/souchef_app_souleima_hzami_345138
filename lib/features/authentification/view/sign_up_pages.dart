import 'package:esame/core/widgets/custom_button.dart';
import 'package:esame/core/widgets/custom_text_field.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/core/widgets/social_button.dart';
import 'package:esame/features/authentification/view/login_pages.dart';
import 'package:esame/features/authentification/viewmodel/sign_up_viewmodel.dart';
import 'package:esame/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;


  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  void _validatePassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.circle_outlined,
            color: isValid ? green : empty,
            size: 16.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: bodyTextStyle.copyWith(
              fontSize: 13.sp,
              color: isValid ? black : empty,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewmodel>(context);

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.4.sh,
            child: Image.asset(
              'assets/images/auth_header.png',
              fit: BoxFit.cover,
            ),
          ),


          Positioned.fill(
            top: 0.3.sh,
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
                        'Sign Up',
                        style: titleTextStyle.copyWith(
                          fontSize: 28.sp,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),


                      CustomTextField(
                        controller: nameController,
                        labelText: 'Full Name',
                        validator: (value) =>
                            (value == null || value.isEmpty)
                                ? 'Enter your name'
                                : null,
                      ),
                      SizedBox(height: 20.h),


                      CustomTextField(
                        controller: emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            (value == null || !value.contains('@'))
                                ? 'Enter a valid email'
                                : null,
                      ),
                      SizedBox(height: 20.h),


                      CustomTextField(
                        controller: passwordController,
                        labelText: 'Password',
                        obscureText: _obscurePassword,
                        onChanged: _validatePassword,
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
                            (value == null || value.length < 8)
                                ? 'Password must be at least 8 characters'
                                : null,
                      ),
                      

                      SizedBox(height: 10.h),
                      _buildValidationItem("At least 8 characters", _hasMinLength),
                      _buildValidationItem("Contains an uppercase letter", _hasUppercase),
                      _buildValidationItem("Contains a number", _hasNumber),
                      _buildValidationItem("Contains a special character", _hasSpecialChar),

                      SizedBox(height: 40.h),


                      CustomButton(
                        text: 'Register',
                        isLoading: signUpViewModel.isLoading,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final errorMessage = await signUpViewModel.registerUser(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );

                            if (errorMessage == null) {

                              nameController.clear();
                              emailController.clear();
                              passwordController.clear();

                              if (context.mounted) {
                                SnackBarHelper.showSuccess(
                                  context,
                                  "Registration successful!",
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                SnackBarHelper.showError(
                                  context,
                                  errorMessage,
                                );
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(height: 24.h),


                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: bodyTextStyle.copyWith(
                              color: empty,
                              fontSize: 15.sp,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
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
