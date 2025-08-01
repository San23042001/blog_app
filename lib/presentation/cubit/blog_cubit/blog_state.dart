part of 'blog_cubit.dart';

abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object?> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLikeLoading extends BlogState {}

class BlogSuccess extends BlogState {
  final BlogResponseModel blog;

  const BlogSuccess({required this.blog});

  @override
  List<Object> get props => [blog];
}

class BlogsSuccess extends BlogState {
  final BlogsResponseModel blogs;

  const BlogsSuccess({required this.blogs});

  @override
  List<Object> get props => [blogs];
}

class BlogLikeSuccess extends BlogState {
  final LikeResponseModel likeBlog;

  const BlogLikeSuccess({required this.likeBlog});
  @override
  List<Object> get props => [likeBlog];
}

class BlogLikeFailure extends BlogState {
  final String error;

  const BlogLikeFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class BlogFailure extends BlogState {
  final String error;

  const BlogFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
