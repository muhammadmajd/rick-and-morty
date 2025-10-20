
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  static const String _imageCacheDir = 'image_cache';
  late Directory _cacheDirectory;

  Future<void> init() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory('${appDocDir.path}/$_imageCacheDir');
    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }
  }

  String _getImageFileName(String imageUrl) {
    return '${imageUrl.hashCode}.png';
  }

  String getImagePath(String imageUrl) {
    return '${_cacheDirectory.path}/${_getImageFileName(imageUrl)}';
  }

  Future<Uint8List?> getCachedImage(String imageUrl) async {
    try {
      final filePath = getImagePath(imageUrl);
      final file = File(filePath);

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        return bytes;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error reading cached image: $e');
      }
      return null;
    }
  }

  Future<Uint8List> downloadAndCacheImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Save to cache
        final filePath = getImagePath(imageUrl);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return response.bodyBytes;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading image: $e');
      }
      rethrow;
    }
  }

  Future<bool> isImageCached(String imageUrl) async {
    final filePath = getImagePath(imageUrl);
    final file = File(filePath);
    return await file.exists();
  }

  Future<void> clearCache() async {
    if (await _cacheDirectory.exists()) {
      await _cacheDirectory.delete(recursive: true);
      await _cacheDirectory.create(recursive: true);
    }
  }

  Future<int> getCacheSize() async {
    if (!await _cacheDirectory.exists()) return 0;

    final files = _cacheDirectory.listSync();
    int totalSize = 0;

    for (var file in files) {
      if (file is File) {
        totalSize += await file.length();
      }
    }

    return totalSize;
  }
}