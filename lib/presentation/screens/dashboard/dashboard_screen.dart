import 'package:blog_app/app_logger.dart';
import 'package:blog_app/data/models/blog/blog_response_model.dart';

import 'package:blog_app/domain/entities/pagination_params.dart';
import 'package:blog_app/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:blog_app/presentation/cubit/blog_cubit/blog_cubit.dart';
import 'package:blog_app/presentation/screens/auth/register_screen.dart';
import 'package:blog_app/presentation/screens/dashboard/create_blog_screen.dart';
import 'package:blog_app/presentation/widgets/custom_blog_card.dart';

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
  static const _pageSize = 20;
  final PagingController<int, Blogs> _pagingController = PagingController(
    firstPageKey: 1,
  );

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      final offset = (pageKey - 1) * _pageSize;
      final params = PaginationParams(limit: _pageSize, offset: offset);
      logger.i(
        "📤 Fetching page $pageKey with offset $offset and limit $_pageSize",
      );
      context.read<BlogCubit>().fetchBlogs(params);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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
            blogs.sort((a, b) {
              final aDate =
                  a.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bDate =
                  b.publishedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bDate.compareTo(aDate);
            });

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
          } else if (state is BlogFailure) {
            logger.e("❌ Error while fetching blogs: ${state.error}");
            _pagingController.error = state.error;
          }
        },
        child: RefreshIndicator(
          onRefresh: () => Future.sync(() {
            logger.i("🔄 Refresh triggered");
            return _pagingController.refresh();
          }),
          child: PagedListView<int, Blogs>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Blogs>(
              itemBuilder: (context, blog, index) => CustomBlogCard(blog: blog),
              noItemsFoundIndicatorBuilder: (context) =>
                  const Center(child: Text("No blogs found")),
              newPageProgressIndicatorBuilder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              firstPageProgressIndicatorBuilder: (context) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
