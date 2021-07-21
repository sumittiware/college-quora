import 'dart:convert'; // access to jsonEncode()
import 'dart:io';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:quora/Configurations/apiConfig.dart';
import 'package:quora/Configurations/questionData.dart';
import 'package:quora/Configurations/string.dart';
import 'package:quora/Providers/filter.dart';
import 'package:quora/Providers/userProvider.dart';
import 'package:quora/Services/authservices.dart';
import 'package:quora/Views/Common/showmessage.dart';
import 'package:quora/Views/EditorScreen/Widgets/dialog.dart';
import 'package:quora/main.dart';
import 'package:quora/styles/colors.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  final _titlecontroller = TextEditingController();
  QuillController _controller = QuillController.basic();
  Auth authdata;
  bool sending = false;
  var validimages = ['png', 'jpg', 'jpeg'];
  List<File> _uploadFiles = [];

  validateImage(File givenfile) {
    final image = File(givenfile.path);
    final bytes = image.readAsBytesSync().lengthInBytes;
    final mb = bytes / (1024 * 1024);
    String name = image.path.split('/').last;
    String end = name.split('.').last;
    print(end);
    print(mb);
    if (mb > 1) {
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
    print(Provider.of<Filter>(context, listen: false).tags.toString());
    if (validateImage(givenfile)) {
      _uploadFiles.add(givenfile);
      return givenfile.path;
    } else {
      return placeholderImage;
    }
  }

  void initState() {
    authdata = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  _selectTags(BuildContext ctx, Size size) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return MyDialog();
        });
  }

  _submitQuestion() async {
    final filters = Provider.of<Filter>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).appuser;
    connectToServer();
    socket.emit("addTag", {
      "username": user.username ?? " ",
      "name": user.name,
      "profileImage": user.imageURl ?? null,
      "tags": filters.createdTags
    });
    socket.disconnect();

    setState(() {
      sending = true;
    });

    try {
      final url =
          API().getUrl(endpoint: 'question/createQuestion/${authdata.userID}');
      final request = await http.post(url,
          body: json.encode(
            {
              'title': _titlecontroller.text,
              'body': _controller.document.toDelta(),
              'tags': filters.tags
            },
          ),
          headers: {
            "Content-type": "Application/json",
            'Authorization': 'Bearer ${authdata.token}'
          });
      filters.clearTags();
      final resp = json.decode(request.body);
      print(resp.toString());
      if (resp['error'] == null) {
        final id = resp['questionId'];
        print("point1");
        final imagesend = API().getUrl(
            endpoint:
                'question/questionImagesUpload/${authdata.userID}/$id?mode="create"');

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
            writetoFile(id);
            showCustomSnackBar(context, "Question Created Successfully");
            _uploadFiles.clear();
            return respimg['questionId'].toString();
          } else {
            setState(() {
              sending = false;
            });
            showCustomSnackBar(context, respimg['message']);
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
      print(e.toString());
      showCustomSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
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
                      padding: EdgeInsets.all(8),
                      autoFocus: false,
                      controller: _controller,
                      readOnly: false // true for view only mode
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
                      ? (Provider.of<Filter>(context, listen: false)
                                  .tags
                                  .length ==
                              0)
                          ? Text("Next")
                          : Text("Submit")
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  onPressed: () {
                    (!sending)
                        ? (Provider.of<Filter>(context, listen: false)
                                    .tags
                                    .length ==
                                0)
                            ? _selectTags(context, _deviceSize)
                            : _submitQuestion()
                        : null;
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
