// import 'package:flutter/cupertino.dart';
// import 'package:flutter_sound/public/flutter_sound_player.dart';

// const pathToReadAudio = "audio_example.aac";

// class SoundPlayer{
//    FlutterSoundPlayer? _audioPlayer;

//    Future init()async{
//      _audioPlayer = FlutterSoundPlayer();

//      await _audioPlayer!.openPlayer();

//    }

//    void dispose(){
//      _audioPlayer?.closePlayer();
//      _audioPlayer = null;
//    }

//    Future _play(VoidCallback whenFinished, String path)async{
//      await _audioPlayer!.startPlayer(fromURI: path,whenFinished: whenFinished);
//    }

//    Future _stop()async{
//      await _audioPlayer!.stopPlayer();
//    }

//    Future togglePlaying({required VoidCallback whenFinished, required String path}) async {
//      print('isAudioPlaye is stopped : ${_audioPlayer!.isStopped}');
//      if (_audioPlayer!.isStopped) {
//        await _play(whenFinished, path);
//      } else {
//        await _stop();
//      }
//    }


// }



