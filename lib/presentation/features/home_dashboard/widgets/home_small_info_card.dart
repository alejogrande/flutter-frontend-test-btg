import 'package:flutter/material.dart';

class SmallInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isWide;

  const SmallInfoCard({super.key, required this.title, required this.value, required this.isWide});

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity, 
      margin: EdgeInsets.only(
        bottom: isWide ? 0 : 12,
        right: isWide ? 8 : 0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ocupa solo el alto necesario de los textos
        children: [
          Text(title, 
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13), 
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 8),
          Text(value, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
          ),
        ],
      ),
    );

    // Solo aplicamos Expanded si estamos en una fila (isWide)
    return isWide ? Expanded(flex: 1, child: content) : content;
  }
}