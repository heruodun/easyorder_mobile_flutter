// To parse this JSON data, do
//
//     final waveList = waveListFromJson(jsonString);

import 'dart:convert';

WaveList waveListFromJson(String str) => WaveList.fromJson(json.decode(str));

String waveListToJson(WaveList data) => json.encode(data.toJson());

class WaveList {
    List<Wave> wave;

    WaveList({
        required this.wave,
    });

    factory WaveList.fromJson(Map<String, dynamic> json) => WaveList(
        wave: List<Wave>.from(json["data"].map((x) => Wave.fromJson(x))),
    );

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
    WaveDetail? waveDetail;
    int? status;
    String? shipIds;
    int? shipCount;

    Wave({
        required this.waveId,
        required this.waveAlias,
        required this.createMan,
        required this.createTime,
        required this.updateTime,
        required this.firstScanTime,
        required this.lastScanTime,
        required this.waveDetail,
        required this.status,
        required this.shipIds,
        required this.shipCount,
    });

    factory Wave.fromJson(Map<String, dynamic> json) => Wave(
        waveId: json["waveId"],
        waveAlias: json["waveAlias"],
        createMan: json["createMan"],
        createTime: json["createTime"],
        updateTime: json["updateTime"],
        firstScanTime: json["firstScanTime"],
        lastScanTime: json["lastScanTime"],
        waveDetail: json["waveDetail"] == null ? null : WaveDetail.fromJson(json["waveDetail"]),
        status: json["status"],
        shipIds: json["shipIds"],
        shipCount: json["shipCount"]
    );

    Map<String, dynamic> toJson() => {
        "waveId": waveId,
        "waveAlias": waveAlias,
        "createMan": createMan,
        "createTime": createTime.toIso8601String(),
        "updateTime": updateTime.toIso8601String(),
        "firstScanTime": firstScanTime,
        "lastScanTime": lastScanTime,
        "waveDetail": waveDetail == null ? "" : toJson(),
        "status": status,
        "shipIds": shipIds,
        "shipCount": shipCount,
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
        addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
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
        orders: json["orders"] == null ? [] : List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "orderCount": orderCount,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class Order {
    String curStatus;
    String address;
    dynamic printer;
    dynamic curTime;
    String content;
    DateTime updateTime;
    dynamic curMan;
    int waveId;
    dynamic printTime;
    dynamic syncStatus;
    int id;
    int orderId;
    dynamic orderTrace;

    Order({
        required this.curStatus,
        required this.address,
        required this.printer,
        required this.curTime,
        required this.content,
        required this.updateTime,
        required this.curMan,
        required this.waveId,
        required this.printTime,
        required this.syncStatus,
        required this.id,
        required this.orderId,
        required this.orderTrace,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        curStatus: json["cur_status"],
        address: json["address"],
        printer: json["printer"],
        curTime: json["cur_time"],
        content: json["content"],
        updateTime: DateTime.parse(json["update_time"]),
        curMan: json["cur_man"],
        waveId: json["wave_id"],
        printTime: json["print_time"],
        syncStatus: json["sync_status"],
        id: json["id"],
        orderId: json["order_id"],
        orderTrace: json["order_trace"],
    );

    Map<String, dynamic> toJson() => {
        "cur_status": curStatus,
        "address": address,
        "printer": printer,
        "cur_time": curTime,
        "content": content,
        "update_time": updateTime.toIso8601String(),
        "cur_man": curMan,
        "wave_id": waveId,
        "print_time": printTime,
        "sync_status": syncStatus,
        "id": id,
        "order_id": orderId,
        "order_trace": orderTrace,
    };
}

