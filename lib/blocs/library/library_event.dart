part of 'library_bloc.dart';

@immutable
abstract class LibraryEvent {}

class AddPhotoEvent extends LibraryEvent {}

class RemovePhotoEvent extends LibraryEvent {}
