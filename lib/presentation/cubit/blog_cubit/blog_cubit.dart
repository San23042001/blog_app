import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/data/models/blogs/blogs_response_model.dart';
import 'package:blog_app/domain/entities/blog_params.dart';
import 'package:blog_app/domain/entities/pagination_params.dart';
import 'package:blog_app/domain/repository/blog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'blog_state.dart';

@injectable
class BlogCubit extends Cubit<BlogState> {
  final BlogRepository _blogRepository;

  BlogCubit(this._blogRepository) : super(BlogInitial());

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
}
