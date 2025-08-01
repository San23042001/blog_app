import 'dart:ui';
import 'package:blog_app/data/models/comments/comment_response_model.dart';
import 'package:blog_app/domain/entities/comment_params.dart';
import 'package:blog_app/presentation/cubit/blog_cubit/blog_cubit.dart';
import 'package:blog_app/presentation/widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCommentsBottomSheet extends StatefulWidget {
  final String blogId;
  final List<Comment> comments;

  const CustomCommentsBottomSheet({
    super.key,
    required this.blogId,
    required this.comments,
  });

  @override
  State<CustomCommentsBottomSheet> createState() =>
      _CustomCommentsBottomSheetState();
}

class _CustomCommentsBottomSheetState extends State<CustomCommentsBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: widget.comments.isEmpty
                    ? const Center(
                        child: Text(
                          'No comments yet!',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.comments.length,
                        separatorBuilder: (_, __) => const SizedBox(),
                        itemBuilder: (context, index) {
                          final comment = widget.comments[index];
                          return CommentTile(content: comment.content!);
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        final text = commentController.text.trim();
                        if (text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comment cannot be empty'),
                            ),
                          );
                          return; // Don't proceed further if empty
                        }

                        CommentParams commentParams = CommentParams(
                          content: text,
                        );
                        context.read<BlogCubit>().createComment(
                          commentParams,
                          widget.blogId,
                        );

                        commentController.clear(); // Clear after sending
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
