import 'dart:convert';

WaveList waveListFromJson(List<dynamic> json) {
  return WaveList.fromJson(json);
}

// WaveList waveListFromJson(String str) => WaveList.fromJson(json.decode(str));

String waveListToJson(WaveList data) => json.encode(data.toJson());

class WaveList {
  List<Wave> wave;

  WaveList({
    required this.wave,
  });

  factory WaveList.fromJson(List<dynamic> json) {
    List<Wave> waves = json.map((waveJson) => Wave.fromJson(waveJson)).toList();
    return WaveList(wave: waves);
  }

  // factory WaveList.fromJson(List<dynamic> json) => WaveList(
  //       wave: List<Wave>.from(json["data"].map((x) => Wave.fromJson(x))),
  //     );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(wave.map((x) => x.toJson())),
      };
}

class Wave {
  int waveId;
  String waveAlias;
  String createMan;
  dynamic createTime;
  dynamic updateTime;
  dynamic firstScanTime;
  dynamic lastScanTime;
  List<Address> addressOrders;
  int addressCount;
  int orderCount;
  int? status;
  String? shipIds;
  int? shipCount;
  String? shipMan;

  Wave({
    required this.waveId,
    required this.waveAlias,
    required this.createMan,
    required this.createTime,
    required this.updateTime,
    required this.firstScanTime,
    required this.lastScanTime,
    required this.addressOrders,
    required this.addressCount,
    required this.orderCount,
    required this.status,
    required this.shipIds,
    required this.shipCount,
    required this.shipMan,
  });

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        waveId: json["waveId"],
        waveAlias: json["waveAlias"],
        createMan: json["createMan"],
        createTime: json["createTime"],
        updateTime: json["updateTime"],
        firstScanTime: json["firstScanTime"],
        lastScanTime: json["lastScanTime"],
        addressOrders: json["addressOrders"] == null
            ? []
            : List<Address>.from(
                json["addressOrders"].map((x) => Address.fromJson(x))),
        addressCount: json["addressCount"],
        orderCount: json["orderCount"],
        status: json["status"],
        shipIds: json["shipIds"],
        shipCount: json["shipCount"],
        shipMan: json["shipMan"],
      );

  Map<String, dynamic> toJson() => {
        "waveId": waveId,
        "waveAlias": waveAlias,
        "createMan": createMan,
        "createTime": createTime.toIso8601String(),
        "updateTime": updateTime.toIso8601String(),
        "firstScanTime": firstScanTime,
        "lastScanTime": lastScanTime,
        "addressOrders":
            List<dynamic>.from(addressOrders.map((x) => x.toJson())),
        "status": status,
        "shipIds": shipIds,
        "shipCount": shipCount,
        "shipMan": shipMan,
      };
}

class WaveDetail {
  List<Address> addresses;
  int totalCount;
  int addressCount;

  WaveDetail({
    required this.addresses,
    required this.totalCount,
    required this.addressCount,
  });

  factory WaveDetail.fromJson(Map<String, dynamic> json) => WaveDetail(
        addresses: json["addresses"] == null
            ? []
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x))),
        totalCount: json["totalCount"],
        addressCount: json["addressCount"],
      );

  Map<String, dynamic> toJson() => {
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "totalCount": totalCount,
        "addressCount": addressCount,
      };
}

class Address {
  String address;
  int orderCount;
  List<Order> orders;

  Address({
    required this.address,
    required this.orderCount,
    required this.orders,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        orderCount: json["orderCount"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "orderCount": orderCount,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  int id;
  int orderId;
  String address;
  dynamic detail; // 使用 dynamic，建议使用更具体的类型
  List<TraceEle> trace; // 确保 TraceEle 类已定义
  String curStatus;
  DateTime curTime;
  String curOperator;
  String creator;
  int waveId;
  DateTime createTime;
  DateTime updateTime;

  // 构造方法
  Order({
    required this.id,
    required this.orderId,
    required this.address,
    required this.detail,
    required this.trace,
    required this.curStatus,
    required this.curTime,
    required this.curOperator,
    required this.creator,
    required this.waveId,
    required this.createTime,
    required this.updateTime,
  });

  // fromJson 方法
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderId: json['orderId'],
      address: json['address'],
      detail: json['detail'], // 这里可以根据需要进行类型转换
      trace: json['trace'] != null && json['trace'] is List
          ? (json['trace'] as List).map((i) => TraceEle.fromJson(i)).toList()
          : [],
      // trace: (json['trace'] as List).map((i) => TraceEle.fromJson(i)).toList(),
      curStatus: json['curStatus'],
      curTime: DateTime.parse(json['curTime']),
      curOperator: json['curOperator'],
      creator: json['creator'],
      waveId: json['waveId'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'address': address,
      'detail': detail, // 这里也可以根据需要进行类型转换
      'trace': trace.map((e) => e.toJson()).toList(),
      'curStatus': curStatus,
      'curTime': curTime.toIso8601String(),
      'curOperator': curOperator,
      'creator': creator,
      'waveId': waveId,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
    };
  }
}

class TraceEle {
  String operator;
  String operation;
  DateTime time;

  // 构造方法
  TraceEle({
    required this.operator,
    required this.operation,
    required this.time,
  });

  // 从JSON构造TraceEle对象
  factory TraceEle.fromJson(Map<String, dynamic> json) {
    return TraceEle(
      operator: json['operator'],
      operation: json['operation'],
      time: DateTime.parse(json['time']), // 解析时间字符串为LocalDateTime
    );
  }

  // 将TraceEle对象序列化为JSON
  Map<String, dynamic> toJson() {
    return {
      'operator': operator,
      'operation': operation,
      'time': time.toIso8601String(), // 转换为字符串
    };
  }
}
