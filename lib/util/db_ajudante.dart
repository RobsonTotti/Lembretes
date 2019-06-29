import 'dart:async';
import 'dart:io';

import 'package:lembrete/modelos/lembrete.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';



class DbAjudante{
  static final DbAjudante _instance = new DbAjudante.internal();

  factory DbAjudante() => _instance;

  final String tabLembrete = "LEMBRETE";
  final String colId = "ID";
  final String colTitulo = "TITULO";
  final String colDescricao = "DESCRICAO";
  final String colData = "DATACRIACAO";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initBD();
    return _db;
  }

  DbAjudante.internal();

  initBD() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();
    String caminho = join(documentoDiretorio.path, "lembrete.db");

    var nossoBD = await openDatabase(caminho, version: 1, onCreate: _onCreate);
    return nossoBD;
  }

  void _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $tabLembrete($colId INTEGER PRIMARY KEY,"
        " $colTitulo TEXT,"
        " $colDescricao TEXT,"
        " $colData TEXT)");
    print("Tabela criada");
  }

  Future<int> salvarLembrete(Lembrete lembrete) async {
    var bdCliente = await db;
    int res = await bdCliente.insert("$tabLembrete", lembrete.toMap());
    print(res.toString());

    return res;
  }

  Future<List> recuperarLembretes() async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $tabLembrete");
    List lembretes = res.toList();

    print(lembretes);
    return lembretes;
  }

  Future<int> pegarContagem() async {
    var bdCliente = await db;

    return Sqflite.firstIntValue(
        await bdCliente.rawQuery("SELECT COUNT(*) FROM $tabLembrete"));
  }

  Future<Lembrete> recuperarLembrete(int id) async {
    var bdCliente = await db;
    var res = await bdCliente
        .rawQuery("SELECT * FROM $tabLembrete WHERE $colId = $id");

    if (res.length == 0) {
      return null;
    } else {
      return new Lembrete.fromMap(res.first);
    }
  }

  Future<int> apagarLembrete(int id) async {
    var bdCliente = await db;

    //return await bdCliente.delete(tabLembrete, where: "$colId = ?", whereArgs: [id]);

    String delete = "DELETE FROM $tabLembrete WHERE $colId = $id";
    print(delete);
    return await bdCliente.rawDelete(delete);

  }

  Future<int> atualizarLembrete(Lembrete lembrete) async{
    var bdCliente = await db;

    return await bdCliente.update(tabLembrete, lembrete.toMap(), where:"$colId = ?", whereArgs: [lembrete.id]);

  }

  Future fechar() async{
    var bdCliente = await db;

    return bdCliente.close();
  }

}