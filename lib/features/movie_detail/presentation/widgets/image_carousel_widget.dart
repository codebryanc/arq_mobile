import 'package:flutter/material.dart';

import 'package:arq_mobile/core/config/app_config.dart';
import 'package:arq_mobile/features/movie_detail/domain/entities/movie_image.dart';

class ImageCarouselWidget extends StatefulWidget {
  // [Constructor]
  const ImageCarouselWidget({super.key, required this.images});

  // [Properties]
  final List<MovieImage> images;

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  // [Properties]
  final _controller = PageController();
  int _currentPage = 0;

  // [Methods]
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${AppConfig.imageBackdropUrl}${widget.images[i].filePath}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
