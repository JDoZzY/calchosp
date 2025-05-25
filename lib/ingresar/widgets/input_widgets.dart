import 'package:flutter/material.dart';

class InputWidgets {
  static Widget buildInputField(TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white.withAlpha(200),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF248277)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget buildInputFieldCustom(TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        contentPadding: const EdgeInsets.all(8),
        filled: true,
        fillColor: Colors.white.withAlpha(200),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF248277)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget buildNumericInput(TextEditingController controller, IconData icon, {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        contentPadding: const EdgeInsets.all(8),
        filled: true,
        fillColor: Colors.white.withAlpha(200),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF248277)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget buildRadioSelector({
    required BuildContext context,
    required String tipo,
    required bool? groupValue,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: groupValue,
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
          const Text('Real', style: TextStyle(color: Colors.black)),
          Radio<bool>(
            value: false,
            groupValue: groupValue,
            activeColor: Colors.red,
            onChanged: onChanged,
          ),
          const Text('Estimado', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}