import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;

// ImageUtils
class ImageUtils {
  // Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  static image_lib.Image? convertCameraImage(CameraImage cameraImage) {
    final imageFormatGroup = cameraImage.format.group;
    return switch (imageFormatGroup) {
      ImageFormatGroup.nv21 => convertNV21ToImage(cameraImage),
      ImageFormatGroup.yuv420 => convertYUV420ToImage(cameraImage),
      ImageFormatGroup.bgra8888 => convertBGRA8888ToImage(cameraImage),
      ImageFormatGroup.jpeg => convertJPEGToImage(cameraImage),
      _ => null,
    };
  }

  // Converts a [CameraImage] in BGRA888 format to [imageLib.Image] in RGB format
  static image_lib.Image convertBGRA8888ToImage(CameraImage cameraImage) {
    image_lib.Image img = image_lib.Image.fromBytes(
      width: cameraImage.planes[0].width!,
      height: cameraImage.planes[0].height!,
      bytes: cameraImage.planes[0].bytes.buffer,
      order: image_lib.ChannelOrder.bgra,
    );
    return img;
  }

  static image_lib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = image_lib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }
    return image;
  }

  static image_lib.Image convertJPEGToImage(CameraImage cameraImage) {
    // Extract the bytes from the CameraImage
    final bytes = cameraImage.planes[0].bytes;

    // Create a new Image instance from the JPEG bytes
    final image = image_lib.decodeImage(bytes);

    return image!;
  }

  static image_lib.Image convertNV21ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final nv21Bytes = cameraImage.planes[0].bytes;
    final image = image_lib.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int yValue = nv21Bytes[y * width + x];

        var color = image.getColor(yValue, yValue, yValue);
        image.setPixel(x, y, color);
      }
    }
    return image;
  }
}
