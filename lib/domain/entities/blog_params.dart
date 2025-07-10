import 'dart:io';
import 'package:dio/dio.dart';

class BlogParam {
  final String title;
  final String content;
  final String status;
  final File bannerImage;

  BlogParam({
    required this.title,
    required this.content,
    required this.status,
    required this.bannerImage,
  });

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'title': title,
      'content': content,
      'status': status,
      'banner_image': await MultipartFile.fromFile(
        bannerImage.path,
        filename: bannerImage.path.split('/').last,
      ),
    });
  }
}
