import 'package:bannertest/banner/sm_pre_roll.dart';
import 'package:bannertest/player_notifier.dart';
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerNotifier>(
            create: (_) => PlayerNotifier(),
          ),
        ],
        child: Material(
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  AdBanner(
                    adUnit: UITexts.admobBannerApp,
                  ),
                  AdBanner(
                    adUnit: UITexts.admobBannerSquare,
                  ),
                  RaisedButton(
                    child: Text("Load  PreRoll Stack"),
                    onPressed: () {
                      context.read<PlayerNotifier>().notifyHasAds(true);
                    },
                  ),
                  RaisedButton(
                    child: Text("Go to PreRoll Page"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider<PositionNotifier>(
                                create: (_) => PositionNotifier(),
                              ),
                            ],
                            child: Material(
                                child: SMPreRoll(
                              newPage: true,
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (context.select((PlayerNotifier p) => p.hasAds))
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider<PositionNotifier>(
                      create: (_) => PositionNotifier(),
                    ),
                  ],
                  child: Material(
                    child: SMPreRoll(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
