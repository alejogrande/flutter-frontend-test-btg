import 'package:flutter/material.dart';

class HomeActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconContainerColor;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const HomeActionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconContainerColor,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el ancho disponible es mayor a 500, calculamos para que quepan 2 en fila
        // Restamos el spacing del Wrap (16) dividido entre 2.
        final double width = constraints.maxWidth > 500 
            ? (constraints.maxWidth / 2) - 8 
            : double.infinity;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconContainerColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconContainerColor, size: 24),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Un poco más pequeño para que no rompa en pantallas chicas
                          color: Color(0xFF002C5F),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                // Flecha a la derecha
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}