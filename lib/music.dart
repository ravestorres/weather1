import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/news.dart';
import 'package:flutter_application_1/player.dart';
import 'package:just_audio/just_audio.dart'; 
import 'package:flutter_application_1/card.dart'; 

class Song {
  final String title;
  final String artist;
  final String album;
  final String albumCoverPath;
  final String audioPath; 

  Song({
    required this.title,
    required this.artist,
    required this.album,
    required this.albumCoverPath,
    required this.audioPath,
  });
}

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late AudioPlayer _audioPlayer;
  late List<Song> _songs;
  late Song _currentSong;
  Duration? _position;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchWeatherData();
    _audioPlayer.positionStream.listen((event) {
      setState(() {
        _position = event;
      });
    });
  }

  void fetchWeatherData() {
    double temperature = 28; // Assume 28 degrees Celsius
    bool isSunny = true; // Assume it's sunny

    if (temperature >= 27 && isSunny) {
      setState(() {
        _songs = _getSunnyPlaylist();
        _playRandomTrack();
      });
    } else {
      // Add conditions for rainy, thunderstorm, or typhoon
      bool isRaining = false; // Assume it's not raining
      bool isThunderstorm = false; // Assume there's no thunderstorm
      bool hasTyphoon = false; // Assume there's no typhoon

      if (temperature < 27 || isRaining || isThunderstorm || hasTyphoon) {
        setState(() {
          _songs = _getRainyPlaylist();
          _playRandomTrack();
        });
      }
    }
  }

  void _playRandomTrack() async {
    Random random = Random();
    int randomIndex = random.nextInt(_songs.length);
    _currentSong = _songs[randomIndex];
    await _loadSong();
  }

  List<Song> _getSunnyPlaylist() {
    return [
      Song(
        title: 'Pantropiko',
        artist: 'BINI',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/1.jpg',
        audioPath: 'assets/musics/1.mp3', 
      ),
       Song(
        title: 'Espresso',
        artist: 'Sabrina Carpenter',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/2.jpg',
        audioPath: 'assets/musics/2.mp3', 
      ),
         Song(
        title: "I Ain't Worried",
        artist: 'OneRepublic',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/3.jpg',
        audioPath: 'assets/musics/3.mp3', 
      ),
         Song(
        title: "Attention (250 Remix)",
        artist: 'NewJeans',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/4.jpg',
        audioPath: 'assets/musics/4.mp3', 
      ),
         Song(
        title: "Teenage Dream",
        artist: 'Katy Perry',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/5.jpg',
        audioPath: 'assets/musics/5.mp3', 
      ),
      
    ];
  }

  List<Song> _getRainyPlaylist() {
    return [
      Song(
        title: 'Sofia',
        artist: 'Claro',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/6.jpg',
        audioPath: 'assets/musics/6.mp3', 
      ),
      Song(
        title: 'It Will Rain',
        artist: 'Bruno Mars',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/7.jpg',
        audioPath: 'assets/musics/7.mp3', 
      ),
       Song(
        title: "I'll Make Love To You",
        artist: 'Boyz II Men',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/8.jpg',
        audioPath: 'assets/musics/8.mp3', 
      ),
       Song(
        title: "NVMD",
        artist: 'Denise Julia',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/9.jpg',
        audioPath: 'assets/musics/9.mp3', 
      ),
           Song(
        title: "Give Me Your Forever",
        artist: 'Zack Tabudlo',
        album: 'Album 1',
        albumCoverPath: 'assets/pic/10.jpg',
        audioPath: 'assets/musics/10.mp3', 
      ),
      
    ];
  }

  Future<void> _loadSong() async {
    try {
      await _audioPlayer.setAsset(_currentSong.audioPath);
      _audioPlayer.setVolume(1.0); // Set volume to maximum
      await _audioPlayer.play(); // Ensure playback starts after loading the song
    } catch (e) {
      print('Error loading audio: $e');
      // Handle the error, such as displaying a message to the user
      // or falling back to a default song.
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SongCard(
              songPath: _currentSong.albumCoverPath,
              albumCoverPath: _currentSong.albumCoverPath,
              onAlbumCoverChanged: (newPath) {},
            ),
            SizedBox(height: 10),
            Text(
              _currentSong.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _currentSong.artist,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            PlayerBar(
              songPath: _currentSong.albumCoverPath,
              audioPlayer: _audioPlayer,
              songs: _songs.map((song) => song.albumCoverPath).toList(),
              onSongChanged: (index) {
                setState(() {
                  _currentSong = _songs[index];
                });
                _loadSong();
              },
              onPrevious: () {
                int previousIndex = _songs.indexOf(_currentSong) - 1;
                if (previousIndex < 0) {
                  previousIndex = _songs.length - 1;
                }
                setState(() {
                  _currentSong = _songs[previousIndex];
                });
                _loadSong();
              },
              onNext: () {
                int nextIndex = _songs.indexOf(_currentSong) + 1;
                if (nextIndex >= _songs.length) {
                  nextIndex = 0;
                }
                setState(() {
                  _currentSong = _songs[nextIndex];
                });
                _loadSong();
              },
              currentIndex: 1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.grey), 
              onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.new_releases, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.music_note, color: Colors.blue),
              onPressed: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
