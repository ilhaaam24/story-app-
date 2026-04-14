// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryModelImpl _$$StoryModelImplFromJson(Map<String, dynamic> json) =>
    _$StoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };

_$StoryListResponseImpl _$$StoryListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StoryListResponseImpl(
  error: json['error'] as bool,
  message: json['message'] as String,
  listStory: (json['listStory'] as List<dynamic>)
      .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$StoryListResponseImplToJson(
  _$StoryListResponseImpl instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'listStory': instance.listStory,
};
