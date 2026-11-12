import 'package:flutter/material.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color fieldColor = Color(0xFF1C1C1E);
  static const Color blue = Color(0xFF2979FF);
  static const Color darkBlue = Color(0xFF0D47A1);

  final heightController = TextEditingController();
  final weightController = TextEditingController();
  double? bmi;
  String category = '';
  Color categoryColor = Colors.grey;

  void calculateBmi() {
    final heightCm = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if (heightCm == null || weight == null || heightCm <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid height and weight')),
      );
      return;
    }

    final height = heightCm / 100;
    final result = weight / (height * height);

    setState(() {
      bmi = result;

      if (result < 18.5) {
        category = 'Underweight';
        categoryColor = Colors.lightBlueAccent;
      } else if (result < 25) {
        category = 'Normal';
        categoryColor = Colors.greenAccent;
      } else if (result < 30) {
        category = 'Overweight';
        categoryColor = Colors.orangeAccent;
      } else {
        category = 'Obese';
        categoryColor = Colors.redAccent;
      }
    });
  }

  void reset() {
    heightController.clear();
    weightController.clear();
    setState(() {
      bmi = null;
    });
  }

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: blue),
      filled: true,
      fillColor: fieldColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: blue, width: 2),
      ),
    );
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: blue,
                    decoration: fieldDecoration('Height (cm)', Icons.height),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: blue,
                    decoration:
                        fieldDecoration('Weight (kg)', Icons.monitor_weight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: calculateBmi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Calculate',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                  color: blue,
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 32),

            if (bmi != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: categoryColor, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      bmi!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: categoryColor,
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(fontSize: 24, color: categoryColor),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}