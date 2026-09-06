import 'package:flutter/material.dart';

void main() {
  runApp(const FuelApp());
}

class FuelApp extends StatelessWidget {
  const FuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Consumption Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const FuelCalculatorPage(),
    );
  }
}

class FuelCalculatorPage extends StatefulWidget {
  const FuelCalculatorPage({super.key});

  @override
  State<FuelCalculatorPage> createState() => _FuelCalculatorPageState();
}

class _FuelCalculatorPageState extends State<FuelCalculatorPage> {
  final _distanceController = TextEditingController();
  final _fuelController = TextEditingController();

  double? _result;
  String? _errorMessage;

  @override
  void dispose() {
    _distanceController.dispose();
    _fuelController.dispose();
    super.dispose();
  }

  void _calculate() {
    final distanceText = _distanceController.text.trim();
    final fuelText = _fuelController.text.trim();

    final distance = double.tryParse(distanceText);
    final fuel = double.tryParse(fuelText);

    setState(() {
      if (distanceText.isEmpty || fuelText.isEmpty) {
        _errorMessage = 'Please fill in both fields.';
        _result = null;
      } else if (distance == null || fuel == null) {
        _errorMessage = 'Please enter valid numbers.';
        _result = null;
      } else if (distance <= 0) {
        _errorMessage = 'Distance must be greater than zero.';
        _result = null;
      } else if (fuel < 0) {
        _errorMessage = 'Fuel consumed cannot be negative.';
        _result = null;
      } else {
        _errorMessage = null;
        _result = (fuel / distance) * 100;
      }
    });
  }

  _EfficiencyRating? get _rating {
    if (_result == null) return null;
    if (_result! < 6) {
      return const _EfficiencyRating(
        label: 'Efficient',
        color: Colors.green,
        icon: Icons.eco,
      );
    } else if (_result! <= 10) {
      return const _EfficiencyRating(
        label: 'Average',
        color: Colors.orange,
        icon: Icons.speed,
      );
    } else {
      return const _EfficiencyRating(
        label: 'High consumption',
        color: Colors.red,
        icon: Icons.local_fire_department,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rating = _rating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Consumption Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Trip details',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _distanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Distance traveled (km)',
                          prefixIcon: Icon(Icons.route),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _fuelController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Fuel consumed (liters)',
                          prefixIcon: Icon(Icons.local_gas_station),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calculate'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_result != null)
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Average consumption',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_result!.toStringAsFixed(2)} L/100km',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (rating != null) ...[
                          const SizedBox(height: 16),
                          Chip(
                            avatar: Icon(
                              rating.icon,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: Text(
                              rating.label,
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: rating.color,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EfficiencyRating {
  final String label;
  final Color color;
  final IconData icon;

  const _EfficiencyRating({
    required this.label,
    required this.color,
    required this.icon,
  });
}
