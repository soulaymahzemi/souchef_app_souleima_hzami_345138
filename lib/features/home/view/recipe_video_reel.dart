import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:esame/features/home/model/recipe_model.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeVideoReel extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeVideoReel({super.key, required this.recipe});

  @override
  State<RecipeVideoReel> createState() => _RecipeVideoReelState();
}

class _RecipeVideoReelState extends State<RecipeVideoReel> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {

    final videoId = _extractYoutubeId(widget.recipe.youtubeUrl);
    

    final mobileUrl = 'https://m.youtube.com/watch?v=$videoId';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(black)
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(mobileUrl));
  }

  String? _extractYoutubeId(String url) {
    final regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        Container(
          color: black,
          child: kIsWeb 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill, color: secondary, size: 80.sp),
                    SizedBox(height: 20.h),
                    Text(
                      "Video playback is restricted on Web.",
                      style: titleTextStyle.copyWith(color: white, fontSize: 16.sp),
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(widget.recipe.youtubeUrl)),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Watch on YouTube"),
                      style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    ),
                  ],
                ),
              )
            : WebViewWidget(controller: _controller),
        ),


        if (_isLoading)
          Container(
            color: black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircularProgressIndicator(color: secondary),
                  SizedBox(height: 15.h),
                  Text('Loading video...', style: bodyTextStyle.copyWith(color: white)),
                ],
              ),
            ),
          ),


        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 150.h,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, black.withOpacity(0.7)],
                ),
              ),
            ),
          ),
        ),


        Positioned(
          bottom: 15.h,
          left: 15.w,
          right: 70.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: secondary, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(widget.recipe.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      widget.recipe.name,
                      style: titleTextStyle.copyWith(
                        color: white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                '${widget.recipe.category} • ${widget.recipe.area}',
                style: bodyTextStyle.copyWith(color: secondary, fontSize: 11.sp),
              ),
            ],
          ),
        ),


        Positioned(
          bottom: 50.h,
          right: 10.w,
          child: Column(
            children: [
              _buildSideButton(Icons.favorite_border, "Like"),
              SizedBox(height: 15.h),
              _buildSideButton(Icons.comment_outlined, "Comment"),
              SizedBox(height: 15.h),
              _buildSideButton(Icons.share_outlined, "Share"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: white, size: 22.sp),
        ),
        SizedBox(height: 2.h),
        Text(label, style: bodyTextStyle.copyWith(color: white, fontSize: 9.sp)),
      ],
    );
  }
}
