import 'package:easyorder_mobile/order_data.dart';
import 'package:easyorder_mobile/user_data.dart';

class Task {
  int id;
  dynamic orderId;
  int status;
  int type;
  String address;
  String guige;
  int makeCount;
  int allCount;
  dynamic createTime;
  dynamic updateTime;
  bool deletedFlag;
  List<SubTask>? subTasks;

  Task({
    required this.id,
    this.orderId,
    required this.status,
    required this.type,
    required this.address,
    required this.guige,
    required this.makeCount,
    required this.allCount,
    required this.createTime,
    required this.updateTime,
    required this.deletedFlag,
    this.subTasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      orderId: json['orderId'],
      status: json['status'],
      type: json['type'],
      address: json['address'],
      guige: json['guige'],
      makeCount: json['makeCount'],
      allCount: json['allCount'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      deletedFlag: json['deletedFlag'],
      subTasks: json['subTasks'] != null
          ? List<SubTask>.from(
              json['subTasks'].map((subTask) => SubTask.fromJson(subTask)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'status': status,
      'type': type,
      'address': address,
      'guige': guige,
      'makeCount': makeCount,
      'allCount': allCount,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
      'deletedFlag': deletedFlag,
      'subTasks': subTasks?.map((subTask) => subTask.toJson()).toList(),
    };
  }
}

class SubTask {
  int id;
  int taskId;
  int userId;
  dynamic orderId;
  String userName;
  int count;
  int status;
  int type;
  String mark;
  DateTime createTime;
  DateTime updateTime;

  SubTask({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.orderId,
    required this.userName,
    required this.count,
    required this.status,
    required this.type,
    required this.mark,
    required this.createTime,
    required this.updateTime,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: json['id'],
      taskId: json['taskId'],
      userId: json['userId'],
      orderId: json['orderId'],
      userName: json['userName'],
      count: json['count'],
      status: json['status'],
      type: json['type'],
      mark: json['mark'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'userId': userId,
      'orderId': orderId,
      'userName': userName,
      'mark': mark,
      'count': count,
      'status': status,
      'type': type,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
    };
  }
}

class OrderTask {
  Order order;
  Task? task;
  List<User>? duijieUsers;

  OrderTask({
    required this.order,
    this.task,
    this.duijieUsers,
  });

  factory OrderTask.fromJson(Map<String, dynamic> json) {
    return OrderTask(
      order: Order.fromJson(json['order']),
      task: json['task'] != null ? Task.fromJson(json['task']) : null,
      duijieUsers: (json['duijieUsers'] as List?)
          ?.where((x) => x != null)
          .map((x) => User.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order.toJson(),
      'task': task?.toJson(),
      'duijieUsers': duijieUsers != null
          ? List<dynamic>.from(duijieUsers!.map((x) => x.toJson()))
          : null,
    };
  }
}
