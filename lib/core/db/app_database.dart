import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:bookvault/core/db/daos/books_dao.dart';
import 'package:bookvault/core/db/books_table.dart';

part 'app_database.g.dart';


@DriftDatabase(tables: [Books], daos: [BooksDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'bookvault.db'));
    return NativeDatabase.createInBackground(file);
  });
}
