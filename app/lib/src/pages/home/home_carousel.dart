import 'package:flutter/material.dart';
import 'dart:async';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  final List<String> _images = [
    "assets/images/banner1.jpeg",
    "assets/images/banner2.jpeg",
    "assets/images/banner3.jpeg",
  ];
  late final List<String> _loopedImages;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    // Add last image at the start and first image at the end for looping
    _loopedImages = [_images.last, ..._images, _images.first];
    _controller.addListener(_handleLoopSwipe);
    // Start at page 1 (the real first image)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(1);
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      int nextPage = _controller.page!.round() + 1;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _handleLoopSwipe() {
    if (!_controller.hasClients) return;
    final page = _controller.page;
    if (page == 0) {
      // Jump to last real image
      Future.microtask(() {
        if (mounted) _controller.jumpToPage(_images.length);
      });
    } else if (page == _images.length + 1) {
      // Jump to first real image
      Future.microtask(() {
        if (mounted) _controller.jumpToPage(1);
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.removeListener(_handleLoopSwipe);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: _loopedImages.length,
            onPageChanged: (index) {
              int realIndex;
              if (index == 0) {
                realIndex = _images.length - 1;
              } else if (index == _images.length + 1) {
                realIndex = 0;
              } else {
                realIndex = index - 1;
              }
              setState(() {
                _currentPage = realIndex;
              });
              _startAutoScroll(); // Reset timer on manual swipe
            },
            itemBuilder: (context, index) {
              return _buildCarouselCard(_loopedImages[index], width);
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return GestureDetector(
              onTap: () {
                _controller.animateToPage(
                  index + 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 16 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.green
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(String imagePath, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}
