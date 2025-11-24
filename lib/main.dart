import 'package:flutter/material.dart';

void main() {
  runApp(const FuelCostApp());
}

class FuelCostApp extends StatelessWidget {
  const FuelCostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Cost Estimator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const FuelCalculatorScreen(),
    );
  }
}

class FuelCalculatorScreen extends StatefulWidget {
  const FuelCalculatorScreen({super.key});

  @override
  State<FuelCalculatorScreen> createState() => _FuelCalculatorScreenState();
}

class _FuelCalculatorScreenState extends State<FuelCalculatorScreen> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _consumptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _resultText = 'Enter values and tap Calculate.';

  void _calculateFuelCost() {
    final distanceStr = _distanceController.text.trim();
    final consumptionStr = _consumptionController.text.trim();
    final priceStr = _priceController.text.trim();

    if (distanceStr.isEmpty || consumptionStr.isEmpty || priceStr.isEmpty) {
      setState(() {
        _resultText = 'Please fill in all fields.';
      });
      return;
    }

    try {
      final double distanceKm = double.parse(distanceStr);
      final double consumptionPer100 = double.parse(consumptionStr);
      final double pricePerLiter = double.parse(priceStr);

      if (distanceKm <= 0 || consumptionPer100 <= 0 || pricePerLiter <= 0) {
        setState(() {
          _resultText = 'All values must be greater than zero.';
        });
        return;
      }

      final double litersNeeded = distanceKm * (consumptionPer100 / 100.0);
      final double totalCost = litersNeeded * pricePerLiter;

      setState(() {
        _resultText =
        'Trip distance: ${distanceKm.toStringAsFixed(2)} km\n'
            'Fuel needed: ${litersNeeded.toStringAsFixed(2)} L\n'
            'Total cost: ${totalCost.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _resultText = 'Invalid number format. Please enter valid numbers.';
      });
    }
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _consumptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ⭐ Background color added here
      backgroundColor: Colors.green.shade50,

      appBar: AppBar(
        title: const Text('Fuel Cost Estimator'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate how much your trip will cost based on distance, fuel consumption, and fuel price.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            const Text('Distance (km)'),
            const SizedBox(height: 4),
            TextField(
              controller: _distanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'e.g. 120',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Fuel consumption (L / 100 km)'),
            const SizedBox(height: 4),
            TextField(
              controller: _consumptionController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'e.g. 7.5',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Fuel price per liter'),
            const SizedBox(height: 4),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'e.g. 35,000',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateFuelCost,
                child: const Text('Calculate'),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // ⭐ Nice clean result box
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                _resultText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
