// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../globals/utils.dart';
import 'loader.dart';

class FullScreenVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const FullScreenVideoPlayerWidget({Key? key, required this.videoPlayerController}) : super(key: key);

  @override
  State<FullScreenVideoPlayerWidget> createState() => _FullScreenVideoPlayerWidgetState();
}

class _FullScreenVideoPlayerWidgetState extends State<FullScreenVideoPlayerWidget> {


  String timePlay = "0:0";
  Timer? timer;
  bool showReplayIcon = false;
  bool showController = false;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => renewTimeText());


    widget.videoPlayerController.addListener(() {
      checkVideo();
    });

    widget.videoPlayerController.initialize().then((_) {
        setState(() {});
        widget.videoPlayerController.play();
      });

  }

  void checkVideo(){
    if (!widget.videoPlayerController.value.isPlaying &&widget.videoPlayerController.value.isInitialized &&
        (widget.videoPlayerController.value.duration ==widget.videoPlayerController.value.position)) { //checking the duration and position every time

      showReplayIcon = true;
      setState(() {

      });
    }

  }
  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    timer?.cancel();
    super.dispose();
  }
  showingController(){
    showController = true;
    setState(() {

    });
    Future.delayed(const Duration(seconds: 10), () {

      showController = false;

      setState(() {
        // Here you can write your code for open new view
      });

    });
  }
  renewTimeText()async{
    var time = await widget.videoPlayerController.position;
    timePlay = "${time?.inMinutes}:${time?.inSeconds}";
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            child: Stack(
              children: [
                widget.videoPlayerController.value.isInitialized
                    ?InkWell(
                  onTap: (){
                    showingController();
                  },
                  child:   LayoutBuilder(
                      builder: (context, constraints) =>  AspectRatio(
                        aspectRatio: constraints.maxWidth / constraints.maxHeight,
                        // _controller.value.aspectRatio,
                        child: VideoPlayer(widget.videoPlayerController),
                      )
                )): Padding(
                  padding:  const EdgeInsets.all(5),
                  child: Container(
                      decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(15))
                      ),
                      child: const Loader()),
                ),
                showController?Positioned(
                    top: 10,
                    left: 10,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height:MediaQuery.of(context).size.height*0.07,
                        width:  MediaQuery.of(context).size.width*0.13,
                        decoration:  BoxDecoration(
                          color: Colors.black.withOpacity(0.50),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )):const SizedBox(),
                showController?Positioned(
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width:  MediaQuery.of(context).size.width*0.9,
                        decoration:  BoxDecoration(
                          color: Colors.black.withOpacity(0.50),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            children: [  IconButton(onPressed: (){
                              showingController();
                              widget.videoPlayerController.seekTo(Duration(
                                  seconds: widget.videoPlayerController.value.position.inSeconds - 10));
                            }, icon: const Icon(Icons.fast_forward,color: kWhiteColor,)),
                              IconButton(onPressed: (){
                                if(widget.videoPlayerController.value.isPlaying){
                                  widget.videoPlayerController.pause();
                                  showingController();
                                  setState(() {

                                  });
                                }else{
                                  widget.videoPlayerController.play();
                                  showingController();
                                  setState(() {

                                  });
                                }
                              }, icon: widget.videoPlayerController.value.isPlaying?const Icon(Icons.pause,color: kWhiteColor,):const Icon(Icons.play_arrow,color: kWhiteColor,)),
                              IconButton(onPressed: (){
                                showingController();
                                widget.videoPlayerController.seekTo(Duration(
                                    seconds: widget.videoPlayerController.value.position.inSeconds + 10));
                              }, icon: const Icon(Icons.fast_rewind,color: kWhiteColor,)),

                              Container(
                                width:  MediaQuery.of(context).size.width*0.2,
                                height: 10,
                                child:ClipRRect(
                                  borderRadius: BorderRadius.circular(3.0),
                                  child: VideoProgressIndicator(

                                    widget.videoPlayerController,
                                    allowScrubbing: true,
                                    colors:  VideoProgressColors(

                                        backgroundColor: kGrayColor.withOpacity(0.5),
                                        bufferedColor:kGrayColor.withOpacity(0.5),
                                        playedColor: kWhiteColor),
                                  ),
                                ),
                              ),
                              IconButton(onPressed: (){
                                if(widget.videoPlayerController.value.volume == 0.0){
                                  widget.videoPlayerController.setVolume(50);
                                  showingController();
                                  setState(() {

                                  });
                                }else{
                                  widget.videoPlayerController.setVolume(0);
                                  showingController();
                                  setState(() {

                                  });
                                }
                              }, icon: widget.videoPlayerController.value.volume == 0.0?const Icon(Icons.volume_mute,color: kWhiteColor,):const Icon(Icons.volume_up,color: kWhiteColor,)),
                              Text(
                                  "${widget.videoPlayerController.value.duration.inMinutes}:${widget.videoPlayerController.value.duration.inSeconds}",
                                  style:const TextStyle(color: kWhiteColor,fontWeight: FontWeight.bold,fontSize: 18)

                              ),
                              const Text(
                                  "/",
                                  style:TextStyle(color: kWhiteColor,fontWeight: FontWeight.bold,fontSize: 18)

                              ),
                              Text(
                                  timePlay,
                                  style:const TextStyle(color: kWhiteColor,fontWeight: FontWeight.bold,fontSize: 18)

                              ),
                            ],
                          ),
                        ),
                      ),
                    )):const SizedBox(),
                showReplayIcon?InkWell(
                  onTap: (){
                    showReplayIcon = false;
                    setState(() {
                    });
                    widget.videoPlayerController.seekTo(Duration.zero);
                    widget.videoPlayerController.play();

                  },
                  child: Center(
                    child: AspectRatio(
                      aspectRatio:  widget.videoPlayerController.value.aspectRatio,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height:MediaQuery.of(context).size.height*0.1,
                            width:  MediaQuery.of(context).size.width*0.2,
                            decoration:  BoxDecoration(
                              color: Colors.black.withOpacity(0.50),
                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.replay,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ):const SizedBox(),
              ],
            )),
      ),
    );
  }
}