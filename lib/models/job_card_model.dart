import 'dart:convert';

import 'package:flutter/foundation.dart';

class JobCardModel {
  final String imagePath;
  final String jobTitle;
  final String companyName;
  final String level;
  final String type;
  final List<String> tags;
  JobCardModel({
    required this.imagePath,
    required this.jobTitle,
    required this.companyName,
    required this.level,
    required this.type,
    required this.tags,
  });

  JobCardModel copyWith({
    String? imagePath,
    String? jobTitle,
    String? companyName,
    String? level,
    String? type,
    List<String>? tags,
  }) {
    return JobCardModel(
      imagePath: imagePath ?? this.imagePath,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      level: level ?? this.level,
      type: type ?? this.type,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagePath': imagePath,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'level': level,
      'type': type,
      'tags': tags,
    };
  }

  factory JobCardModel.fromMap(Map<String, dynamic> map) {
    return JobCardModel(
      imagePath: map['imagePath'] as String,
      jobTitle: map['jobTitle'] as String,
      companyName: map['companyName'] as String,
      level: map['level'] as String,
      type: map['type'] as String,
      tags: List<String>.from((map['tags'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory JobCardModel.fromJson(String source) =>
      JobCardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'JobCardModel(imagePath: $imagePath, jobTitle: $jobTitle, companyName: $companyName, level: $level, type: $type, tags: $tags)';
  }

  @override
  bool operator ==(covariant JobCardModel other) {
    if (identical(this, other)) return true;

    return other.imagePath == imagePath &&
        other.jobTitle == jobTitle &&
        other.companyName == companyName &&
        other.level == level &&
        other.type == type &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
        jobTitle.hashCode ^
        companyName.hashCode ^
        level.hashCode ^
        type.hashCode ^
        tags.hashCode;
  }
}
