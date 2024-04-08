import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadAndSaveFile(String fileUrl, String fileName) async {
  try {
    // Tạo thư mục để lưu trữ tập tin nếu chưa tồn tại
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    print(filePath);
    // Kiểm tra xem tập tin đã tồn tại chưa
    if (File(filePath).existsSync()) {
      print('File already exists');
      return filePath;
    }

    // Thực hiện yêu cầu HTTP để tải xuống file
    final response = await http.get(Uri.parse(fileUrl));

    // Kiểm tra xem yêu cầu có thành công không
    if (response.statusCode == 200) {
      // Lưu tập tin tải xuống vào đường dẫn cục bộ
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('File downloaded and saved successfully');
      return filePath;
    } else {
      print('Failed to download file. Status code: ${response.statusCode}');
      return "";
    }
    
  } catch (e) {
    print('Error: $e');
    return "";
  }
}

void main() async {
  String fileUrl = 'https://aiservices-bucket.s3.amazonaws.com/test/marian.tflite';
  String fileName = 'marian.tflite';

  await downloadAndSaveFile(fileUrl, fileName);

}
