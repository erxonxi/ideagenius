import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/note.dart';
import '../../utils/notes_storage.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<NotesEvent>((event, emit) async {
      if (event is NotesLoad) {
        final notes = await NotesStorage.getNotes();

        emit(NotesLoaded(notes));
      } else if (event is NotesAdd) {
        await NotesStorage.addNote(event.note);

        emit(NotesLoaded(await NotesStorage.getNotes()));
      } else if (event is NotesUpdate) {
        await NotesStorage.updateNote(event.note);

        emit(NotesLoaded(await NotesStorage.getNotes()));
      } else if (event is NotesDelete) {
        await NotesStorage.deleteNote(event.note);

        emit(NotesLoaded(await NotesStorage.getNotes()));
      }
    });
  }
}
