import 'dart:async';
import 'dart:ui';

import 'package:blog_app/app_logger.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:blog_app/domain/entities/pagination_params.dart';
import 'package:blog_app/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:blog_app/presentation/cubit/blog_cubit/blog_cubit.dart';
import 'package:blog_app/presentation/screens/auth/register_screen.dart';
import 'package:blog_app/presentation/screens/dashboard/create_blog_screen.dart';
import 'package:blog_app/presentation/widgets/custom_blog_card.dart';
import 'package:blog_app/utils/debouncer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _pageSize = 10;
  final PagingController<int, Blogs> _pagingController = PagingController(
    firstPageKey: 1,
  );

  final TextEditingController _searchController = TextEditingController();
  final Debounce _debouncer = Debounce(delay: Duration(milliseconds: 500));
  String? _searchQuery;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      final offset = (pageKey - 1) * _pageSize;
      final params = PaginationParams(
        limit: _pageSize,
        offset: offset,
        search: _searchQuery,
      );

      logger.i(
        "📤 Fetching page $pageKey with offset $offset and search: $_searchQuery",
      );
      context.read<BlogCubit>().fetchBlogs(params);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      setState(() {
        _searchQuery = value.trim().isEmpty ? null : value.trim();
      });
      logger.i("🔍 Searching for: $_searchQuery");
      _pagingController.refresh();
    });
  }

  Widget _buildGlassSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search blogs...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: const CreateBlogScreen(),
                ),
              );

              if (result != null && result is Blogs) {
                _pagingController.itemList = [
                  result,
                  ...(_pagingController.itemList ?? []),
                ];
              }
            },
            icon: const Icon(Icons.add),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }

              if (state is Unauthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              } else if (state is AuthError) {
                Fluttertoast.showToast(
                  msg: state.error,
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.BOTTOM,
                  textColor: Colors.white,
                );
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: const Icon(Icons.logout),
              );
            },
          ),
        ],
      ),
      body: BlocListener<BlogCubit, BlogState>(
        listener: (context, state) {
          if (state is BlogsSuccess) {
            List<Blogs> blogs = state.blogs.blogs;

            final currentPageKey = _pagingController.nextPageKey ?? 1;
            logger.i(
              "✅ Received ${blogs.length} blogs for page $currentPageKey",
            );

            final isLastPage = blogs.length < _pageSize;
            if (isLastPage) {
              logger.i("🏁 Reached last page.");
              _pagingController.appendLastPage(blogs);
            } else {
              final nextPageKey = currentPageKey + 1;
              logger.i("➡️ Preparing next page key: $nextPageKey");
              _pagingController.appendPage(blogs, nextPageKey);
            }
          } else if (state is BlogLikeSuccess) {
            final likedBlogId = state.likeBlog.blogId;
            final updatedLikes = state.likeBlog.likesCount;

            final currentList = _pagingController.itemList;
            if (currentList != null) {
              final index = currentList.indexWhere(
                (b) => b.blogId == likedBlogId,
              );
              if (index != -1) {
                final updatedBlog = currentList[index].copyWith(
                  likesCount: updatedLikes,
                );
                setState(() {
                  currentList[index] = updatedBlog;
                  _pagingController.itemList = List.from(
                    currentList,
                  ); // Triggers rebuild
                });
              }
            }
          } else if (state is BlogFailure) {
            logger.e("❌ Error while fetching blogs: ${state.error}");
            _pagingController.error = state.error;
          }
        },
        child: Column(
          children: [
            _buildGlassSearchBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() {
                  logger.i("🔄 Refresh triggered");
                  return _pagingController.refresh();
                }),
                child: PagedListView<int, Blogs>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Blogs>(
                    itemBuilder: (context, blog, index) => CustomBlogCard(
                      blog: blog,
                      likeBlog: () {
                        context.read<BlogCubit>().likeBlog(blog.blogId);
                      },
                    ),
                    noItemsFoundIndicatorBuilder: (context) =>
                        const Center(child: Text("No blogs found")),
                    newPageProgressIndicatorBuilder: (context) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    firstPageProgressIndicatorBuilder: (context) =>
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
