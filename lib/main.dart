import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 引入以支持 Cupertino 风格组件

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Mobile App Dev - Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const Lab02Screen(),
    );
  }
}

// 主界面（StatefulWidget 用于动态管理选中的日期和学院状态）
class Lab02Screen extends StatefulWidget {
  const Lab02Screen({super.key});

  @override
  State<Lab02Screen> createState() => _Lab02ScreenState();
}

class _Lab02ScreenState extends State<Lab02Screen> {
  DateTime _selectedDate = DateTime(2026, 10, 28);
  String _selectedHouse = 'Ravenclaw';
  final List<String> _houses = [
    'Gryffindor',
    'Slytherin',
    'Ravenclaw',
    'Hufflepuff',
  ];

  // 1. Material 日期选择器
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino 风格日期选择器（底部弹窗）
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _selectedDate = newDate);
          },
        ),
      ),
    );
  }

  // 3. Cupertino 滚轮选择器（底部弹窗）
  void _showCupertinoHousePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 220,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: _houses.indexOf(_selectedHouse),
                ),
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedHouse = _houses[index]);
                },
                children: _houses.map((house) => Center(child: Text(house))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // Exercise 2.2: 使用 OrientationBuilder 动态适配横竖屏
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // 竖屏视图：单列垂直滚动排布
  Widget _buildPortraitView() {
    return ListView(
      children: [
        _buildProfileCard(),
        const TitleSection(
          name: 'University of Technology Sarawak',
          location: 'Sungai Merah district of Sibu, Sarawak, Malaysia',
          starCount: 5,
        ),
        _buildLocationImage(), // 地点图片
        _buildPickersSection(),
      ],
    );
  }

  // 横屏视图：左右并排分栏排布
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _buildProfileCard(),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'University of Technology Sarawak',
                location: 'Sungai Merah district of Sibu, Sarawak, Malaysia',
                starCount: 5,
              ),
              _buildLocationImage(), // 地点图片
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  // 个人信息卡片
  Widget _buildProfileCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              SizedBox(height: 20),
              Text(
                'Wong Siew Ming',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Student ID: BCS24020025',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Divider(height: 32, thickness: 1),
              Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '"To become a skilled software developer and build impactful applications."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 地点图片组件 (加载 assets/Images/uts.jpg)
  Widget _buildLocationImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          'assets/Images/uts.jpg',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // 选择器卡片区 (包含所有 4 个 Picker 组件)
  Widget _buildPickersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Pickers (Lab 2.2)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Text('Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
              Text('Selected House: $_selectedHouse'),
              const SizedBox(height: 16),

              // 1. Material Date Picker
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('Material Date Picker'),
                onPressed: () => _selectMaterialDate(context),
              ),
              const SizedBox(height: 8),

              // 2. Cupertino Date Picker
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.calendar, size: 18),
                label: const Text('Cupertino Date Picker (Modal Sheet)'),
                onPressed: () => _showCupertinoDatePicker(context),
              ),
              const SizedBox(height: 16),

              // 3. Material DropdownButton
              Row(
                children: [
                  const Text('Material Dropdown:  '),
                  DropdownButton<String>(
                    value: _selectedHouse,
                    items: _houses.map((String house) {
                      return DropdownMenuItem<String>(
                        value: house,
                        child: Text(house),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() => _selectedHouse = newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 4. Cupertino House Wheel Picker
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.list_bullet, size: 18),
                label: const Text('Cupertino House Wheel Picker'),
                onPressed: () => _showCupertinoHousePicker(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exercise 2.1: 独立拆分的 TitleSection 小部件
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.star, color: Colors.amber[700]),
              const SizedBox(width: 4),
              Text('$starCount'),
            ],
          ),
        ),
      ),
    );
  }
}