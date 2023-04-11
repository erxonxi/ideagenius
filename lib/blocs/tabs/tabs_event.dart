part of 'tabs_bloc.dart';

abstract class TabsEvent extends Equatable {
  const TabsEvent();

  @override
  List<Object> get props => [];
}

class TabsChangeEvent extends TabsEvent {
  final int index;

  const TabsChangeEvent({required this.index});

  @override
  List<Object> get props => [index];
}
