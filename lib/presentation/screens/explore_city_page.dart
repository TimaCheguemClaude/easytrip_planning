import 'package:easytrip/data/mock_explore_data.dart';
import 'package:flutter/material.dart';
import '../widgets/popular_destinations_carousel.dart';
import '../widgets/explore_category_bar.dart';
import '../widgets/explore_feed_grid.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class ExploreCityPage extends StatefulWidget {
  final String cityName;
  const ExploreCityPage({super.key, required this.cityName});

  @override
  State<ExploreCityPage> createState() => _ExploreCityPageState();
}

class _ExploreCityPageState extends State<ExploreCityPage> {
  String selectedCategory = MockExploreData.categories[0];
  final ScrollController _scrollController = ScrollController();
  bool _isCategoryBarPinned = false;

  @override
  void initState() {
    super.initState();
//    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
//    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // void _handleScroll() {
  //   final double popularSectionHeight = 280; // Approx height of popular section
  //   final bool shouldBePinned = _scrollController.offset >= popularSectionHeight;
    
  //   if (_isCategoryBarPinned != shouldBePinned) {
  //     setState(() {
  //       _isCategoryBarPinned = shouldBePinned;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.explore} "${widget.cityName}"'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Pinned category bar when scrolled
          if (_isCategoryBarPinned)
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExploreCategoryBar(
                selectedCategory: selectedCategory,
                onCategorySelected: (cat) =>
                    setState(() => selectedCategory = cat),
              ),
            ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Popular destinations section
                SliverToBoxAdapter(
                  child: PopularDestinationsCarousel(cityName: widget.cityName),
                ),
                // Sticky category bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyCategoryBarDelegate(
                    ExploreCategoryBar(
                      selectedCategory: selectedCategory,
                      onCategorySelected: (cat) =>
                          setState(() => selectedCategory = cat),
                    ),
                  ),
                ),
                // Grid view of items
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: ExploreFeedGrid(
                    cityName: widget.cityName,
                    category: selectedCategory,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyCategoryBarDelegate extends SliverPersistentHeaderDelegate {
  _StickyCategoryBarDelegate(this.child);

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(_StickyCategoryBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}