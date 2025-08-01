import 'package:blog_app/app_logger.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blog/like_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';
import 'package:blog_app/domain/entities/blog_params.dart';
import 'package:blog_app/domain/entities/pagination_params.dart';
import 'package:blog_app/domain/entities/user_id_params.dart';
import 'package:blog_app/domain/repository/auth_repository.dart';
import 'package:blog_app/domain/repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'blog_state.dart';

@injectable
class BlogCubit extends Cubit<BlogState> {
  final BlogRepository _blogRepository;
  final AuthRepository _authRepository;

  BlogCubit(this._blogRepository, this._authRepository) : super(BlogInitial());

  void createBlog(BlogParam param) async {
    try {
      emit(BlogLoading());
      final blog = await _blogRepository.createBlog(await param.toFormData());
      emit(BlogSuccess(blog: blog));
    } catch (e) {
      emit(BlogFailure(error: e.toString()));
    }
  }

  void fetchBlogs(PaginationParams params) async {
    try {
      emit(BlogLoading());
      final blogs = await _blogRepository.getAllBlogs(params.toJson());
      emit(BlogsSuccess(blogs: blogs));
    } catch (e) {
      emit(BlogFailure(error: e.toString()));
    }
  }

  void likeBlog(String blogId) async {
    try {
      emit(BlogLikeLoading());
      final userId = await _authRepository.getUserId();

      final response = await _blogRepository.likeBlog(
        UserIdParams(userId: userId).toJson(),
        blogId,
      );

      emit(BlogLikeSuccess(likeBlog: response));
    } catch (e) {
      logger.e("Error while liking blog:${e.toString()}");
      emit(BlogLikeFailure(error: e.toString()));
    }
  }
}
