import 'package:flutter/material.dart';

class Lembrete extends StatelessWidget {
  int id;
  String titulo;
  String descricao;
  String dataCriacao;

  Lembrete(this.titulo, this.descricao, this.dataCriacao);

  Lembrete.map(dynamic obj) {
    this.id = obj["ID"];
    this.titulo = obj["TITULO"];
    this.descricao = obj["DESCRICAO"];
    this.dataCriacao = obj["DATACRIACAO"];
  }

  String get gettitulo {
    return titulo;
  }

  String get getDescricao {
    return descricao;
  }

  String get getDataCriacao {
    return dataCriacao;
  }

  int get getId {
    return id;
  }

  Map<String, dynamic> toMap() {
    var mapa = new Map<String, dynamic>();
    mapa["TITULO"] = titulo;
    mapa["DESCRICAO"] = descricao;
    mapa["DATACRIACAO"] = dataCriacao;

    if (id != null) {
      mapa["ID"] = id;
    }
    return mapa;
  }

  Lembrete.fromMap(Map<String, dynamic> mapa) {
    this.titulo = mapa["TITULO"];
    this.descricao = mapa["DESCRICAO"];
    this.dataCriacao = mapa["DATACRIACAO"];
    this.id = mapa["ID"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      //alignment: Alignment(x, y),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  "$titulo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9,
                  ),
                ),
              ),
              Container(
                //alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "$dataCriacao",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 6.5,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          Text(
            "$descricao",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}

//Padding(
//padding: const EdgeInsets.only(right: 20.0),
//child: Text(
//"$titulo",
//style: TextStyle(
//color: Colors.white,
//fontWeight: FontWeight.bold,
//fontSize: 16.9,
//),
//),
//),
//Container(
////alignment: Alignment.centerLeft,
//margin: const EdgeInsets.only(top: 5.0),
//child: Text(
//
//"$dataCriacao",
//style: TextStyle(
//color: Colors.white70,
//fontSize: 8.5,
//fontStyle: FontStyle.italic),
//),
//),
