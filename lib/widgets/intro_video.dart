import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPopup extends StatefulWidget {
  @override
  _VideoPopupState createState() => _VideoPopupState();
}

class _VideoPopupState extends State<VideoPopup> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _showPlayPause = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/Shopit.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _onVideoTap() {
    setState(() {
      _showPlayPause = !_showPlayPause;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: _controller.value.isInitialized
          ? Container(
              width: 300,
              height: 300,
              child: GestureDetector(
                onTap: _onVideoTap,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: _closeDialog,
                      ),
                    ),
                    
                    if (_showPlayPause)
                      Center(
                        child: IconButton(
                          iconSize: 60,
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            _togglePlayPause();
                            setState(() {
                              _showPlayPause = false; 
                            });
                          },
                        ),
                      ),
                    
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: _toggleMute,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: 300,
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}




