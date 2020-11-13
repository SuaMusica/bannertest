import 'package:flutter/widgets.dart';

class _PositionState {
  _PositionState({this.position, this.duration});
  Duration position;
  Duration duration;
}

class PositionNotifier with ChangeNotifier {
  PositionNotifier() {
    _positionState = _PositionState(
      position: Duration(seconds: 0),
      duration: Duration(seconds: 0),
    );
    isSeeking = false;
  }

  _PositionState _positionState;

  Duration get position => _positionState.position;
  set position(Duration d) {
    _positionState.position = d;
    notifyListeners();
  }

  double get progress => (position == null || position.inSeconds == 0)
      ? 0
      : _positionState.position.inSeconds.toDouble() /
          _positionState.duration.inSeconds.toDouble();

  Duration get duration => _positionState.duration;
  bool isSeeking;
  Duration seekStart;
  Duration seekEnd;

  void dispatch(Duration position, Duration duration) {
    if (!isSeeking) {
      this._positionState.position = position;
      this._positionState.duration = duration;
      notifyListeners();
    }
  }

  void processPositionChange(Function(Duration, Duration) callback) {
    if (!isSeeking) {
      if (seekStart == null) {
        callback(
          position,
          duration,
        );
      } else {
        if ((seekEnd > seekStart && position > seekEnd) ||
            (seekEnd < seekStart && position < seekStart)) {
          callback(
            position,
            duration,
          );
          resetSeekInfo();
        }
      }
    }
  }

  void resetSeekInfo() {
    this.seekStart = null;
    this.seekEnd = null;
  }

  void reset() {
    debugPrint("Player: PlayerNotifify.reset()");
    this.isSeeking = false;
    this.resetSeekInfo();
    this._positionState.position = Duration(seconds: 0);
    this._positionState.duration = Duration(seconds: 0);
    notifyListeners();
  }
}
