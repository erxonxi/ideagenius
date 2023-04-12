part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  final List<Note> notes = [];

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  @override
  // ignore: overridden_fields
  final List<Note> notes;

  NotesLoaded([this.notes = const []]);

  @override
  List<Object> get props => [notes];

  @override
  String toString() => 'NotesLoaded { notes: $notes }';
}
