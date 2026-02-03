import 'package:esame/core/widgets/custom_button.dart';
import 'package:esame/core/widgets/custom_text_field.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:esame/features/authentification/viewmodel/login_viewmodel.dart';
import 'package:esame/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: titleTextStyle.copyWith(color: black, fontSize: 18.sp),
        ),
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Icon(
                Icons.lock_reset,
                size: 80.sp,
                color: secondary,
              ),
              SizedBox(height: 32.h),
              Text(
                'Reset your password',
                style: titleTextStyle.copyWith(fontSize: 24.sp, color: black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Enter your email address and we will send you a link to reset your password.',
                style: bodyTextStyle.copyWith(fontSize: 14.sp, color: empty),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    (value == null || !value.contains('@'))
                        ? 'Enter a valid email'
                        : null,
              ),
              
              SizedBox(height: 40.h),
              
              CustomButton(
                text: 'Send Reset Link',
                isLoading: loginViewModel.isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final errorMessage = await loginViewModel.resetPassword(
                      emailController.text.trim(),
                    );

                    if (context.mounted) {
                      if (errorMessage == null) {

                        emailController.clear();
                        SnackBarHelper.showSuccess(
                          context,
                          "Reset link sent! Check your email.",
                        );
                        Navigator.pop(context);
                      } else {

                        SnackBarHelper.showError(
                          context,
                          errorMessage,
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
