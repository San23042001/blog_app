// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationParams _$PaginationParamsFromJson(Map<String, dynamic> json) =>
    PaginationParams(
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      search: json['search'] as String?,
    );

Map<String, dynamic> _$PaginationParamsToJson(PaginationParams instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'offset': instance.offset,
      'search': instance.search,
    };
