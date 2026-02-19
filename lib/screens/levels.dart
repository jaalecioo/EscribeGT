import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'board.dart';

class level {
  final String title;
  final String description;
  const level(this.title, this.description);
}

class levelsScreen extends StatelessWidget {
  const levelsScreen({
    super.key,
    required this.levelss,
    required this.edad,
  });

  final List<level> levelss;
  final int edad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Ejercicios'),
      ),
      body: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: AppTheme.contenedorPrincipal,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: levelss.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navegar(context, levelss[index]),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF563232),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.brown.shade200,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.edit,
                              color: Colors.amber,
                              size: 28,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              levelss[index].title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.handlee(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegar(BuildContext context, level n) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyBoard(
          title: n.title,
          url: n.description,
          edad: edad,
        ),
      ),
    );
  }
}
