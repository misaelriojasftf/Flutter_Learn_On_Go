import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class MultiFilePicker extends StatefulWidget {
  @override
  _MultiFilePickerState createState() => _MultiFilePickerState();
}

class _MultiFilePickerState extends State<MultiFilePicker> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<PlatformFile> _paths;
  bool _loadingPath = false;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    _paths = await PickerUtils.getFiles;
    if (!mounted) return;
    setState(() => _loadingPath = false);
  }

  void _clearCachedFiles() {
    PickerUtils.clearCacheFiles.then((result) {
      if (result) setState(() => _paths = []);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _openFileExplorer,
                      child: Text("Open Folder"),
                    ),
                    RaisedButton(
                      onPressed: _clearCachedFiles,
                      child: Text("Clean Picked Files"),
                    ),
                    if (_paths is List && _paths.isNotEmpty)
                      RaisedButton(
                        onPressed: () => DioClient.sendFile(_paths),
                        child: Text("Send Files"),
                      ),
                  ],
                ),
              ),
              _loadingPath
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                  : _buildFiles(_paths),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildFiles(List<PlatformFile> paths) {
    if (paths is! List<PlatformFile> || paths.isEmpty) return Container();

    return Container(
      padding: const EdgeInsets.only(bottom: 30.0),
      height: MediaQuery.of(context).size.height * 0.50,
      child: Scrollbar(
          child: ListView.separated(
        itemCount: _paths.length,
        separatorBuilder: (c, v) => const Divider(),
        itemBuilder: (c, int index) {
          String fileName = _paths[index].name ?? "File doesn't have name";
          String name = 'File $index: $fileName';
          var path = _paths[index].path.toString();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(
                  name,
                ),
                subtitle: Text(path),
              ),
            ),
          );
        },
      )),
    );
  }
}

class PickerUtils {
  /// [TODO: YOU CAN ADD THE ELEMENTS YOU WANT TO ALLOW.]
  /// [THIS IS PDF]
  static List<String> allowedExtensions = ['pdf'];

  static Future<List<PlatformFile>> get getFiles async {
    try {
      return (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: PickerUtils.allowedExtensions,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("PLATFROM EXCEPTION: $e");
    } catch (err) {
      print("Error while catching the files: $err");
    }
    return [];
  }

  static Future<bool> get clearCacheFiles async =>
      await FilePicker.platform.clearTemporaryFiles();
}

class DioClient {
  static Future sendFile(List<PlatformFile> paths) async {
    FormData formdata = FormData();
    for (PlatformFile file in paths)
      formdata.files.addAll(
        [MapEntry("PDF_FILES", await MultipartFile.fromFile(file.path))],
      );

    /// [TODO: CHANGE WITH YOUR BASE URL]L
    Dio dio = new Dio()..options.baseUrl = "http://serverURL:port";
    dio.post(
      /// [TODO: CHANGE WITH YOUR ENDPOINT URL]
      "/uploadFile",
      data: formdata,
      onSendProgress: (int sent, int total) {
        print("$sent $total");
      },
    ).then((response) {
      print(response);
    }).catchError((error) => print(error));
  }
}
