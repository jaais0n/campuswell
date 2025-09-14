import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class PrescriptionUploadWidget extends StatefulWidget {
  final Function(XFile?) onImageCaptured;
  final Function(Map<String, String>) onPrescriptionDetailsExtracted;

  const PrescriptionUploadWidget({
    super.key,
    required this.onImageCaptured,
    required this.onPrescriptionDetailsExtracted,
  });

  @override
  State<PrescriptionUploadWidget> createState() =>
      _PrescriptionUploadWidgetState();
}

class _PrescriptionUploadWidgetState extends State<PrescriptionUploadWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  XFile? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    if (!await _requestCameraPermission()) {
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
      });

      widget.onImageCaptured(photo);
      _extractPrescriptionDetails(photo);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
        });

        widget.onImageCaptured(image);
        _extractPrescriptionDetails(image);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _extractPrescriptionDetails(XFile image) {
    // Mock text recognition - in real app would use ML Kit
    final mockDetails = {
      'medicationName': 'Amoxicillin',
      'dosage': '500mg',
      'quantity': '30 tablets',
      'doctorName': 'Dr. Sarah Johnson',
      'instructions': 'Take twice daily with food',
    };

    widget.onPrescriptionDetailsExtracted(mockDetails);
  }

  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: _capturedImage != null
          ? _buildCapturedImageView(colorScheme)
          : _buildCameraView(colorScheme),
    );
  }

  Widget _buildCameraView(ColorScheme colorScheme) {
    if (!_isCameraInitialized || _cameraController == null) {
      return _buildCameraPlaceholder(colorScheme);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),

          // Overlay with controls
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          // Top instructions
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Position prescription clearly within frame',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                _buildControlButton(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: _pickFromGallery,
                  colorScheme: colorScheme,
                ),

                // Capture button
                GestureDetector(
                  onTap: _isLoading ? null : _capturePhoto,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 4,
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'camera_alt',
                            color: colorScheme.primary,
                            size: 32,
                          ),
                  ),
                ),

                // Flash toggle (mobile only)
                if (!kIsWeb)
                  _buildControlButton(
                    icon: 'flash_auto',
                    label: 'Flash',
                    onTap: _toggleFlash,
                    colorScheme: colorScheme,
                  )
                else
                  const SizedBox(width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturedImageView(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Captured image
          Positioned.fill(
            child: kIsWeb
                ? Image.network(
                    _capturedImage!.path,
                    fit: BoxFit.cover,
                  )
                : CustomImageWidget(
                    imageUrl: _capturedImage!.path,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),

          // Success indicator
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Captured',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Retake button
                _buildControlButton(
                  icon: 'refresh',
                  label: 'Retake',
                  onTap: _retakePhoto,
                  colorScheme: colorScheme,
                ),

                // Use photo button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: CustomIconWidget(
                    iconName: 'check',
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Use Photo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'camera_alt',
            color: colorScheme.onSurfaceVariant,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Initializing Camera...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please allow camera permissions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickFromGallery,
            icon: CustomIconWidget(
              iconName: 'photo_library',
              color: colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Choose from Gallery'),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final currentFlashMode = _cameraController!.value.flashMode;
      final newFlashMode =
          currentFlashMode == FlashMode.off ? FlashMode.auto : FlashMode.off;

      await _cameraController!.setFlashMode(newFlashMode);
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }
}