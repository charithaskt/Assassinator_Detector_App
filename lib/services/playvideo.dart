import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
class VideosPlayer extends StatefulWidget {
  final VideoPlayerController vpcontroller;
  final bool looping;

  VideosPlayer({
    @required this.vpcontroller,
    this.looping,
    Key key,
  }): super(key:key);
  @override
  _VideosPlayerState createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.vpcontroller,
      aspectRatio: 16/9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context,errorMessage){
        return Text(
          errorMessage,
          style: TextStyle(color: Colors.white60),
        );
      }
    );
  }
 /* void createVideo(){
    if (vpcontroller == null){
      vpcontroller = VideoPlayerController.asset("assets/videos/test.mp4")
      ..addListener(listener)
      ..setVolume(0.5)
      ..initialize()
      ..play();
    }
    else{
      if(vpcontroller.value.isPlaying){
        vpcontroller.pause();      
      }
      else{
        vpcontroller.initialize();
        vpcontroller.play();
      }
    }
  }
  @override
  void deactivate(){
    vpcontroller.setVolume(0.0);
    vpcontroller.removeListener(listener);
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children:<Widget>[ 
          AspectRatio(
          aspectRatio:16/9 ,
            child: (vpcontroller == null
                ? Container(): VideoPlayer(vpcontroller)),
            ),
          FloatingActionButton(
          onPressed:(){
            createVideo();
            vpcontroller.play();
          },
          child: Icon(Icons.play_arrow),
           )
        ],
      ),
          );
  }*/
  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose(){
    super.dispose();
    widget.vpcontroller.dispose();
    _chewieController.dispose();
  }
}
