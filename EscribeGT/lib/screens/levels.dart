import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'board.dart';

class level {
  final String title;
  final String description;
  const level(this.title, this.description);
}

class levelsScreen extends StatelessWidget {
  const levelsScreen({super.key, required this.levelss});
  final List<level> levelss;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listado de Ejercicios'),
        ),
        body: Material(
            color: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(197, 5, 95, 50),
                borderRadius: BorderRadius.circular(1),
                border: Border.all(
                  color: Color(0xFF563232),
                  width: 30,
                ),
              ),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                ListView.separated(
                  itemCount: levelss.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        levelss[index].title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Roboto',
                          color: Colors.white,
                          fontSize: 80,
                        ),
                      ),
                      // When a user taps the ListTile, navigate to the DetailScreen.
                      // Notice that you're not only creating a DetailScreen, you're
                      // also passing the current todo through to it.
                      onTap: () {
                        Navegar(context, levelss[index]);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 2.0,
                      thickness: 6.0,
                    );
                  },
                ),
              ]),
            )));
  }

  void Navegar(BuildContext context, level n) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyBoard(title: n.title, url: n.description),
      ),
    );
  }
}
