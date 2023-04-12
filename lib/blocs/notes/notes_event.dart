part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class NotesLoad extends NotesEvent {}

class NotesAdd extends NotesEvent {
  final Note note;

  const NotesAdd(this.note);

  @override
  List<Object> get props => [note];
}

class NotesUpdate extends NotesEvent {
  final Note note;

  const NotesUpdate(this.note);

  @override
  List<Object> get props => [note];
}

class NotesDelete extends NotesEvent {
  final Note note;

  const NotesDelete(this.note);

  @override
  List<Object> get props => [note];
}
