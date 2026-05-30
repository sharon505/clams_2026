import 'package:flutter/material.dart';
import '../services/image_upload_service.dart';

class ImageUploadProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _uploadResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get uploadResponse => _uploadResponse;

  final ImageUploadService _imageUploadService = ImageUploadService();

  Future<bool> uploadImage({
    required BuildContext context,
    required String fileBytes,
    required String fileExtension,
  }) async {
    _isLoading = true;
    _error = null;
    _uploadResponse = null;
    notifyListeners();

    try {
      final response = await _imageUploadService.uploadImage(
        context: context,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
      );

      if (response != null) {
        _uploadResponse = response;
        debugPrint("✅ Image Upload Success");
        return true;
      } else {
        _error = "Image upload failed";
        debugPrint("❌ Image upload failed");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("🔴 Upload Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUploadData() {
    _uploadResponse = null;
    _error = null;
    notifyListeners();
  }
}