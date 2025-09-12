import '../screens/explore_city_page.dart';
import 'package:flutter/material.dart';

class DestinationCarousel extends StatefulWidget {
  const DestinationCarousel({super.key});

  @override
  State<DestinationCarousel> createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<Map<String, String>> destinations = [
    {
      'image': 'assets/download.jpg',
      'name': 'Yaoundé',
      'desc': 'Political capital, known for its hills and greenery.',
    },
    {
      'image': 'assets/download1.jpg',
      'name': 'Douala',
      'desc': 'Economic capital of Cameroon, vibrant and lively.',
    },
    {
      'image': 'assets/download2.jpg',
      'name': 'Kribi',
      'desc': 'Beautiful beach town, famous for its relaxing atmosphere.',
    },
    {
      'image': 'assets/download1.jpg',
      'name': 'Douala',
      'desc': 'Economic capital of Cameroon, vibrant and lively.',
    },
    {
      'image': 'assets/download2.jpg',
      'name': 'Kribi',
      'desc': 'Beautiful beach town, famous for its relaxing atmosphere.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start auto-scrolling
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        final nextPage = _currentIndex + 1;
        if (nextPage >= destinations.length) {
          // If at the end, animate to the first page
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final primaryDarkBlue = theme.primaryColorDark ?? const Color(0xFF1976D2);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: destinations.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final destination = destinations[index];
              final image = destination['image']!;
              final name = destination['name']!;
              final desc = destination['desc']!;
              final isNetworkImage = image.startsWith('http');
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExploreCityPage(cityName: name),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: isNetworkImage
                              ? Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[200],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                              color: primaryColor,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                      child: Icon(
                                        Icons.error,
                                        color: primaryColor,
                                        size: 50,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                      child: Icon(
                                        Icons.error,
                                        color: primaryColor,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  desc,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Fixed three dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (dotIndex) {
            // Calculate which dot should be active based on current position
            bool isActive;

            if (destinations.length <= 3) {
              // If we have 3 or fewer images, show dots for each image
              isActive = dotIndex == _currentIndex;
            } else {
              // For more than 3 images, determine which dot represents the current position
              final segment = (_currentIndex / (destinations.length / 3))
                  .floor();
              isActive = dotIndex == segment;
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? primaryColor : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
