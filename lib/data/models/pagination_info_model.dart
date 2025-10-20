// lib/data/models/pagination_info_model.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/pagination_info.dart';

class PaginationInfoModel extends PaginationInfo {
  PaginationInfoModel({
    required super.count,
    required super.pages,
    super.next,  // Change to int? since it's a page number
    super.prev,  // Change to int? since it's a page number
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('jsom1----');
      print(json['count'] ?? '');
      print('next: ${json['next']} (type: ${json['next']?.runtimeType})');
      print('prev: ${json['prev']} (type: ${json['prev']?.runtimeType})');
    }

    return PaginationInfoModel(
      count: json['count'] ?? 0,
      pages: json['pages'] ?? 0,
      next: _parsePageNumber(json['next']),
      prev: _parsePageNumber(json['prev']),
    );
  }

  static int? _parsePageNumber(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}