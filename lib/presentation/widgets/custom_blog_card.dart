import 'dart:ui';
import 'package:blog_app/data/models/blog/blog_response_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBlogCard extends StatelessWidget {
  final Blogs blog;
  final void Function()? likeBlog;

  const CustomBlogCard({super.key, required this.blog, this.likeBlog});

  @override
  Widget build(BuildContext context) {
    final imageUrl = blog.banner?.url ?? '';
    final title = blog.title ?? 'Untitled';
    final content = blog.content ?? '';
    final likes = blog.likesCount ?? 0;
    final comments = blog.commentsCount ?? 0;
    final authorName = blog.author?.username ?? 'Anonymous';
    final publishedAt = blog.publishedAt != null
        ? DateFormat('dd MMM yyyy').format(blog.publishedAt!)
        : 'Unknown date';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'By $authorName',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              publishedAt,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Like & Comment Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    likes > 0
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: likes > 0
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: likeBlog,
                                ),
                                Text(
                                  likes.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.comment_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // TODO: Show comments bottom sheet
                                  },
                                ),
                                Text(
                                  comments.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
