import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/models/documents/document.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/string.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';

class UpdateAnswer extends StatefulWidget {
  final String answerId;
  final String questionId;
  final String title;
  final quill.Delta quilldata;
  UpdateAnswer({this.answerId, this.questionId, this.title, this.quilldata});
  @override
  UpdateAnswerState createState() => UpdateAnswerState();
}

class UpdateAnswerState extends State<UpdateAnswer> {
  var _answerController = quill.QuillController.basic();
  var validimages = ['png', 'jpg', 'jpeg'];
  List<File> _uploadFiles = [];
  bool sending = false;
  bool verifiedanswer = false;
  Auth authdata;

  validateImage(File givenfile) {
    final image = File(givenfile.path);
    final bytes = image.readAsBytesSync().lengthInBytes;
    final mb = bytes / (1024 * 1024);

    String name = image.path.split('/').last;
    String end = name.split('.').last;
    print(end);
    print(mb);
    if (mb > 2) {
      showCustomSnackBar(context, "File is to large!!");
      return false;
    }
    if (!validimages.contains(end)) {
      showCustomSnackBar(context, "Invalid file type");
      return false;
    }
    return true;
  }

  Future<String> imgepick(File givenfile) async {
    if (validateImage(givenfile)) {
      _uploadFiles.add(givenfile);
      return givenfile.path;
    } else {
      return placeholderImage;
    }
  }

  _updateAnswer() async {
    if (verifiedanswer) {
      showCustomSnackBar(context, "Answer already verified!!");
      return;
    }
    setState(() {
      sending = true;
    });
    print(_answerController.document.toDelta().toString());
    try {
      final url = API().getUrl(
          endpoint:
              'answer/updateAnswer/${authdata.userID}/${widget.questionId}/${widget.answerId}?mode="update"');
      final request = await http.put(url,
          body: json.encode(
            {
              'body': _answerController.document.toDelta(),
            },
          ),
          headers: {
            "Content-type": "Application/json",
            'Authorization': 'Bearer ${authdata.token}'
          });

      final resp = json.decode(request.body);
      final imagesend = API().getUrl(
          endpoint:
              'user/answerImagesUpload/${authdata.userID}/${widget.questionId}/${widget.answerId}?mode="update"');
      if (resp['error'] == null) {
        if (_uploadFiles.length != 0) {
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
            showCustomSnackBar(context, "Question Created Successfully");
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
        showCustomSnackBar(context, "Question Created Successfully!!");
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

  _deleteAnswer() async {
    if (verifiedanswer) {
      showCustomSnackBar(context, "Answer already verified!!");
      return;
    }
    final url = API().getUrl(
        endpoint:
            'answer/deleteAnswer/${authdata.userID}/${widget.questionId}/${widget.answerId}?mode="delete"');
    final response = await http.delete(url, headers: {
      "Content-type": "Application/json",
      'Authorization': 'Bearer ${authdata.token}'
    });
    final result = json.decode(response.body);
    Navigator.of(context).pop();
    showCustomSnackBar(context, result['message']);
  }

  void getAnswer() async {
    _answerController = quill.QuillController(
        selection: TextSelection.collapsed(offset: 1),
        document: Document.fromDelta(widget.quilldata));
    setState(() {});
  }

  void initState() {
    authdata = Provider.of<Auth>(context, listen: false);
    getAnswer();
    super.initState();
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
        title: Text("Update Answer"),
        backgroundColor: AppColors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                IconButton(
                    onPressed: _deleteAnswer,
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.violet,
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: quill.QuillToolbar.basic(
                showBackgroundColorButton: false,
                showColorButton: false,
                showHeaderStyle: false,
                showListCheck: false,
                showHorizontalRule: false,
                controller: _answerController,
                onImagePickCallback: imgepick,
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: quill.QuillEditor.basic(
                  padding: EdgeInsets.all(8),
                  controller: _answerController,
                  readOnly: false,
                  autoFocus: true),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  child: (!sending)
                      ? Text("Submit")
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  onPressed: () {
                    _updateAnswer();
                  },
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white, primary: AppColors.violet),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
