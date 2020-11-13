import 'package:bannertest/banner/ad_banner.dart';
import 'package:bannertest/ui_texts.dart';
import 'package:flutter/material.dart';

class BannerPage extends StatelessWidget {
  const BannerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          AdBanner(
            adUnit: UITexts.admobBannerApp,
          ),
          AdBanner(
            adUnit: UITexts.admobBannerSquare,
          ),
        ],
      ),
    );
  }
}
