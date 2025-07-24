import 'package:json_annotation/json_annotation.dart';

part 'bill_data.g.dart';

@JsonSerializable()
class Bill {
  final int id;
  final String type;
  final String subType;
  final String defaultNumber;
  final String number;
  final DateTime createTime;
  final DateTime operTime;
  final int organId;
  final int? addressId;
  final int creator;
  final int? accountId;
  final double? changeAmount;
  final double? backAmount;
  final double? totalPrice;
  final String? payType;
  final String? billType;
  final String? remark;
  final String? fileName;
  final String? salesMan;
  final String? accountIdList;
  final String? accountMoneyList;
  final double? discount;
  final double? discountMoney;
  final double? discountLastMoney;
  final double? otherMoney;
  final double? deposit;
  final String? status;
  final String? purchaseStatus;
  final String? source;
  final String? linkNumber;
  final String? linkApply;
  final int? tenantId;
  final String? deleteFlag;
  final String? projectName;
  final String? organName;
  final String? addressName;
  final Progress? progress;
  final String? userName;
  final String? accountName;
  final String? allocationProjectName;
  final String? materialsList;
  final String? salesManStr;
  final String? operTimeStr;
  final double? finishDebt;
  final String? depotHeadType;
  final String? creatorName;
  final String? contacts;
  final String? telephone;
  final String? address;
  final double? finishDeposit;
  final double? needDebt;
  final double? debt;
  final double? materialCount;
  final bool? hasFinancialFlag;
  final bool? hasBackFlag;
  final double? realNeedDebt;
  final double? advanceIn;
  final double? beginNeedGet;
  final double? beginNeedPay;
  final double? allNeedGet;
  final double? allNeedPay;
  final double? allNeed;
  final double? previousDebt;
  final String? billDetailAllPrice;
  final String? billDetailCnMoney;

  Bill({
    required this.id,
    required this.type,
    required this.subType,
    required this.defaultNumber,
    required this.number,
    required this.createTime,
    required this.operTime,
    required this.organId,
    this.addressId,
    required this.creator,
    this.accountId,
    this.changeAmount,
    this.backAmount,
    this.totalPrice,
    this.payType,
    this.billType,
    this.remark,
    this.fileName,
    this.salesMan,
    this.accountIdList,
    this.accountMoneyList,
    this.discount,
    this.discountMoney,
    this.discountLastMoney,
    this.otherMoney,
    this.deposit,
    this.status,
    this.purchaseStatus,
    this.source,
    this.linkNumber,
    this.linkApply,
    this.tenantId,
    this.deleteFlag,
    this.projectName,
    this.organName,
    this.addressName,
    this.progress,
    this.userName,
    this.accountName,
    this.allocationProjectName,
    this.materialsList,
    this.salesManStr,
    this.operTimeStr,
    this.finishDebt,
    this.depotHeadType,
    this.creatorName,
    this.contacts,
    this.telephone,
    this.address,
    this.finishDeposit,
    this.needDebt,
    this.debt,
    this.materialCount,
    this.hasFinancialFlag,
    this.hasBackFlag,
    this.realNeedDebt,
    this.advanceIn,
    this.beginNeedGet,
    this.beginNeedPay,
    this.allNeedGet,
    this.allNeedPay,
    this.allNeed,
    this.previousDebt,
    this.billDetailAllPrice,
    this.billDetailCnMoney,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);
}

@JsonSerializable()
class Progress {
  final int? id;
  final dynamic orderId;
  final List<Trace>? trace;
  final String? curStatus;
  final DateTime? curTime;
  final String? curOperator;
  final int? curOperatorId;
  final String? creator;
  final int? creatorId;
  final bool? deletedFlag;
  final int? type;
  final DateTime? createTime;
  final DateTime? updateTime;

  Progress({
    this.id,
    this.orderId,
    this.trace,
    this.curStatus,
    this.curTime,
    this.curOperator,
    this.curOperatorId,
    this.creator,
    this.creatorId,
    this.deletedFlag,
    this.type,
    this.createTime,
    this.updateTime,
  });

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}

@JsonSerializable()
class Trace {
  // TraceEle内容。这是你Java的 List<TraceEle> trace; 的字段
  final String operator;
  final String operation;
  final String time;
  final String? detail;

  Trace({
    required this.operator,
    required this.operation,
    required this.time,
    this.detail,
  });

  factory Trace.fromJson(Map<String, dynamic> json) => _$TraceFromJson(json);
  Map<String, dynamic> toJson() => _$TraceToJson(this);
}
