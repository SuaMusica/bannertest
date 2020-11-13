import 'package:bannertest/ui_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({
    @required this.adUnit,
    this.padding = const EdgeInsets.all(0),
  });
  final String adUnit;
  final EdgeInsets padding;
  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _hasFailed = false;

  AdSize _getSize() {
    switch (widget.adUnit) {
      case UITexts.admobBannerSquare:
        return AdSize.mediumRectangle;
      case UITexts.admobBannerPlayer:
        return AdSize.banner;
      case UITexts.admobBannerApp:
        return AdSize.largeBanner;
      default:
        return AdSize.largeBanner;
    }
  }

  Widget _getBanner() {
    final banner = PublisherBannerAd(
      adUnitId: widget.adUnit,
      sizes: <AdSize>[_getSize()],
      request: PublisherAdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          debugPrint("${widget.adUnit} loaded.");
        },
        onAppEvent: (ad, name, data) {},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint(" Failed to load with code: ${error.toString()}");

          setState(() {
            _hasFailed = true;
          });
        },
      ),
    )..load();
    return Padding(
      padding: widget.padding,
      child: Container(
        width: banner.sizes[0].width.toDouble(),
        height: banner.sizes[0].height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(
          ad: banner,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _getSize().height.toDouble() + 10,
      ),
      child: _hasFailed
          ? Container(
              padding: widget.padding,
              width: _getSize().width.toDouble(),
              height: _getSize().height.toDouble() + 10,
              color: Colors.red,
              child: Text("Failed to Fetch"),
            )
          : _getBanner(),
    );
  }
}
