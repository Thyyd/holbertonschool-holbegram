import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageMethods {
  final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/jckazhb3/image/upload";
  final String cloudinaryPreset = "holbegram_unsigned";

  Future<String> uploadImageToStorage(
      bool isPost,
      String childName,
      Uint8List file, {
      String? publicId,
  }) async {
    String uniqueId = publicId ?? const Uuid().v1();
    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;

    // Si isPost est false, on n'ajoute pas ce champ → Cloudinary génère un ID aléatoire lui-même
    if (isPost) {
      request.fields['public_id'] = uniqueId;
    }

    var multipartFile = http.MultipartFile.fromBytes('file', file, filename: '$uniqueId.jpg');
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.toBytes();
      var jsonResponse = jsonDecode(String.fromCharCodes(responseData));
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary');
    }
  }
}
