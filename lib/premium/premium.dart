import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: const Color(0xFF036666),
              ),

              Container(
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF248277),
                      Color(0xFF036666),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 4,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Premium',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cuerpo
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Planes y Beneficios',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF248277),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _sectionTitle('🟢 Plan Gratuito incluye:'),
                      _buildFeature(Icons.person, 'Registro de hasta 5 pacientes'),
                      _buildFeature(Icons.calculate, 'Cálculo de IMC y Peso Ideal'),
                      _buildFeature(Icons.book, 'Acceso limitado a Antropometría'),

                      const SizedBox(height: 20),
                      _sectionTitle('🎓 Plan Estudiante - Pago Único'),
                      _buildPlanCard(
                        title: 'Estudiante',
                        description:
                        'Accede a todos los cálculos nutricionales, QR para compartir pacientes, exportación de datos y más.',
                        price: 'S/ 14.99 - pago único',
                        color: Colors.teal.shade700,
                        onTap: () {
                        },
                      ),

                      const SizedBox(height: 20),
                      _sectionTitle('🏥 Plan Institucional'),
                      _buildPlanCard(
                        title: 'Hospitales y Universidades',
                        description:
                        'Licencia anual con soporte técnico, uso en múltiples dispositivos y personalización con logo institucional.',
                        price: 'Desde S/ 249.00 / año',
                        color: Colors.indigo,
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF036666),
      ),
    );
  }

  static Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF248277)),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  static Widget _buildPlanCard({
    required String title,
    required String description,
    required String price,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.workspace_premium, color: color, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
