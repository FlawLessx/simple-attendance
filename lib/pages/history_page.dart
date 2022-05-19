import 'package:attendance/widgets/history_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SizedBox(
        height: ScreenUtil().screenHeight - kToolbarHeight,
        child: const SingleChildScrollView(
            child: FittedBox(child: HistoryTable())),
      ),
    );
  }
}
