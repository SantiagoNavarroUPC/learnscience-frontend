import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/controllers/controller_pregunta_video.dart';
import 'package:flutter_application/controllers/controller_usuario.dart';
import 'package:flutter_application/controllers/controller_video.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/components/page_lista_respuestas_video.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InteractiveVideoPage extends StatefulWidget {
  final String videoUrl;
  final int? idVideo;

  const InteractiveVideoPage({super.key, required this.videoUrl,required this.idVideo});

  @override
  _InteractiveVideoPageState createState() => _InteractiveVideoPageState();
}

class _InteractiveVideoPageState extends State<InteractiveVideoPage> {
  late YoutubePlayerController _youtubePlayerController;
  final TextEditingController _videoThoughtController = TextEditingController();
  final TextEditingController _videoDislikeController = TextEditingController();
  final TextEditingController _videoLifeApplicationController = TextEditingController();
  PreguntaVideoController preguntaVideoController = Get.find<PreguntaVideoController>();
  UsuarioController usuarioController = Get.find<UsuarioController>();
  VideoController videoController = Get.find<VideoController>();
  bool _isMuted = false;
  
  


  @override
  void initState() {
    super.initState();
    final String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    _videoThoughtController.dispose();
    _videoDislikeController.dispose();
    _videoLifeApplicationController.dispose();
    super.dispose();
  }

  void _saveResponses() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Respuestas Guardadas'),
      content: const Text('Tus respuestas han sido guardadas.'),
      actions: [
        TextButton(
          onPressed: () {
            _youtubePlayerController.pause();
            final idUsuario = usuarioController.usuario.value?.idUsuario;
            final idVideo = widget.idVideo;
            final respuesta1 = _videoThoughtController.text;
            final respuesta2 = _videoDislikeController.text;
            final respuesta3 = _videoLifeApplicationController.text;

            final preguntaVideoData = {
              "idPreguntasVideos": 0,
              "idVideo": idVideo,
              'idUsuario': idUsuario,
              'respuesta1': respuesta1,
              "respuesta2": respuesta2,
              "respuesta3": respuesta3,
              'calificacion': 0,
              'eliminado': false
            };

            preguntaVideoController.registrarPreguntaVideo(preguntaVideoData);
            
            _videoThoughtController.clear();
            _videoDislikeController.clear();
            _videoLifeApplicationController.clear();

            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final rol = usuarioController.usuario.value?.tipo;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualización de videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          if (rol == 'profesor') 
            IconButton(
              icon: const Icon(Icons.list_alt_rounded),
              onPressed: () {
                _youtubePlayerController.pause();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreguntasVideoPage(videoId: widget.idVideo!),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildControlButtons(),
                _buildQuestionSection('¿De qué trata el video?', _videoThoughtController),
                _buildQuestionSection('¿Qué te gustó del video?', _videoDislikeController),
                _buildQuestionSection('¿Cómo lo llevarías a la vida cotidiana?', _videoLifeApplicationController),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _saveResponses,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: gColorTheme1_600,
                      foregroundColor: gColorTheme1_1,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Guardar Respuestas'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(String question, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 2,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escribe tu respuesta aquí...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.pause, size: 40, color: gColorTheme1_900),
            onPressed: () => _youtubePlayerController.pause(),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 40, color: gColorTheme1_900),
            onPressed: () => _youtubePlayerController.play(),
          ),
          IconButton(
            icon: const Icon(Icons.replay_10, size: 40, color: gColorTheme1_900),
            onPressed: () {
              _youtubePlayerController.seekTo(
                Duration(seconds: _youtubePlayerController.value.position.inSeconds - 10),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.forward_10, size: 40, color: gColorTheme1_900),
            onPressed: () {
              _youtubePlayerController.seekTo(
                Duration(seconds: _youtubePlayerController.value.position.inSeconds + 10),
              );
            },
          ),
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, size: 40, color: gColorTheme1_900),
            onPressed: () {
              setState(() {
                _isMuted ? _youtubePlayerController.unMute() : _youtubePlayerController.mute();
                _isMuted = !_isMuted;
              });
            },
          ),
        ],
      ),
    );
  }
}
