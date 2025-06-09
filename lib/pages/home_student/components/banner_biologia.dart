import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/pages/cuestionario/lista_cuestionario/page_lista_cuestionario_estudiante.dart';
import 'package:flutter_application/pages/juegos/lista_juegos/page_lista_juegos.dart';
import 'package:flutter_application/pages/unidades/lista_unidades/page_lista_unidades_estudiante.dart';
import 'package:flutter_application/pages/videos_interactivos/lista_videos/page_lista_videos_estudiante.dart';
import '../../../size_config.dart';

class BannerBiologia extends StatelessWidget {
  const BannerBiologia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaUnidadesEstudiante(area: 'biologia'),
                          )
                        );
                      },
                      leading: const Icon(Icons.library_books), // Ícono para el índice de unidades
                      title: Text(
                        'Indice de unidades',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaVideosEstudiante(area: 'biologia'),
                          )
                        );
                      },
                      leading: const Icon(Icons.play_circle_filled), // Ícono para videos interactivos
                      title: Text(
                        'Videos interactivos',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaCuestionariosEstudiante(area: 'biologia'),
                          ),
                        );
                      },
                      leading: const Icon(Icons.edit), // Ícono para exámenes
                      title: Text(
                        'Examenes',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListaVideojuegosPage(materiaEstudiante: 'biologia'),
                          ),
                        );
                      },
                      leading: const Icon(Icons.gamepad), // Ícono para juegos interactivos
                      title: Text(
                        'Juegos interactivos',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(getProportionateScreenWidth(20)),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(15),
          vertical: getProportionateScreenWidth(10),
        ),
        decoration: BoxDecoration(
          color: gColorBanner1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/banners/biologia.png',
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenWidth(80),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido al Área de Biología',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      Text(
                        '¡Explora los secretos de la biología con este modulo!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
