import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_state.dart';
part 'storage_event.dart';
part 'storage_bloc.freezed.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc() : super(const StorageState.unitialized()) {}
}
