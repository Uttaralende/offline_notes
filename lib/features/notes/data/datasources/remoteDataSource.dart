import 'package:dio/dio.dart';

import '../models/note_model.dart';

abstract class RemoteDataSource {
  Future<List<NoteModel>> getNotes();

  Future<void> createNote(NoteModel note);

  Future<void> updateNote(NoteModel note);

  Future<void> deleteNote(String id);

  Future<NoteModel?> getNoteById(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await dio.get('/notes');

    final List data = response.data;

    return data
        .map((e) => NoteModel.fromJson(e))
        .toList();
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    final response = await dio.post(
      '/notes',
      data: note.toJson(),
    );

    return NoteModel.fromJson(response.data);
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    final response = await dio.put(
      '/notes/${note.id}',
      data: note.toJson(),
    );

    return NoteModel.fromJson(response.data);
  }

  @override
  Future<void> deleteNote(String id) async {
    await dio.delete('/notes/$id');
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    try {
      final response = await dio.get('/notes/$id');

      return NoteModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }


      rethrow;
    }
  }
}