import 'package:bannertest/position_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegularProgressSlider extends StatelessWidget {
  const RegularProgressSlider({
    Key key,
    this.colorBackground,
    this.colorForeground,
    this.disableSeeking = false,
  }) : super(key: key);

  final Color colorBackground, colorForeground;
  final bool disableSeeking;
  @override
  Widget build(BuildContext context) {
    final positionNotifier = context.watch<PositionNotifier>();
    return Stack(children: <Widget>[
      Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  _durationToString(positionNotifier.position),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Text(
                  _durationToString(positionNotifier.duration),
                ),
              )
            ],
          ),
        ],
      ),
      if (positionNotifier.duration != null)
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 5.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: Slider(
              activeColor: colorForeground ?? Colors.red,
              inactiveColor: colorBackground ?? Colors.grey,
              min: 0.0,
              max: positionNotifier.duration.inMilliseconds.toDouble(),
              value: positionNotifier.duration.inMilliseconds.toDouble() >
                      positionNotifier.position?.inMilliseconds?.toDouble()
                  ? positionNotifier.position?.inMilliseconds?.toDouble() ?? 0.0
                  : 0.0,
              onChanged: (double value) {
                if (!disableSeeking) {
                  positionNotifier.position =
                      Duration(milliseconds: value.toInt());
                }
              },
            ),
          ),
        ),
    ]);
  }

  String _durationToString(Duration d) {
    if (d == null || d.inSeconds <= 0) {
      return "00:00";
    }
    final minutes = d.inMinutes.toString().padLeft(2, "0");
    final seconds = (d.inSeconds % 60).toString().padLeft(2, "0");
    return minutes + ":" + seconds;
  }
}
