import 'package:json_annotation/json_annotation.dart';

part 'blog_response_model.g.dart';

@JsonSerializable()
class BlogResponseModel {
  @JsonKey(name: 'blog')
  final Blogs blog;

  BlogResponseModel({required this.blog});

  factory BlogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BlogResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BlogResponseModelToJson(this);
}

@JsonSerializable()
class Blogs {
  @JsonKey(name: '_id')
  final String blogId;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'banner')
  Banner? banner;
  @JsonKey(name: 'author')
  Author? author;
  @JsonKey(name: 'viewsCount')
  int? viewsCount;
  @JsonKey(name: 'likesCount')
  int? likesCount;
  @JsonKey(name: 'commentsCount')
  int? commentsCount;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'slug')
  String? slug;
  @JsonKey(name: 'publishAt')
  DateTime? publishedAt;

  Blogs({
    required this.blogId,
    required this.title,
    required this.content,
    required this.banner,
    required this.author,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.status,
    required this.publishedAt,
    required this.slug,
  });

  factory Blogs.fromJson(Map<String, dynamic> json) => _$BlogsFromJson(json);
  Map<String, dynamic> toJson() => _$BlogsToJson(this);
}

@JsonSerializable()
class Banner {
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "width")
  int? width;
  @JsonKey(name: "height")
  int? height;

  Banner({required this.url, required this.width, required this.height});

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
  Map<String, dynamic> toJson() => _$BannerToJson(this);
}

@JsonSerializable()
class Author {
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "email")
  String? email;

  Author({required this.username, required this.email});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

extension BlogsExtension on Blogs {
  Blogs copyWith({
    int? likesCount,
  }) {
    return Blogs(
      blogId: blogId,
      title: title,
      content: content,
      banner: banner,
      author: author,
      viewsCount: viewsCount,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount,
      status: status,
      publishedAt: publishedAt,
      slug: slug,
    );
  }
}
