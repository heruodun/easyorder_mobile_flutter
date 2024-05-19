import 'package:easyorder_mobile/role_router.dart';
import 'package:easyorder_mobile/scan_picker.dart';
import 'package:easyorder_mobile/wave_detail_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'main.dart';
import 'user_data.dart';
import 'wave_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WaveListScreen extends StatefulWidget {
  final User user;
  const WaveListScreen({
    super.key,
    required this.user,
  });


  @override
  _WaveListScreenState createState() => _WaveListScreenState();
}

class _WaveListScreenState extends State<WaveListScreen> {
  DateTime selectedDate = DateTime.now();
  List<Wave> waves = []; // 波次列表数据
  bool _isCompleted = false; 
  

  @override 
  void initState() {
    super.initState();
    fetchData(); // 获得初始化数据
  }

  void fetchData() {
    // 服务器返回的JSON响应会被转换成一个包含Wave对象的列表

    setState(() {
        waves = [];
        _isCompleted = false;
      });

    fetchWavesByDate(selectedDate).then((data) {
      setState(() {
        waves = data;
        _isCompleted = true;
      });
    });
  }





  @override
  Widget build(BuildContext context) {

   

    return Scaffold(
      appBar: AppBar(
        
        title: const Text('波次列表'),

       
      ),
      body: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // 显示对话框
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('确认'),
                        content: const Text('新增一个波次？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // 关闭对话框
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              // 关闭对话框
                              Navigator.of(context).pop();
                              _addNewWave();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              GestureDetector(
                onTap: () => _selectDate(context),
                onDoubleTap: () => _selectDate(context),
                
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10, height: 20,),
                    Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // 处理搜索按钮逻辑
                  fetchData(); // 重新获取数据
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('共计${waves.length}个波次', style: Theme.of(context).textTheme.titleSmall),
          ),
          
          Expanded(
            
            child: 
            Stack(
              children: [
              ListView.builder(
                itemCount: waves.length,
                itemBuilder: (context, index) {

                  return WaveItem(
                      wave: waves[index],
                      index: index, // 将索引传递给WaveItem
                      key: ValueKey(waves[index].waveId), // 使用waveId作为唯一key，如果waveId是唯一的话
                      addressCount: waves[index].waveDetail!.totalCount,
                      totalCount: waves[index].waveDetail!.totalCount,
                    );
                },
              ),
            _buildResultLayer(),
              

            ]
            ),
          ),
        ],
      ),

     
     
      
    );
  }

  
  
  Widget _buildResultLayer() {
    if (_isCompleted) {
      return const SizedBox.shrink(); // 如果不需要显示结果，返回一个空的小部件
    }

    return Center(
      child: LoadingAnimationWidget.horizontalRotatingDots(
        color: Colors.grey,
        size: 100,
      ));
  }

  Future<void> _selectDate(BuildContext context) async {
    // 获取当前时间的前一天
    final DateTime previousDay = DateTime.now().subtract(const Duration(days: 1));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: previousDay,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchData();
      });
    }
  }

  
void _addNewWave() async {
  User? user = await User.getCurrentUser(); 
  // 假设你要创建并传递一个新的Wave对象，你需要根据实际情况来构建它

  // 将Wave对象序列化为JSON
  final waveJson = {'createMan':user!.actualName};

  print(waveJson);
  
  try {
    // 发送HTTP POST请求，将Wave保存到服务器上
    final response = await http.post(
      Uri.parse('$httpHost/mobile/waveInfo/add'), // 替换为你的API端点
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(waveJson),
    );
    
    // 检查服务器响应是否成功
    if (response.statusCode == 200) {
      // 解析响应数据创建Wave对象
      String body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(body);
      print(data);
      if (data['code'] == 0) {
        fetchData();
      }
      else {
      throw Exception('Invalid response code: ${data['code']}');
    }
  } else {
      // 错误处理：服务器响应错误
      print('服务器错误: ${response.statusCode}');
    }
  } catch (error) {
    // 错误处理：网络请求失败等
    print('HTTP请求错误: $error');
  }
}
}

class WaveItem extends StatelessWidget {
  final Wave wave;
  final int index; // 添加index参数
  final int addressCount;
  final int totalCount;

  const WaveItem({required this.wave, required this.index, super.key, required this.addressCount, required this.totalCount});

  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 点击时导航到波次详情页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaveDetailsPickerScreen(wave: wave),
          ),
        );
      },
    
    
    child: ListTile(

      title: Text('波次编号: ${wave.waveId}', style: Theme.of(context).textTheme.titleSmall,),

      subtitle: Text('共计${wave.waveDetail?.addressCount}个地址, ${wave.waveDetail?.totalCount}个订单\n创建时间: ${wave.createTime}'),
      leading: Text('${index + 1}', style: Theme.of(context).textTheme.bodyMedium,), // 显示从1开始的序号
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
               // 使用Navigator.push方法来跳转到ScanScreen，并传递新的Wave对象
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanPickerScreen(wave: wave, type: 1,),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () async {
              // 实现减少数量逻辑
              // 使用Navigator.push方法来跳转到ScanScreen，并传递新的Wave对象
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanPickerScreen(wave: wave, type: -1,),
                ),
              );
            },
          ),
        ],
      ),
    )
    );
  }
}



//-----------------------------------列表------------------------



// 从服务器获取波次数据的函数
Future<List<Wave>> fetchWavesByDate(DateTime date) async {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final response = await http.get(
    Uri.parse('$httpHost/mobile/waveInfos?date=$formattedDate'),
  );

  if (response.statusCode == 200) {
    // Decode the JSON response.body into a Dart object.
    String body = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data = jsonDecode(body);
    if (data['code'] == 0) {
      print(data['data']);
      return waveListFromJson(body).wave;

    } else {
      throw Exception('Invalid response code: ${data['code']}');
    }
  } else {
    throw Exception('Failed to load waves: ${response.statusCode}');
  }
}

