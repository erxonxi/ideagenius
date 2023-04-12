import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'tabs_event.dart';

class TabsBloc extends Bloc<TabsEvent, int> {
  TabsBloc() : super(0) {
    on<TabsChangeEvent>((event, emit) {
      emit(event.index);
    });
  }
}
