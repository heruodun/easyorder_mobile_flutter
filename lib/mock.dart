// import 'dart:convert';

// import 'package:easyorder_mobile/order.dart';
// import 'package:easyorder_mobile/user_data.dart';
// import 'package:easyorder_mobile/user_role.dart';

// List<User> getUsers() {
//   List<User> allUsers = [
//     User(
//       loginName: 'user1',
//       actualName: '发哈哈',
//       phone: '123-456-7890',
//       token: 'token1',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule2'],
//     ),
//     User(
//       loginName: 'user2',
//       actualName: '法交',
//       phone: '234-567-8901',
//       token: 'token2',
//       roleInfoList: [],
//       scanRuleList: ['rule2', 'rule3'],
//     ),
//     User(
//       loginName: 'user3',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user4',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user5',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user6',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user7',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user8',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user9',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user10',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user11',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user12',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user13',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user14',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user15',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user16',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user17',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user18',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//     User(
//       loginName: 'user19',
//       actualName: '发发啊',
//       phone: '345-678-9012',
//       token: 'token3',
//       roleInfoList: [],
//       scanRuleList: ['rule1', 'rule3'],
//     ),
//   ];
//   return allUsers;
// }

// Order get() {
//   String jsonString = '''{
//                             "id": 79464,
//                             "orderId": 2025010600850101,
//                             "address": "富强72",
//                             "addressId": 744,
//                             "guiges": [
//                                 {
//                                     "guige": "3.5B14",
//                                     "count": 1000,
//                                     "danwei": "条",
//                                     "tiaos": [
//                                         {
//                                             "length": "48",
//                                             "count": 400
//                                         },
//                                         {
//                                             "length": "50",
//                                             "count": 200
//                                         },
//                                         {
//                                             "length": "52",
//                                             "count": 400
//                                         }
//                                     ]
//                                 }
//                             ],
//                             "remark": "有脚口",
//                             "detail": "规格：3.5B14    总数：1000 条\\n\\n48 x 400，50 x 200，52 x 400\\n\\n备注：有脚口",
//                             "trace": [
//                                 {
//                                     "operator": "梁加五",
//                                     "operation": "拣货",
//                                     "time": "2025-01-06 16:05:20",
//                                     "detail": "添加波次2611"
//                                 },
//                                 {
//                                     "operator": "余佳杰",
//                                     "operation": "配货",
//                                     "time": "2025-01-06 14:29:19",
//                                     "detail": null
//                                 },
//                                 {
//                                     "operator": "刘江红",
//                                     "operation": "打单",
//                                     "time": "2025-01-06 14:22:56",
//                                     "detail": null
//                                 }
//                             ],
//                             "curStatus": "拣货",
//                             "curTime": "2025-01-06 16:05:21",
//                             "curOperator": "梁加五",
//                             "curOperatorId": null,
//                             "creator": "刘江红",
//                             "creatorId": 73,
//                             "waveId": 2611,
//                             "deletedFlag": false,
//                             "createTime": "2025-01-06 14:22:56",
//                             "updateTime": "2025-01-06 16:05:20"
//                         }''';

//   Map<String, dynamic> jsonMap = json.decode(jsonString);
//   Order order = Order.fromJson(jsonMap);

//   print(order);
//   return order;
// }
