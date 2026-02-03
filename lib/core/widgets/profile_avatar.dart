import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../them/color.dart';
import '../them/text_style.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String? imageUrl;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.size = 120,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [secondary, secondary.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: secondary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? ClipOval(
              child: _buildImage(),
            )
          : _buildInitial(),
    );
  }

  Widget _buildImage() {

    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: size.w,
        height: size.h,
        errorBuilder: (_, __, ___) => _buildInitial(),
      );
    } 

    else {
      return Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
        width: size.w,
        height: size.h,
        errorBuilder: (_, __, ___) => _buildInitial(),
      );
    }
  }

  Widget _buildInitial() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: titleTextStyle.copyWith(
          fontSize: (size / 2.5).sp,
          color: white,
        ),
      ),
    );
  }
}
