// import 'package:easyorder_mobile/constants.dart';
// import 'package:easyorder_mobile/http_client.dart';
// import 'package:easyorder_mobile/order_data.dart';
// import 'package:easyorder_mobile/task_data.dart';
// import 'package:easyorder_mobile/timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

// class OrderDetailScreen extends StatefulWidget {
//   final String orderIdQr;

//   const OrderDetailScreen({super.key, required this.orderIdQr});

//   @override
//   _OrderDetailScreenState createState() => _OrderDetailScreenState();
// }

// class _OrderDetailScreenState extends State<OrderDetailScreen> {
//   late Order _orderDetail;

//   bool _isCompleted = false;

//   @override
//   void initState() {
//     fetchData();
//     super.initState();
//   }

//   Future<void> fetchData() async {
//     _isCompleted = false;
//     setState(() {});

//     // Order order = await fetchOrderByOrderIdQr(widget.orderIdQr);
//     // _orderDetail = order;

//     setState(() {
//       _isCompleted = true;
//     });
//   }

//   Widget _buildResultLayer() {
//     if (_isCompleted) {
//       return const SizedBox.shrink(); // 如果不需要显示结果，返回一个空的小部件
//     }

//     return Center(
//         child: LoadingAnimationWidget.horizontalRotatingDots(
//       color: Colors.grey,
//       size: 100,
//     ));
//   }

//   Widget _buildOrderLayer(BuildContext context) {
//     // if (!_isCompleted) {
//     //   return const SizedBox.shrink();
//     // }

//     // String printTimeStr = formatDatetime(_orderDetail.createTime);
//     // String curTimeStr = formatDatetime(_orderDetail.curTime);
//     // String differenceTimeStr =
//     //     formatTimeDifference(_orderDetail.createTime, _orderDetail.curTime);

//     // String content = _orderDetail.detail ?? '';

//     // String orderIdStr = _orderDetail.orderId.toString();

//     return Column(
//       children: [
//         ListTile(
//           title: Text("地址"),
//           trailing: Text("发发发发汗4发发发发发发"),
//         ),
//         // Text(_orderDetail!.address,
//         //     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         // Text('${_orderDetail!.orderId}', style: const TextStyle(fontSize: 14)),
//         // Column(
//         //   crossAxisAlignment: CrossAxisAlignment.start,
//         //   children: [
//         //     Text('当前处理: $curTimeStr'),
//         //     Text('打单时间: $printTimeStr'),
//         //     const Center(
//         //       child: Icon(Icons.shopping_bag, size: 20, color: Colors.blue),
//         //     ),
//         //     Text(content),
//         //     const Center(
//         //       child: Icon(Icons.timeline, size: 20, color: Colors.blue),
//         //     ),
//         //     TimelineWidget(traceList: _orderDetail.trace ?? []),
//         //   ],
//         // ),
//       ],
//     );
//   }

//   // 定义一个方法来返回状态文本
//   String _getStatusText(Task? task) {
//     if (task == null) {
//       return '未分单'; // 根据情况添加自定义文本
//     }
//     if (task.status == 0) {
//       return '未开始'; // 根据情况添加自定义文本
//     } else if (task.status == 10) {
//       return '部分完成';
//     } else if (task.status == 100) {
//       return '已完成';
//     } else {
//       return '未分单';
//     }
//   }

//   Color _getBackgroundColor(Task? task) {
//     if (task == null) {
//       return Colors.grey; // 根据情况添加自定义文本
//     }
//     if (task.status == 0) {
//       return Colors.red;
//     } else if (task.status == 10) {
//       return Colors.yellow;
//     } else if (task.status == 100) {
//       return Colors.green;
//     } else {
//       return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('订单详情'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Stack(
//           children: [
//             _buildOrderLayer(context),
//             _buildResultLayer(), // Add the loading layer on top
//           ],
//         ),
//       ),
//     );
//   }

// //------------------------------http-------------------------------
//   Future<Order> fetchOrderByOrderIdQr(String orderIdQr) async {
//     final response = await httpClient(
//         uri: Uri.parse('$httpHost/app/order?orderIdQr=$orderIdQr'),
//         method: "GET",
//         context: context);

//     if (response.isSuccess) {
//       return Order.fromJson(response.data);
//     } else {
//       throw Exception(response.message);
//     }
//   }
// }
