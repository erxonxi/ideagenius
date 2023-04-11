part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChangedEvent extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChangedEvent({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
