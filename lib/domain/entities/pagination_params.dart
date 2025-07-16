import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

@JsonSerializable()
class PaginationParams {
  @JsonKey(name: 'limit') // limit = 5 gives 5 blogs
  int? limit;
  @JsonKey(name: 'offset') // offset = 10 skips the first 10 blogs
  int? offset;

  PaginationParams({this.limit = 20, this.offset = 2});

  factory PaginationParams.fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
