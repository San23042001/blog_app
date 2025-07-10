import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/domain/entities/blog_params.dart';


abstract class BlogRepository {
  Future<BlogResponseModel> createBlog(BlogParam param);
}
