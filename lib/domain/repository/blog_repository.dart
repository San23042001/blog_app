import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:dio/dio.dart';


abstract class BlogRepository {
  Future<BlogResponseModel> createBlog(FormData formData);
}
