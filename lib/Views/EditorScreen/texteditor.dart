import 'dart:convert'; // access to jsonEncode()
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final _titlecontroller = TextEditingController();
  QuillController _controller = QuillController.basic();
  Auth authdata;
  bool sending = false;
  var valid_images = ['png', 'jpg', 'jpeg'];
  List<File> _uploadFiles = [];

  // File _userImageFile;
  validateImage(File givenfile) {
    final image = File(givenfile.path);
    final bytes = image.readAsBytesSync().lengthInBytes;
    print(bytes);
    final mb = bytes / (1024 * 1024);
    String name = image.path.split('/').last;
    String end = name.split('.').last;
    print(end);
    print(mb);
    if (mb > 2) {
      showCustomSnackBar(context, "File is to large!!");
      return false;
    }
    if (!valid_images.contains(end)) {
      showCustomSnackBar(context, "Invalid file type");
      return false;
    }
    return true;
  }

  Future<String> imgepick(File givenfile) async {
    // final byteData = await rootBundle.load('assets/images/user.jpg');
    // final file =
    //     File('${(await getTemporaryDirectory()).path}/images/user.jpg');
    // await file.writeAsBytes(byteData.buffer
    //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    if (validateImage(givenfile)) {
      _uploadFiles.add(givenfile);
      return givenfile.path;
    } else {
      return "https://firebasestorage.googleapis.com/v0/b/news-app-bowe.appspot.com/o/source_image%2FIMG-20210531-WA0009.jpg?alt=media&token=c6325d45-9c0c-4b5f-a497-a8f9fa677b65";
    }

    // return "";
    // try {

    //   final res = await request.send();
    //   var response = await http.Response.fromStream(res);
    //   final resp = json.decode(response.body);
    //   print(resp);
    //   return resp['url'];
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  void initState() {
    authdata = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  _submitQuestion() async {
    setState(() {
      sending = true;
    });
    print(_controller.document.toDelta().toString());
    try {
      final url =
          API().getUrl(endpoint: 'user/createQuestion/${authdata.userID}');
      final request = await http.post(url,
          body: json.encode(
            {
              'title': _titlecontroller.text,
              'body': _controller.document.toDelta(),
              'tags': []
            },
          ),
          headers: {
            "Content-type": "Application/json",
            'Authorization': 'Bearer ${authdata.token}'
          });

      // request.fields['title'] = _titlecontroller.text;
      // request.fields['body'] = _controller.document.toDelta().toString();

      // request.headers.addAll({
      //   "Content-type": "multipart/form-data",
      //   'Authorization': 'Bearer ${authdata.token}'
      // });
      // final res = await request.send();
      // var response = await http.Response.fromStream(res);

      final resp = json.decode(request.body);
      print(resp.toString());
      final id = resp['questionId'];
      final imagesend = API().getUrl(endpoint: 'user/questionImagesUplaod/$id');
      if (resp['error'] == null) {
        if (_uploadFiles.length != 0) {
          print(authdata.token);
          final imagereq = http.MultipartRequest('Post', imagesend);
          for (int i = 0; i < _uploadFiles.length; i++) {
            String filename = _uploadFiles[i].path ?? null;
            final mimeTypeData =
                lookupMimeType(filename, headerBytes: [0xFF, 0xD8]).split('/');
            imagereq.files.add(await http.MultipartFile.fromPath(
                'image', filename,
                contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
          }
          imagereq.headers.addAll({
            "Content-type": "multipart/form-data",
            "Authorization": 'Bearer ${authdata.token}'
          });
          final res = await imagereq.send();
          var response = await http.Response.fromStream(res);
          final respimg = json.decode(response.body);
          print(respimg.toString());
          if (respimg['error'] == null) {
            setState(() {
              sending = false;
            });
            showCustomSnackBar(context, resp['questionId'].toString());
            return respimg['questionId'].toString();
          } else {
            setState(() {
              sending = false;
            });
            showCustomSnackBar(context, resp['message']);
            throw respimg['message'];
          }
        }
        setState(() {
          sending = false;
        });
        showCustomSnackBar(context, resp['message']);
        return resp['message'];
      } else {
        setState(() {
          sending = false;
        });
        showCustomSnackBar(context, resp['message']);
        throw resp['message'];
      }
    } catch (e) {
      setState(() {
        sending = false;
      });
      showCustomSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Ask Question"),
          backgroundColor: AppColors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titlecontroller,
                maxLines: 2,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.violet)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.orange)),
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: QuillToolbar.basic(
                  showBackgroundColorButton: false,
                  showColorButton: false,
                  showHeaderStyle: false,
                  showListCheck: false,
                  showHorizontalRule: false,
                  controller: _controller,
                  onImagePickCallback: imgepick,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: QuillEditor.basic(
                    autoFocus: true,
                    controller: _controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  child: (!sending)
                      ? Text("Submit")
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  onPressed: () {
                    _submitQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, primary: AppColors.violet),
                ),
              )
            ],
          ),
        ));
  }
}
