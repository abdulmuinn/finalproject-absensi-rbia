import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/attendance_record.dart';
import '../repository/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository repository;
  StreamSubscription<List<AttendanceRecord>>? _subscription;

  AttendanceBloc({required this.repository}) : super(AttendanceInitial()) {
    on<AttendanceLoadRequested>(_onLoadRequested);
    on<AttendanceAddRequested>(_onAddRequested);
    on<AttendanceRecordsUpdated>(_onRecordsUpdated);

    _subscription = repository.watchRecords().listen((records) {
      add(AttendanceRecordsUpdated(records));
    });
  }

  Future<void> _onLoadRequested(
    AttendanceLoadRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    try {
      final records = await repository.fetchRecords();
      emit(AttendanceLoadSuccess(records));
    } catch (error) {
      emit(AttendanceLoadFailure(error.toString()));
    }
  }

  Future<void> _onAddRequested(
    AttendanceAddRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    repository.addRecord(event.record);
  }

  void _onRecordsUpdated(
    AttendanceRecordsUpdated event,
    Emitter<AttendanceState> emit,
  ) {
    emit(AttendanceLoadSuccess(event.records));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    repository.dispose();
    return super.close();
  }
}
