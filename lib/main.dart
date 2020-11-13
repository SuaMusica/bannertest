import 'package:bannertest/banner/sm_pre_roll.dart';
import 'package:bannertest/banner_page.dart';
import 'package:bannertest/position_notifier.dart';
import 'package:bannertest/ui_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'banner/ad_banner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Material(child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AdBanner(
              adUnit: UITexts.admobBannerApp,
            ),
            AdBanner(
              adUnit: UITexts.admobBannerSquare,
            ),
            RaisedButton(
              child: Text("Go to PreRoll"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<PositionNotifier>(
                          create: (_) => PositionNotifier(),
                        ),
                      ],
                      child: Material(child: SMPreRoll()),
                    ),
                  ),
                );
              },
            ),
            RaisedButton(
              child: Text("Go to Banner Not fading right"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BannerPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
