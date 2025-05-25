import 'package:flutter/material.dart';

class CalendarioWidget extends StatefulWidget {
  final Function(DateTime) onFechaSeleccionada;
  final DateTime fechaActual;

  const CalendarioWidget({
    super.key,
    required this.onFechaSeleccionada,
    required this.fechaActual,
  });

  @override
  State<CalendarioWidget> createState() => CalendarioWidgetState();
}

class CalendarioWidgetState extends State<CalendarioWidget> {
  late DateTime tempPickedDate;

  @override
  void initState() {
    super.initState();
    tempPickedDate = widget.fechaActual;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12),
      backgroundColor: Colors.white,
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Selecciona una fecha",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF248277), // Color del día seleccionado
                  onPrimary: Colors.white, // Texto del día seleccionado
                  onSurface: Colors.black, // Texto general
                ),
              ),
              child: CalendarDatePicker(
                initialDate: tempPickedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                onDateChanged: (DateTime date) {
                  setState(() {
                    tempPickedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Color(0xFF036666)),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onFechaSeleccionada(tempPickedDate);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF248277),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
