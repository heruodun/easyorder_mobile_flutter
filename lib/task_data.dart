class OrderSubTask {
  int id;
  int taskId;
  int userId;
  int orderId;
  String userName;
  int length;
  int count;
  int status;
  String? address;
  String? guige;
  DateTime createTime;
  DateTime updateTime;

  OrderSubTask({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.orderId,
    required this.userName,
    required this.length,
    required this.count,
    required this.status,
    this.address,
    this.guige,
    required this.createTime,
    required this.updateTime,
  });

  factory OrderSubTask.fromJson(Map<String, dynamic> json) {
    return OrderSubTask(
      id: json['id'],
      taskId: json['task_id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      userName: json['user_name'],
      length: json['length'],
      count: json['count'],
      status: json['status'],
      address: json['address'],
      guige: json['guige'],
      createTime: DateTime.parse(json['create_time']),
      updateTime: DateTime.parse(json['update_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'order_id': orderId,
      'user_name': userName,
      'length': length,
      'count': count,
      'status': status,
      'address': address,
      'guige': guige,
      'create_time': createTime.toIso8601String(),
      'update_time': updateTime.toIso8601String(),
    };
  }
}

class OrderTask {
  int id;
  int orderId;
  String? taskName;
  int status;
  String? address;
  String? guige;
  int? makeCount;
  int? allCount;
  DateTime createTime;
  DateTime updateTime;
  bool deletedFlag;
  List<OrderSubTask> subTasks; // 添加 OrderSubTask 列表属性

  OrderTask({
    required this.id,
    required this.orderId,
    this.taskName,
    required this.status,
    this.address,
    this.guige,
    this.makeCount,
    this.allCount,
    required this.createTime,
    required this.updateTime,
    this.deletedFlag = false,
    required this.subTasks, // 更新构造函数以接收 subTasks
  });

  factory OrderTask.fromJson(Map<String, dynamic> json) {
    var list = json['sub_tasks'] as List?; // 解析 subTasks
    List<OrderSubTask> subTasksList = list != null
        ? list.map((item) => OrderSubTask.fromJson(item)).toList()
        : [];

    return OrderTask(
      id: json['id'],
      orderId: json['order_id'],
      taskName: json['task_name'],
      status: json['status'],
      address: json['address'],
      guige: json['guige'],
      makeCount: json['make_count'],
      allCount: json['all_count'],
      createTime: DateTime.parse(json['create_time']),
      updateTime: DateTime.parse(json['update_time']),
      subTasks: subTasksList, // 添加 subTasks 列表
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'task_name': taskName,
      'status': status,
      'address': address,
      'guige': guige,
      'make_count': makeCount,
      'all_count': allCount,
      'create_time': createTime.toIso8601String(),
      'update_time': updateTime.toIso8601String(),
      'sub_tasks':
          subTasks.map((task) => task.toJson()).toList(), // 序列化 subTasks 列表
    };
  }
}
