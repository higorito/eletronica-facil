import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;

  // late CameraImage cameraImage;
  var cameraCount = 0;

  // var x, y, w, h = 1.0;

  var label = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized.value = true;
      update();
    } else {
      print('negada');
    }
  }

  initTflite() async {
    await Tflite.loadModel(
      model: 'assets/modelos/model.tflite',
      labels: 'assets/modelos/labels.txt',
      isAsset: true,
      numThreads: 2,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      rotation: 90,
      threshold: 0.5,
    );

    if (detector != null) {
      print('isso é $detector');
      var detectouObj = detector[0];
      var confidence = detectouObj['confidence'] * 100;
      print("Confiança: $confidence");
      if (confidence > 80) {
        // x = detectouObj['rect']['x'];
        // y = detectouObj['rect']['y'];
        // w = detectouObj['rect']['w'];
        // h = detectouObj['rect']['h'];
        label = detectouObj['label'];

        label = label.substring(1);
      }
      update();
    }
  }
}
