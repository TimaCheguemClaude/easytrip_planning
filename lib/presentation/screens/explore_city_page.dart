import 'package:flutter/material.dart';
import '../../data/mock_explore_data.dart';
import '../widgets/popular_destinations_carousel.dart';
import '../widgets/explore_category_bar.dart';
import '../widgets/explore_feed_grid.dart';

class ExploreCityPage extends StatefulWidget {
  final String cityName;
  const ExploreCityPage({super.key, required this.cityName});

  @override
  State<ExploreCityPage> createState() => _ExploreCityPageState();
}

class _ExploreCityPageState extends State<ExploreCityPage> {
  String selectedCategory = MockExploreData.categories[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Explore "${widget.cityName}"')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopularDestinationsCarousel(cityName: widget.cityName),
            ExploreCategoryBar(
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) =>
                  setState(() => selectedCategory = cat),
            ),
            ExploreFeedGrid(
              cityName: widget.cityName,
              category: selectedCategory,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
