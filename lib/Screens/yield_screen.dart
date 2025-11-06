import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_screen.dart';

class CropYieldForm extends StatefulWidget {
  const CropYieldForm({Key? key}) : super(key: key);

  @override
  State<CropYieldForm> createState() => _CropYieldFormState();
}

class _CropYieldFormState extends State<CropYieldForm> {
  final ServiceScreen _service = ServiceScreen();

  final _cropTypeController = TextEditingController();
  final _diseaseClassController = TextEditingController();
  final _healthyAreaController = TextEditingController();
  final _weedAreaController = TextEditingController();
  final _soilAreaController = TextEditingController();
  final _ndviController = TextEditingController();
  final _historicalYieldController = TextEditingController();

  XFile? _plantImage;
  XFile? _maskedImage;

  String? _weather;
  final List<String> _weatherConditions = ['Moderate', 'Warm', 'Cold'];

  String _predictedYield = '';
  String _uncertaintyRange = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSharedData();
  }

  Future<void> _loadSharedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('cropType')) {
        _cropTypeController.text = prefs.getString('cropType') ?? '';
      }
      if (prefs.containsKey('disease')) {
        _diseaseClassController.text = prefs.getString('disease') ?? '';
      }

      if (prefs.containsKey('healthyArea')) {
        _healthyAreaController.text = (prefs.getDouble('healthyArea') ?? 0)
            .toStringAsFixed(1);
      }
      if (prefs.containsKey('weedArea')) {
        _weedAreaController.text = (prefs.getDouble('weedArea') ?? 0)
            .toStringAsFixed(1);
      }
      if (prefs.containsKey('soilArea')) {
        _soilAreaController.text = (prefs.getDouble('soilArea') ?? 0)
            .toStringAsFixed(1);
      }
    });
  }

  Future<void> _handleSubmit() async {
    // Basic validation to ensure required fields are filled
    if (_cropTypeController.text.isEmpty ||
        _diseaseClassController.text.isEmpty ||
        _healthyAreaController.text.isEmpty ||
        _weedAreaController.text.isEmpty ||
        _soilAreaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please ensure all analysis data is loaded.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading indicator (optional but recommended)
    setState(() {
      _predictedYield = 'Calculating...';
      _uncertaintyRange = '';
    });

    try {
      // Parse string values to double for the API
      final double healthyArea = double.parse(_healthyAreaController.text);
      final double weedArea = double.parse(_weedAreaController.text);
      final double soilArea = double.parse(_soilAreaController.text);

      // Call the API
      final response = await _service.yieldPrediction(
        cropType: _cropTypeController.text,
        diseaseClass: _diseaseClassController.text,
        healthyArea: healthyArea,
        weedArea: weedArea,
        soilArea: soilArea,
      );

      if (response['success'] == true) {
        final data = response['data'];
        setState(() {
          _predictedYield = '${data['predicted_yield']} kg/hectare';
          _uncertaintyRange = '±${data['uncertainty']} kg/hectare';
        });
      } else {
        setState(() {
          _predictedYield = 'Error';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _predictedYield = 'Error';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cropTypeController.dispose();
    _diseaseClassController.dispose();
    _healthyAreaController.dispose();
    _weedAreaController.dispose();
    _soilAreaController.dispose();
    _ndviController.dispose();
    _historicalYieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.green[700]!;
    final Color secondaryColor = Colors.green[800]!;
    final Color lightBorder = Colors.green[200]!;
    final Color lightBg = Colors.grey[50]!;

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryColor),
      filled: true,
      fillColor: lightBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryColor),
      ),
    );

    InputDecoration readOnlyDecoration(String label) =>
        inputDecoration(label).copyWith(fillColor: Colors.grey[100]);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  _buildFormCard(
                    title: "Disease Information",
                    children: [
                      TextFormField(
                        controller: _cropTypeController,
                        readOnly: true,
                        decoration: readOnlyDecoration('Crop Type'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _diseaseClassController,
                        readOnly: true,
                        decoration: readOnlyDecoration('Disease Class'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Area Analysis Section
                  _buildFormCard(
                    title: "Area Analysis",
                    children: [
                      TextFormField(
                        controller: _healthyAreaController,
                        readOnly: true,
                        decoration: readOnlyDecoration('Healthy Area (%)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weedAreaController,
                        readOnly: true,
                        decoration: readOnlyDecoration('Weed Area (%)'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _soilAreaController,
                        readOnly: true,
                        decoration: readOnlyDecoration('Soil Area (%)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Environmental Data Section
                  _buildFormCard(
                    title: "Environmental Data",
                    children: [
                      TextFormField(
                        controller: _ndviController,
                        decoration: inputDecoration(
                          'NDVI (Normalized Difference Vegetation Index)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildWeatherDropdown(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _historicalYieldController,
                        decoration: inputDecoration(
                          'Historical Yield (kg/hectare)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Prediction Results Section
                  if (_predictedYield.isNotEmpty ||
                      _uncertaintyRange.isNotEmpty)
                    _buildFormCard(
                      title: "Prediction Results",
                      children: [
                        TextFormField(
                          controller: TextEditingController(
                            text: _predictedYield,
                          ),
                          readOnly: true,
                          decoration: readOnlyDecoration('Predicted Yield'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                            text: _uncertaintyRange,
                          ),
                          readOnly: true,
                          decoration: readOnlyDecoration('Uncertainty Range'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: _handleSubmit,
                    icon: const Icon(LucideIcons.leaf, size: 20),
                    label: const Text('Predict Yield'),
                    style:
                        ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 0,
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          shadowColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header widget
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[600]!, Colors.teal[600]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.leaf, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text(
                'Crop Yield Predictor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'AI-powered agricultural yield prediction system',
            style: TextStyle(fontSize: 14, color: Colors.green[50]),
          ),
        ],
      ),
    );
  }

  // Card widget
  Widget _buildFormCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shadowColor: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green[100]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDropdown() {
    return DropdownButtonFormField2<String>(
      value: _weather,
      items: _weatherConditions
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _weather = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Weather Condition',
        labelStyle: TextStyle(color: Colors.green[800]),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.green[700]!),
        ),
      ),
      hint: const Text(
        'Select weather condition',
        style: TextStyle(fontSize: 14),
      ),
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
