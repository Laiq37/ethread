import 'dart:io';

// import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

// const pathToSaveAudio = "audio_example.aac";

class SoundRecorder {
  Record? _audioRecorder;
  bool _isRecorderInitialized = false;

 get isInitialized => _isRecorderInitialized;
  
  Future init()async{
    _audioRecorder = Record();
    _isRecorderInitialized = true;
  }

  Future<bool> haveSession()async{
    return await _audioRecorder!.isRecording();
    
  }

  void dispose(){
    _audioRecorder?.dispose();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future record() async {
    if(!_isRecorderInitialized) return;
    Directory? directory = await getExternalStorageDirectory();
    final String fileName = DateTime.now().toString();
      String path = "${directory!.path}/$fileName.3gp";
    await _audioRecorder!.start(path: path, encoder: AudioEncoder.aacHe);
  }

  Future<String?> stop() async {
    if(!_isRecorderInitialized) return null;
    final path = await _audioRecorder!.stop();
    return path;
  }
}