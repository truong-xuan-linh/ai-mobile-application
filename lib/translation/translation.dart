import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
//https://aiservices-bucket.s3.amazonaws.com/test/marian.tflite


class MyTranslator {
  late Interpreter _interpreter;
  late IsolateInterpreter isolateInterpreter;
  late Map<String, dynamic> _vocab;
  // late String _modelPath ;
  // final String _modelPath = "assets/marian.tflite";
  // final String _vocabPath = "assets/vocab.json";

  Future create(String source, String target) async {
    // try {
    //   _interpreter.close();
    //   isolateInterpreter.close();
    // } catch (error) {
    //   //
    // }
    
    // Load vocabulary only once in the constructor
    await _loadVocab(source, target);
    // Load interpreter only once in the constructor
    await _loadInterpreter(source, target);

    return this;
  }

  createWithoutAsync(String source, String target) {
    // Load vocabulary only once in the constructor
    _loadVocab(source, target);
    // Load interpreter only once in the constructor
    _loadInterpreter(source, target);
    return this;
  }

  
  Future<void> _loadVocab(String source, String target) async {
    String jsonString = await rootBundle.loadString('assets/vocab-$source-$target.json');
    _vocab = json.decode(jsonString);
  }

  Future<void> _loadInterpreter(String source, String target) async {
    String fileUrl = 'https://aiservices-bucket.s3.amazonaws.com/test/marian-$source-$target.tflite';
    String fileName = 'marian-$source-$target.tflite';
    await downloadAndSaveFile(fileUrl, fileName);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/marian-$source-$target.tflite';
    
    File dataFile = File(filePath);

    _interpreter = Interpreter.fromFile(dataFile);

    // String filePath = 'assets/marian-$source-$target.tflite';

    // _interpreter = await Interpreter.fromAsset(filePath);
    isolateInterpreter =
        await IsolateInterpreter.create(address: _interpreter.address);
  }
  
  List<int> _localTokenizer(String text, String lang) {
    // Use _vocab directly instead of loading it in the function
    text = text.replaceAll('\n', "");
    text = addSpace(text);
    String specialChars = "!@#\$%^&*()-_=+[]{}|;:'\",.<>/?";
    int unkToken = _vocab['<unk>'];
    List<int> inputIds = List.filled(256, _vocab['<pad>']);
    int idx = 0;
    String splitStr = " ";
  
    for (String key in text.split(splitStr)) {
      if (!specialChars.contains(key)) {
        key = '▁$key';
      }
      
      if (_vocab.containsKey(key)) {
        inputIds[idx] = _vocab[key];
      } else {
        inputIds[idx] = unkToken;
      }
      idx++;
    }

    inputIds[idx] = 0;

    return inputIds;
  }

  String addSpace(String text) {
    String specialChars = "!@#\$%^&*()-_=+[]{}|;:'\",.<>/?";
    
    String result = "";
    for (int i=0; i< text.length;i++) {
      String char = text[i];
      if (specialChars.contains(char)) {
        result = '$result $char';
      }
      else {
        result = '$result$char';
      }
    }
    return result;
  }

  String _localDecode(List<int> ids, String lang) {
    String result = "";

    Map<int, String> vocabReverse = {};

    // Duyệt qua mỗi entry trong từ điển _vocab
    _vocab.forEach((key, value) {
      // Đảo ngược key và value và thêm vào từ điển mới
      vocabReverse[value] = key;
    });

    for (int id in ids) {
      if (![0, 1].contains(id)) {
        if(vocabReverse[id]!="<pad>")
        {
          result += vocabReverse[id]!;
        }
      }
    }

    result = result.replaceAll("▁", " ");
    result = result.trim();
    return result;
  }

  Future<String> translation(String text, String source, String target) async {
    List<int> inputIds = _localTokenizer(text, source);
    var output = List.filled(1 * 224, 0).reshape([1, 224]);

    var input = inputIds.reshape([1, 256]);

    await isolateInterpreter.run(input, output);

    String result = _localDecode(List<int>.from(output[0]), target);

    return result;
  }

  Future<void> downloadAndSaveFile(String fileUrl, String fileName) async {
    try {
      // Tạo thư mục để lưu trữ tập tin nếu chưa tồn tại
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      if (await File(filePath).exists()) {
        print('$filePath already exists');
        return;
      }

      // Thực hiện yêu cầu HTTP để tải xuống file
      final response = await http.get(Uri.parse(fileUrl));

      // Kiểm tra xem yêu cầu có thành công không
      if (response.statusCode == 200) {
        // Lưu tập tin tải xuống vào đường dẫn cục bộ
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        print('$filePath downloaded and saved successfully');
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void dispose() {
    try {
      _interpreter.close();
      isolateInterpreter.close();
    } catch (error) {
      //
    }
  }
}
