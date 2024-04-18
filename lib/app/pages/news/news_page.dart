import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(MoonIcons.controls_close_24_regular),
            MoonButton(
              onTap: () {},
              label: const Text('Next'),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: MoonTypography.typography.body.text24.copyWith(color: context.moonColors?.textSecondary),
              ),
              style: MoonTypography.typography.heading.text24,
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Body text (optional)',
                hintStyle: MoonTypography.typography.body.text16.copyWith(color: context.moonColors?.textSecondary),
              ),
              style: MoonTypography.typography.body.text16,
            )
          ],
        ),
      ),
    );
  }
}
