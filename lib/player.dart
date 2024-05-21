import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerBar extends StatefulWidget {
  final String songPath;
  final AudioPlayer audioPlayer;
  final int currentIndex;
  final List<String> songs;
  final Function(int) onSongChanged;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const PlayerBar({
    Key? key,
    required this.songPath,
    required this.audioPlayer,
    required this.currentIndex,
    required this.songs,
    required this.onSongChanged,
    this.onPrevious,
    this.onNext,
  }) : super(key: key);

  @override
  _PlayerBarState createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  late bool isPlaying;
  late bool isRepeating = false;
  late bool isShuffling = false; // Added variable for shuffle mode
  late double volume = 1.0;
  late Duration _duration;
  late Duration _position;
  late String _trackLength;
  late String _currentPosition;

  @override
  void initState() {
    super.initState();
    isPlaying = true;
    isRepeating = false;
    _duration = Duration.zero;
    _position = Duration.zero;
    _trackLength = '0:00';
    _currentPosition = '0:00';
    widget.audioPlayer.setVolume(volume);
    widget.audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
        _trackLength = _formatDuration(_duration);
      });
    });
    widget.audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position ?? Duration.zero;
        _currentPosition = _formatDuration(_position);
      });
    });
    widget.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (isRepeating) {
          _playCurrentTrack();
        } else if (isShuffling) {
          _shuffleSongs(); // Play next shuffled track if in shuffle mode
        } else {
          _playNextTrack();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.repeat, color: isRepeating ? Colors.blue : Colors.white),
                onPressed: () {
                  setState(() {
                    isRepeating = !isRepeating;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: widget.onPrevious,
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: _playPause,
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: widget.onNext,
              ),
              IconButton(
                icon: Icon(Icons.shuffle, color: isShuffling ? Colors.blue : Colors.white), // Change color based on shuffle mode
                onPressed: () {
                  setState(() {
                    isShuffling = !isShuffling; // Toggle shuffle mode
                    if (isShuffling) {
                      _shuffleSongs(); // Shuffle songs when activated
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentPosition,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                  onChanged: (value) {
                    final newPosition = Duration(milliseconds: value.toInt());
                    widget.audioPlayer.seek(newPosition);
                  },
                  min: 0,
                  max: _duration.inMilliseconds.toDouble(),
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey[600],
                ),
              ),
              Text(
                _trackLength,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.volume_down, color: Colors.white),
                onPressed: () {
                  setVolume(volume - 0.1);
                },
              ),
              Slider(
                value: volume,
                onChanged: (value) {
                  setVolume(value);
                },
                min: 0.0,
                max: 1.0,
                activeColor: Colors.white,
                inactiveColor: Colors.grey[600],
              ),
              IconButton(
                icon: Icon(Icons.volume_up, color: Colors.white),
                onPressed: () {
                  setVolume(volume + 0.1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void setVolume(double newVolume) {
    setState(() {
      volume = newVolume.clamp(0.0, 1.0);
    });
    widget.audioPlayer.setVolume(volume);
  }

  void _playPause() {
    if (isPlaying) {
      print('Pausing audio');
      widget.audioPlayer.pause();
    } else {
      print('Resuming audio');
      widget.audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _playNextTrack() {
    int nextIndex = widget.currentIndex + 1;
    if (nextIndex >= widget.songs.length) {
      nextIndex = 0;
    }
    widget.onSongChanged(nextIndex);
  }

  void _playCurrentTrack() {
    widget.audioPlayer.seek(Duration.zero);
    widget.audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  void _shuffleSongs() {
    final List<String> shuffledSongs = List.from(widget.songs)..shuffle();
    final int newIndex = shuffledSongs.indexOf(widget.songs[widget.currentIndex]);
    widget.onSongChanged(newIndex);
  }
}
