import 'package:flutter/material.dart';
import 'package:solucion_pistolas_onduladora/src/Utilidades/utils.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class PaginaReproductor extends StatefulWidget {
  String sRutaVideo = "";

  PaginaReproductor({super.key, required this.sRutaVideo});

  @override
  _PaginaReproductorState createState() => _PaginaReproductorState();
}

class _PaginaReproductorState extends State<PaginaReproductor> {
  late VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.sRutaVideo);

    // _initializeVideoPlayerFuture = _controller.initialize();

    // _controller.setLooping(true);
    super.initState();

    //..initialize().then((_) {   // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//setState(() {});
    //    });
  }

  Future<bool> started() async {
    await _controller.initialize();
    await _controller.play();
    startedPlaying = true;
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dameAppBar(titulo: "Reproductor", fontSize: 25.0),
      body: FutureBuilder(
        future: started(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el VideoPlayerController ha finalizado la inicialización, usa
            // los datos que proporciona para limitar la relación de aspecto del VideoPlayer

            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Usa el Widget VideoPlayer para mostrar el vídeo
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            // Si el VideoPlayerController todavía se está inicializando, muestra un
            // spinner de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      /* Center(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(child: Text("aqui no hay nada"),),
      ),*/
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Envuelve la reproducción o pausa en una llamada a `setState`. Esto asegura
          // que se muestra el icono correcto
          setState(() {
            // Si el vídeo se está reproduciendo, pausalo.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // Si el vídeo está pausado, reprodúcelo
              _controller.play();
            }
          });
        },
        // Muestra el icono correcto dependiendo del estado del vídeo.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),*/
    );
  }
}
