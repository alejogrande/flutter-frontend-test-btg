import 'package:btg_funds_app/core/navigation/navigation_cubit.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_action_card.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_active_investments_card.dart';
import 'package:btg_funds_app/presentation/features/home_dashboard/widgets/home_balance_card.dart';
import 'package:btg_funds_app/presentation/widgets/small_info_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos el ancho máximo para que no se vea estirado en pantallas grandes
    const double maxContentWidth = 1300;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo ligeramente gris/blanco
      appBar: AppBar(
        title: const Text(
          'Portal de Inversiones',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BalanceCard(),
                const SizedBox(height: 24),

                // --- FILA DE 3 CARDS (Total, Rentabilidad, Ganancias) ---
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 500;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      children: [
                        SmallInfoCard(
                          title: 'Total invertido',
                          value: '\$0',
                          isWide: isWide,
                        ),
                        SmallInfoCard(
                          title: 'Rentabilidad',
                          value: '0%',
                          isWide: isWide,
                        ),
                        SmallInfoCard(
                          title: 'Ganancias',
                          value: '\$0',
                          isWide: isWide,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // --- BOTONES DE ACCIÓN ---
                Wrap(
                  spacing: 16, // Espacio horizontal entre botones
                  runSpacing:
                      12, // Espacio vertical cuando saltan a la siguiente línea
                  children: [
                    HomeActionButton(
                      title: 'Inversiones disponibles',
                      subtitle: 'Explora nuevas inversiones',
                      icon: Icons.auto_graph_rounded,
                      iconContainerColor: const Color(0xFF7E57C2),
                      backgroundColor: const Color(0xFFF3E5F5),
                      onTap: () =>
                          context.read<NavigationCubit>().goToExplorer(),
                    ),
                    HomeActionButton(
                      title: 'Histórico de inversiones',
                      subtitle: 'Revisa tus inversiones pasadas',
                      icon: Icons.history_rounded,
                      iconContainerColor: const Color(0xFF2E7D32),
                      backgroundColor: Colors.white,
                      onTap: () =>
                          context.read<NavigationCubit>().goToHistory(),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                // --- LISTA DE INVERSIONES ACTIVAS ---
                const ActiveInvestmentsCard(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
