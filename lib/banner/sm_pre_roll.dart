import 'package:bannertest/player_notifier.dart';
import 'package:bannertest/position_notifier.dart';
import 'package:bannertest/regular_progress_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smads/pre_roll.dart';
import 'package:smads/pre_roll_controller.dart';
import 'package:smads/pre_roll_events.dart';

class SMPreRoll extends StatefulWidget {
  const SMPreRoll({
    Key key,
    this.newPage = false,
  }) : super(key: key);
  final bool newPage;
  @override
  _SMPreRollState createState() => _SMPreRollState();
}

class _SMPreRollState extends State<SMPreRoll> {
  PreRollController _preRollController;
  PreRoll _preRoll;
  bool _loaded = false, _alreadyCompleted = false;
  void preRollListener(PreRollEvent event, Map<String, dynamic> args) {
    print(event);
    switch (event) {
      case PreRollEvent.LOADED:
        setState(() {
          _loaded = true;
        });
        break;
      case PreRollEvent.ERROR:
      case PreRollEvent.ALL_ADS_COMPLETED:
      case PreRollEvent.COMPLETED:
        if (!_alreadyCompleted) {
          _alreadyCompleted = true;
          if (widget.newPage) {
            Navigator.of(context).pop();
          } else {
            context.read<PlayerNotifier>().notifyHasAds(false);
          }
        }
        break;
      case PreRollEvent.AD_PROGRESS:
        context.read<PositionNotifier>().dispatch(
              Duration(milliseconds: int.parse(args["position"] as String)),
              Duration(milliseconds: int.parse(args["duration"] as String)),
            );
        break;
      default:
        return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _preRollController.dispose();
  }

  @override
  void initState() {
    _preRollController = PreRollController(preRollListener);
    _preRoll = PreRoll(
      controller: _preRollController,
    );
    final args = Map<String, String>();
    // args["__URL__"] ="https://pubads.g.doubleclick.net/gampad/ads?sz=640x480%7C400x300%7C730x400&iu=/7090806/Suamusica.com.br-ROA-Preroll&impl=s&gdfp_req=1&env=instream&output=vast&unviewed_position_start=1&description_url=http%3A%2F%2Fwww.suamusica.com.br%2F&correlator=&tfcd=0&npa=0&cust_params=";
    args["__URL__"] =
        "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=instream&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator=";

    args["__CONTENT__"] = 'https://assets.suamusica.com.br/video/silence.mp3';

    _preRollController.load(args);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loaded
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AspectRatio(
                child: _preRoll,
                aspectRatio: 640 / 360,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      onPressed: () => _preRollController.play(),
                      child: Text("PLAY"),
                    ),
                    RaisedButton(
                      onPressed: () => _preRollController.pause(),
                      child: Text("PAUSE"),
                    ),
                    RaisedButton(
                      onPressed: () => widget.newPage
                          ? Navigator.of(context).pop()
                          : context.read<PlayerNotifier>().notifyHasAds(false),
                      child: Text("EXIT"),
                    ),
                  ],
                ),
              ),
              RegularProgressSlider(
                colorForeground: Colors.red,
                colorBackground: Colors.grey,
                disableSeeking: true,
              )
            ],
          )
        : Center(
            child: Container(
              width: 300,
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
  }
}
