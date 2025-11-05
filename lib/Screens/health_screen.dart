import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'service_screen.dart';

class CropHealthAnalysis extends StatefulWidget {
  const CropHealthAnalysis({Key? key}) : super(key: key);

  @override
  State<CropHealthAnalysis> createState() => _CropHealthAnalysisState();
}

class _CropHealthAnalysisState extends State<CropHealthAnalysis> {
  final ServiceScreen _service = ServiceScreen();
  XFile? _plantImage;
  XFile? _maskedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _results;

  final ImagePicker _picker = ImagePicker();

  Future<void> _handleImageUpload(
    ImageSource source,
    void Function(XFile?) setImage,
  ) async {
    final XFile? file = await _picker.pickImage(source: source);
    if (file != null) {
      setState(() {
        setImage(file);
      });
    }
  }

  Future<void> _handleAnalyze() async {
    if (_plantImage == null || _maskedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload both the plant and mask images.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _results = null;
    });

    // await Future.delayed(const Duration(seconds: 2));
    try {
      File plantFile = File(_plantImage!.path);
      File maskFile = File(_maskedImage!.path);
      Map<dynamic, dynamic> response = await _service.fieldsegment(
        plant_image: plantFile,
        mask_image: maskFile,
      );
      if (response['success'] == true) {
        final data = response['data'];
        double healthy = (data['healthy_area'] as num).toDouble();
        double weed = (data['weed_area'] as num).toDouble();
        double soil = (data['soil_area'] as num).toDouble();
        double totalVegetation = healthy + weed;
        double overallHealth = (totalVegetation > 0)
            ? (healthy / totalVegetation) * 100
            : 0;

        String status;
        if (overallHealth >= 80) {
          status = "Good";
        } else if (overallHealth >= 60) {
          status = "Moderate";
        } else {
          status = "Poor";
        }
        setState(() {
          _results = {
            "healthyArea": healthy,
            "weedArea": weed,
            "soilArea": soil,
            "overallHealth": overallHealth,
            "status": status,
          };
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API Error: ${response['message']}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildUploadSection(),

                  const SizedBox(height: 16),

                  if (_results != null)
                    _buildResultsSection()
                  else
                    _buildInfoCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[800]!, Colors.green[600]!],
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.leaf, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Crop Health Analysis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Advanced segmentation & health metrics',
                style: TextStyle(fontSize: 14, color: Colors.green[100]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
      elevation: 2,
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
            _buildSectionHeader('Image Uploads'),
            const SizedBox(height: 16),
            _buildImageUploader(
              title: 'Original Plant Image',
              icon: LucideIcons.upload,
              file: _plantImage,
              onPressed: () => _handleImageUpload(
                ImageSource.gallery,
                (file) => _plantImage = file,
              ),
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildImageUploader(
              title: 'Masked RGB Image',
              icon: LucideIcons.image,
              file: _maskedImage,
              onPressed: () => _handleImageUpload(
                ImageSource.gallery,
                (file) => _maskedImage = file,
              ),
              color: Colors.teal,
            ),
            if (_plantImage != null || _maskedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isAnalyzing ? null : _handleAnalyze,
                  icon: _isAnalyzing
                      ? Container(
                          width: 20,
                          height: 20,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(LucideIcons.activity, size: 18),
                  label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze Health'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader({
    required String title,
    required IconData icon,
    required XFile? file,
    required MaterialColor color,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            minimumSize: const Size(double.infinity, 44),
            side: BorderSide(color: color[300]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(file != null ? 'Change Image' : 'Upload Image'),
        ),
        if (file != null)
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 192,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color[200]!, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(File(file.path), fit: BoxFit.cover),
          ),
      ],
    );
  }

  Widget _buildResultsSection() {
    return Column(
      children: [
        _buildOverallHealthCard(),
        const SizedBox(height: 16),
        _buildSegmentationCard(),
      ],
    );
  }

  Widget _buildOverallHealthCard() {
    return Card(
      elevation: 3,
      shadowColor: Colors.green[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green[200]!),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green[50]!.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Overall Health Score'),
                  Chip(
                    label: Text(
                      _results!['status'],
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    backgroundColor: Colors.green[100],
                    side: BorderSide(color: Colors.green[300]!),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CircularPercentIndicator(
                radius: 64.0,
                lineWidth: 8.0,
                percent: _results!['overallHealth'] / 100,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_results!['overallHealth'].toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Health',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                progressColor: Colors.green[500],
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentationCard() {
    return Card(
      elevation: 2,
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
            _buildSectionHeader('Area Segmentation'),
            const SizedBox(height: 20),
            _buildProgressRow(
              title: 'Healthy Area',
              value: _results!['healthyArea'],
              color: Colors.green[500]!,
            ),
            const SizedBox(height: 16),
            _buildProgressRow(
              title: 'Weed Area',
              value: _results!['weedArea'],
              color: Colors.yellow[500]!,
            ),
            const SizedBox(height: 16),
            _buildProgressRow(
              title: 'Soil Area',
              value: _results!['soilArea'],
              color: Colors.brown[400]!,
            ),
            const SizedBox(height: 24),
            const Text(
              'Distribution Overview',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Flexible(
                    flex: _results!['healthyArea'].round(),
                    child: Container(color: Colors.green[500], height: 16),
                  ),
                  Flexible(
                    flex: _results!['weedArea'].round(),
                    child: Container(color: Colors.yellow[500], height: 16),
                  ),
                  Flexible(
                    flex: _results!['soilArea'].round(),
                    child: Container(color: Colors.brown[400], height: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow({
    required String title,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            Text(
              '${value.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.green[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green[200]!),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.teal[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Health Analysis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Our AI-powered segmentation model analyzes your crop images to identify and quantify:',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildInfoListItem(
                'Healthy vegetation:',
                'Active, photosynthesizing plant matter',
                Colors.green[600]!,
              ),
              const SizedBox(height: 8),
              _buildInfoListItem(
                'Weed coverage:',
                'Unwanted plant growth competing for resources',
                Colors.green[600]!,
              ),
              const SizedBox(height: 8),
              _buildInfoListItem(
                'Exposed soil:',
                'Areas requiring attention or replanting',
                Colors.green[600]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoListItem(String title, String subtitle, Color dotColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Icon(Icons.circle, size: 8, color: dotColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$title ',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
