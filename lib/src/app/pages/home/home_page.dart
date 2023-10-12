import 'package:eletronica_facil/src/app/pages/camera/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Uri _url = Uri.parse('https://pt.wikipedia.org/wiki/');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Eletrônica Fácil',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                letterSpacing: 6,
                fontSize: 24),
          ),
          centerTitle: true,
          // backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              flex: 4,
              child: CameraPage(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                child: const Text(
                  "Aponte para o componente",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _launchUrl();
          },
          elevation: 1,
          child: const Icon(Icons.search),
        ));
  }
}
