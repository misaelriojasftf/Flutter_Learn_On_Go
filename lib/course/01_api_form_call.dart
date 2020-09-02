import 'package:flutter/material.dart';
import '../models/index.dart';
import '../shared/api/apiService.dart';

class TextFieldFormApiExample extends StatefulWidget {
  TextFieldFormApiExample({Key key}) : super(key: key);

  @override
  _TextFieldFormApiExampleState createState() =>
      _TextFieldFormApiExampleState();
}

class _TextFieldFormApiExampleState extends State<TextFieldFormApiExample> {
  final controllerTitle = TextEditingController();
  final controllerBody = TextEditingController();

  /// TODO: USE YOUR OWN MODEL
  TodoModel todo = new TodoModel();
  void _sendData() {
    ApiService.newPost(todo.sendToPost());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('TITLE HERE'),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: controllerTitle,

                    /// TODO: USER YOUR OWN MODEL
                    onChanged: (v) => setState(() => todo.title = v),
                  ),
                ),
              ),
              Text('BODY HERE'),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: controllerBody,

                    /// TODO: USER YOUR OWN MODEL
                    onChanged: (v) => setState(() => todo.body = v),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: ApiService.getPosts,
                  builder: (BuildContext c, AsyncSnapshot<List<TodoModel>> v) {
                    if (v.hasData) {
                      return ListView.builder(
                        itemCount: v.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.red,
                                    child: SizedBox(
                                      height: 20,
                                      width: 50,
                                      child: Text(
                                        '${v.data[index].title}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Text('${v.data[index].body}'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
