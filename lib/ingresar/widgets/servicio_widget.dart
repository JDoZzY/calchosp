import 'package:flutter/material.dart';

Future<String?> mostrarSelectorServicio(BuildContext context, String? servicioSeleccionado) {
  final List<String> servicios = [
    'Consulta externa',
    'Emergencias',
    'Hospitalización',
    'UCI',
    'Pediatría',
    'Ginecología',
    'Cirugía',
    'Laboratorio',
    'Rayos X',
    'Farmacia',
  ];

  final Color colorSeleccion = const Color(0xFF248277);

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 12,
        backgroundColor: Colors.white,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            maxWidth: 360,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar servicio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: servicios.length,
                  itemBuilder: (context, index) {
                    final servicio = servicios[index];
                    final bool isSelected = servicio == servicioSeleccionado;
                    return InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => Navigator.pop(context, servicio),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? colorSeleccion.withValues(alpha: 0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle : Icons.circle_outlined,
                              color: isSelected ? colorSeleccion : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                servicio,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected ? colorSeleccion : Colors.black87,
                                ),
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
      );
    },
  );
}
