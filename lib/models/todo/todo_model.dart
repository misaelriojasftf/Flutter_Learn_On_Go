/// TODO: USE YOUR OWN MODEL

class TodoModel {
  TodoModel({
    this.id,
    this.title = "My Test",
    this.body = "My Body",
    this.userId = 1,
  });

  int id;
  String title;
  String body;
  int userId;

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        userId: json["userId"],
      );

  static List<TodoModel> fromList(List list) {
    List<TodoModel> todoList = [];
    if (list is List)
      list.forEach((json) => todoList.add(TodoModel.fromJson(json)));
    todoList = [todoList.first, todoList.last];
    return todoList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "userId": userId,
      };

  Map<String, dynamic> sendToPost() => {
        "title": title,
        "body": body,
        "userId": userId,
      };
}
