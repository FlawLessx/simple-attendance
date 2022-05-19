import 'package:attendance/model/history.dart';
import 'package:attendance/provider/db_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  final DBHelper _dbHelper = DBHelper();

  Future<void> insertHistory(History history) async {
    try {
      await _dbHelper.insertHistory(history);
      await getListHistory();
    } catch (e) {
      emit(HistoryError('Error When Save History'));
    }
  }

  Future<void> getListHistory() async {
    try {
      final data = await _dbHelper.getListHistory();
      emit(HistoryLoaded(data));
    } catch (e) {
      emit(HistoryError('Error When Load History Data'));
    }
  }
}
