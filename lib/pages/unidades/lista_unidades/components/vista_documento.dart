import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';


class PDFViewPage extends StatefulWidget {
  final String filePath;

  const PDFViewPage({super.key, required this.filePath});

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late PdfControllerPinch pdfController;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    pdfController = PdfControllerPinch(
      document: PdfDocument.openFile(widget.filePath),
    );
  }

  void _zoomIn() {
    setState(() {
      _currentZoom += 0.2;
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 0.2).clamp(1.0, 3.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visor de material educativo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
        ],
      ),
      body: Transform.scale(
        scale: _currentZoom,
        alignment: Alignment.center,
        child: PdfViewPinch(
          controller: pdfController,
          padding: 10,
          onDocumentLoaded: (info) {
            Get.snackbar(
              'Documento Cargado',
              'Número de páginas: ${info.pagesCount}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: gColorTheme1_900,
              colorText: Colors.white,
            );
          },
        ),
      ),
    );
  }
}
