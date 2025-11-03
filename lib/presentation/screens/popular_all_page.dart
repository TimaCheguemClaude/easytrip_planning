import 'package:flutter/material.dart';
import 'package:easytrip/l10n/app_localizations.dart';

import '../widgets/popular_section.dart';

class PopularAllPage extends StatelessWidget {
  const PopularAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // local notifiers for likes/comments can be ephemeral here
    final liked = ValueNotifier<Set<String>>({});
    final comments = ValueNotifier<Map<String, int>>({});

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mostPopular)),
      body: CustomScrollView(
        slivers: [
          PopularSection(
            likedItems: liked,
            commentCounts: comments,
            onComment: (id) {
              final c = Map<String, int>.from(comments.value);
              c[id] = (c[id] ?? 0) + 1;
              comments.value = c;
            },
          ),
        ],
      ),
    );
  }
}




