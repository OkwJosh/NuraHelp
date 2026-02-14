import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imagePath;
  final String imageType; // 'local', 'http', or 'firebase' (pre-resolved URL)
  final String? heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imagePath,
    required this.imageType,
    this.heroTag,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final TransformationController _transformController =
      TransformationController();
  bool _showAppBar = true;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.black54,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: GestureDetector(
        onTap: () => setState(() => _showAppBar = !_showAppBar),
        child: Center(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.5,
            maxScale: 4.0,
            child: Hero(
              tag: widget.heroTag ?? widget.imagePath,
              child: _buildImage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.imageType == 'local') {
      return Image.file(
        File(widget.imagePath),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const _ErrorPlaceholder(),
      );
    }

    return CachedNetworkImage(
      imageUrl: widget.imagePath,
      fit: BoxFit.contain,
      placeholder: (_, __) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      errorWidget: (_, __, ___) => const _ErrorPlaceholder(),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.white54, size: 64),
        SizedBox(height: 12),
        Text(
          'Failed to load image',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ],
    );
  }
}
