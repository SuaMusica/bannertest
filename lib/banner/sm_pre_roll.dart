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
  }) : super(key: key);

  @override
  _SMPreRollState createState() => _SMPreRollState();
}

class _SMPreRollState extends State<SMPreRoll> {
  PreRollController _preRollController;
  PreRoll _preRoll;

  void preRollListener(PreRollEvent event, Map<String, dynamic> args) {
    switch (event) {
      case PreRollEvent.LOADED:
        _preRollController.play();
        break;
      case PreRollEvent.ALL_ADS_COMPLETED:
        Navigator.of(context).pop();
        break;
      case PreRollEvent.AD_PROGRESS:
        final position = int.parse(args["position"] as String);
        final duration = int.parse(args["duration"] as String);
        context.read<PositionNotifier>().dispatch(
              Duration(milliseconds: position),
              Duration(milliseconds: duration),
            );
        break;
      default:
        return;
    }
  }

  @override
  void initState() {
    _preRollController = PreRollController(preRollListener);
    _preRoll = PreRoll(
      controller: _preRollController,
      usePlatformLink: false,
    );
    final args = Map<String, String>();
    args["__URL__"] =
        "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480%7C400x300%7C730x400&iu=/7090806/Suamusica.com.br-ROA-Preroll&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&description_url=http%3A%2F%2Fwww.suamusica.com.br%2F&correlator=&tfcd=0&npa=0&cust_params=";

    args["__CONTENT__"] = 'https://assets.suamusica.com.br/video/silence.mp3';

    _preRollController.load(args);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AspectRatio(
          child: _preRoll,
          aspectRatio: 640 / 360,
        ),
        RegularProgressSlider(
          colorForeground: Colors.red,
          colorBackground: Colors.grey,
          disableSeeking: true,
        )
      ],
    );
  }
}
