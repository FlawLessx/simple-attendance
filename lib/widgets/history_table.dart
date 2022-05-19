import 'package:attendance/bloc/history/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryTable extends StatelessWidget {
  const HistoryTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoaded) {
          return DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  numeric: true,
                  label: Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Pin Location',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'User Location',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Distance (Meter)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: state.histories
                  .asMap()
                  .entries
                  .map(
                    (e) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(e.value.id.toString())),
                        DataCell(Text(e.value.date)),
                        DataCell(Text(e.value.pinLocation)),
                        DataCell(Text(e.value.userLocation)),
                        DataCell(Text(e.value.distance.toString())),
                      ],
                    ),
                  )
                  .toList());
        } else if (state is HistoryError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(state.message),
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
