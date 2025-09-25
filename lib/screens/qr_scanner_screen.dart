import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../services/food_data_service.dart';
import '../models/food_item.dart';
import 'food_detail_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  bool hasPermission = false;
  String? scannedData;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        hasPermission = true;
      });
    } else {
      final result = await Permission.camera.request();
      setState(() {
        hasPermission = result.isGranted;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scannedData != scanData.code) {
        setState(() {
          scannedData = scanData.code;
        });
        _handleScannedData(scanData.code);
      }
    });
  }

  void _handleScannedData(String? data) {
    if (data == null) return;

    // Pause scanning
    controller?.pauseCamera();

    // Parse QR data - expected format: "oneno_food:province:food_name"
    if (data.startsWith('oneno_food:')) {
      final parts = data.split(':');
      if (parts.length >= 3) {
        final province = parts[1];
        final foodName = parts[2];
        _showFoodFromQR(province, foodName);
      } else {
        _showInvalidQRDialog();
      }
    } else {
      _showInvalidQRDialog();
    }
  }

  void _showFoodFromQR(String province, String foodName) {
    final provinceFood = FoodDataService.instance.getFoodsByProvince(province);
    if (provinceFood == null) {
      _showInvalidQRDialog();
      return;
    }

    // Find the food item
    FoodItem? foundFood;
    for (final food in provinceFood.getAllFoods()) {
      if (food.name.toLowerCase() == foodName.toLowerCase()) {
        foundFood = food;
        break;
      }
    }

    if (foundFood != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FoodDetailScreen(
            food: foundFood!,
            province: province,
          ),
        ),
      );
    } else {
      _showInvalidQRDialog();
    }
  }

  void _showInvalidQRDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: const Text('Mã QR không hợp lệ hoặc không thuộc ứng dụng Oneno Food.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller?.resumeCamera();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!hasPermission) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.scanQR),
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.cameraPermission,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.cameraPermissionMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    await openAppSettings();
                    _checkCameraPermission();
                  },
                  icon: const Icon(Icons.settings),
                  label: Text(l10n.openSettings),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQR),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleFlash,
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.red[50],
            child: Text(
              l10n.scanQRDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[700],
              ),
            ),
          ),
          
          // QR Scanner
          Expanded(
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.red[700]!,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 250,
                  ),
                ),
                
                // Scanning indicator
                if (scannedData == null)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 300), // Space for scanner area
                        SizedBox(height: 20),
                        Text(
                          'Đưa mã QR vào khung để quét',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Bottom controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFlash,
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Generate demo QR for testing
                    _handleScannedData('oneno_food:Hà Nội:Phở bò');
                  },
                  icon: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
