import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: VideoPlayerScreen(),
    debugShowCheckedModeBanner: false,
  );
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final yt = YoutubeExplode();
  final player = AudioPlayer();
  final textController = TextEditingController(text: 'https://youtu.be/jWJQl-9n3XA');
  String log = 'Tap Extract Audio';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
  }

  @override
  void dispose() {
    player.dispose();
    yt.close();
    super.dispose();
  }

  Future<void> extractAndPlay() async {
    setState(() {
      isLoading = true;
      log = 'Loading...';
    });
    
    try {
      final url = textController.text;
      final video = await yt.videos.get(url);
      final manifest = await yt.videos.streamsClient.getManifest(video.id.value);
      final audio = manifest.muxed.withHighestBitrate();
      
      log = '✅ SUCCESS\n${video.title}\nDuration: ${video.duration}\n'
          'Quality: ${audio.qualityLabel} (${audio.bitrate}kbps)\n'
          'Audio URL: ${audio.url}\n\n'
          'Playing...';
      
      await player.setUrl(audio.url.toString());
      await player.play();
      
    } catch (e) {
      log = '❌ Error: $e\nTry different video';
    }
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('YouTube Audio Player'), backgroundColor: Colors.red),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: 'YouTube URL', 
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: isLoading ? null : extractAndPlay,
            child: isLoading 
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
              : Text('Extract & Play Audio', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 20),
          Expanded(child: SingleChildScrollView(child: Text(log, style: TextStyle(fontSize: 16)))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                color: Colors.green,
                onPressed: () => player.play(),
                child: Text('▶️ Play'),
              ),
              MaterialButton(
                color: Colors.orange,
                onPressed: () => player.pause(),
                child: Text('⏸️ Pause'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';
  }
}
