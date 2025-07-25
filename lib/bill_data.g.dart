// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) => Bill(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      subType: json['subType'] as String,
      defaultNumber: json['defaultNumber'] as String,
      number: json['number'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      operTime: DateTime.parse(json['operTime'] as String),
      organId: (json['organId'] as num).toInt(),
      addressId: (json['addressId'] as num?)?.toInt(),
      creator: (json['creator'] as num).toInt(),
      accountId: (json['accountId'] as num?)?.toInt(),
      changeAmount: (json['changeAmount'] as num?)?.toDouble(),
      backAmount: (json['backAmount'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      payType: json['payType'] as String?,
      billType: json['billType'] as String?,
      remark: json['remark'] as String?,
      fileName: json['fileName'] as String?,
      salesMan: json['salesMan'] as String?,
      accountIdList: json['accountIdList'] as String?,
      accountMoneyList: json['accountMoneyList'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
      discountMoney: (json['discountMoney'] as num?)?.toDouble(),
      discountLastMoney: (json['discountLastMoney'] as num?)?.toDouble(),
      otherMoney: (json['otherMoney'] as num?)?.toDouble(),
      deposit: (json['deposit'] as num?)?.toDouble(),
      status: json['status'] as String?,
      purchaseStatus: json['purchaseStatus'] as String?,
      source: json['source'] as String?,
      linkNumber: json['linkNumber'] as String?,
      linkApply: json['linkApply'] as String?,
      tenantId: (json['tenantId'] as num?)?.toInt(),
      deleteFlag: json['deleteFlag'] as String?,
      projectName: json['projectName'] as String?,
      organName: json['organName'] as String?,
      addressName: json['addressName'] as String?,
      progress: json['progress'] == null
          ? null
          : Progress.fromJson(json['progress'] as Map<String, dynamic>),
      userName: json['userName'] as String?,
      accountName: json['accountName'] as String?,
      allocationProjectName: json['allocationProjectName'] as String?,
      materialsList: json['materialsList'] as String?,
      salesManStr: json['salesManStr'] as String?,
      operTimeStr: json['operTimeStr'] as String?,
      finishDebt: (json['finishDebt'] as num?)?.toDouble(),
      depotHeadType: json['depotHeadType'] as String?,
      creatorName: json['creatorName'] as String?,
      contacts: json['contacts'] as String?,
      telephone: json['telephone'] as String?,
      address: json['address'] as String?,
      finishDeposit: (json['finishDeposit'] as num?)?.toDouble(),
      needDebt: (json['needDebt'] as num?)?.toDouble(),
      debt: (json['debt'] as num?)?.toDouble(),
      materialCount: (json['materialCount'] as num?)?.toDouble(),
      hasFinancialFlag: json['hasFinancialFlag'] as bool?,
      hasBackFlag: json['hasBackFlag'] as bool?,
      realNeedDebt: (json['realNeedDebt'] as num?)?.toDouble(),
      advanceIn: (json['advanceIn'] as num?)?.toDouble(),
      beginNeedGet: (json['beginNeedGet'] as num?)?.toDouble(),
      beginNeedPay: (json['beginNeedPay'] as num?)?.toDouble(),
      allNeedGet: (json['allNeedGet'] as num?)?.toDouble(),
      allNeedPay: (json['allNeedPay'] as num?)?.toDouble(),
      allNeed: (json['allNeed'] as num?)?.toDouble(),
      previousDebt: (json['previousDebt'] as num?)?.toDouble(),
      billDetailAllPrice: json['billDetailAllPrice'] as String?,
      billDetailCnMoney: json['billDetailCnMoney'] as String?,
    );

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'subType': instance.subType,
      'defaultNumber': instance.defaultNumber,
      'number': instance.number,
      'createTime': instance.createTime.toIso8601String(),
      'operTime': instance.operTime.toIso8601String(),
      'organId': instance.organId,
      'addressId': instance.addressId,
      'creator': instance.creator,
      'accountId': instance.accountId,
      'changeAmount': instance.changeAmount,
      'backAmount': instance.backAmount,
      'totalPrice': instance.totalPrice,
      'payType': instance.payType,
      'billType': instance.billType,
      'remark': instance.remark,
      'fileName': instance.fileName,
      'salesMan': instance.salesMan,
      'accountIdList': instance.accountIdList,
      'accountMoneyList': instance.accountMoneyList,
      'discount': instance.discount,
      'discountMoney': instance.discountMoney,
      'discountLastMoney': instance.discountLastMoney,
      'otherMoney': instance.otherMoney,
      'deposit': instance.deposit,
      'status': instance.status,
      'purchaseStatus': instance.purchaseStatus,
      'source': instance.source,
      'linkNumber': instance.linkNumber,
      'linkApply': instance.linkApply,
      'tenantId': instance.tenantId,
      'deleteFlag': instance.deleteFlag,
      'projectName': instance.projectName,
      'organName': instance.organName,
      'addressName': instance.addressName,
      'progress': instance.progress,
      'userName': instance.userName,
      'accountName': instance.accountName,
      'allocationProjectName': instance.allocationProjectName,
      'materialsList': instance.materialsList,
      'salesManStr': instance.salesManStr,
      'operTimeStr': instance.operTimeStr,
      'finishDebt': instance.finishDebt,
      'depotHeadType': instance.depotHeadType,
      'creatorName': instance.creatorName,
      'contacts': instance.contacts,
      'telephone': instance.telephone,
      'address': instance.address,
      'finishDeposit': instance.finishDeposit,
      'needDebt': instance.needDebt,
      'debt': instance.debt,
      'materialCount': instance.materialCount,
      'hasFinancialFlag': instance.hasFinancialFlag,
      'hasBackFlag': instance.hasBackFlag,
      'realNeedDebt': instance.realNeedDebt,
      'advanceIn': instance.advanceIn,
      'beginNeedGet': instance.beginNeedGet,
      'beginNeedPay': instance.beginNeedPay,
      'allNeedGet': instance.allNeedGet,
      'allNeedPay': instance.allNeedPay,
      'allNeed': instance.allNeed,
      'previousDebt': instance.previousDebt,
      'billDetailAllPrice': instance.billDetailAllPrice,
      'billDetailCnMoney': instance.billDetailCnMoney,
    };

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      id: (json['id'] as num?)?.toInt(),
      orderId: json['orderId'],
      trace: (json['trace'] as List<dynamic>?)
          ?.map((e) => Trace.fromJson(e as Map<String, dynamic>))
          .toList(),
      curStatus: json['curStatus'] as String?,
      curTime: json['curTime'] == null
          ? null
          : DateTime.parse(json['curTime'] as String),
      curOperator: json['curOperator'] as String?,
      curOperatorId: (json['curOperatorId'] as num?)?.toInt(),
      creator: json['creator'] as String?,
      creatorId: (json['creatorId'] as num?)?.toInt(),
      deletedFlag: json['deletedFlag'] as bool?,
      type: (json['type'] as num?)?.toInt(),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'trace': instance.trace,
      'curStatus': instance.curStatus,
      'curTime': instance.curTime?.toIso8601String(),
      'curOperator': instance.curOperator,
      'curOperatorId': instance.curOperatorId,
      'creator': instance.creator,
      'creatorId': instance.creatorId,
      'deletedFlag': instance.deletedFlag,
      'type': instance.type,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
    };

Trace _$TraceFromJson(Map<String, dynamic> json) => Trace(
      operator: json['operator'] as String,
      operation: json['operation'] as String,
      time: json['time'] as String,
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$TraceToJson(Trace instance) => <String, dynamic>{
      'operator': instance.operator,
      'operation': instance.operation,
      'time': instance.time,
      'detail': instance.detail,
    };
