import 'package:flutter/material.dart';
import 'package:lembrete/modelos/lembrete.dart';
import 'package:lembrete/util/db_ajudante.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class LembretesTela extends StatefulWidget {
  @override
  _LembretesTelaState createState() => _LembretesTelaState();
}

class _LembretesTelaState extends State<LembretesTela> {
  final TextEditingController controlTitulo = new TextEditingController();
  final TextEditingController controlDescricao = new TextEditingController();
  var db = new DbAjudante();
  final List<Lembrete> lembreteLista = <Lembrete>[];

  @override
  void initState() {
    super.initState();
    pegarLembretes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemCount: lembreteLista.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, int posicao) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: lembreteLista[posicao],
                    onLongPress: () =>
                        _atualizarLembrete(lembreteLista[posicao], posicao),
                    trailing: Listener(
                      key: Key(lembreteLista[posicao].titulo),
                      child: Icon(Icons.remove_circle, color: Colors.redAccent,),
                      onPointerDown: (pointerEvento) => _apagarLembrete(lembreteLista[posicao].id, posicao),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarFormulario,
        backgroundColor: Colors.grey,
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  void pegarLembretes() async {
    List _lembretes = await db.recuperarLembretes();

    _lembretes.forEach((item) {
      setState(() {
        lembreteLista.add(Lembrete.map(item));
      });
    });
  }

  void _mostrarFormulario() {
    var alert = AlertDialog(
      content: Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controlTitulo,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Titulo',
                  hintText: 'Titulo',
                  icon: Icon(Icons.title)),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controlDescricao,
              autofocus: false,
              decoration: InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descrição',
                  icon: Icon(Icons.description)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            procText(controlTitulo.text, controlDescricao.text);
            controlTitulo.clear();
            controlDescricao.clear();
            Navigator.pop(context);
          },
          child: Text("Salvar"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void procText(String text, String text2) async {
    controlTitulo.clear();
    controlDescricao.clear();

    Lembrete lembrete = new Lembrete(text, text2, dataFormatada());

    int idSalvo = await db.salvarLembrete(lembrete);

    Lembrete itemSalvo = await db.recuperarLembrete(idSalvo);

    setState(() {
      lembreteLista.insert(0, itemSalvo);
    });
  }

  String dataFormatada() {
    var agora = DateTime.now();
    print("AGORA: $agora");

    initializeDateFormatting("pt_BR", null);
    var format = new DateFormat.yMMMd("pt_BR");

    String dataFormat = format.format(agora);
    print("DATA FORMATADA: $dataFormat");

    return dataFormat;
  }

  _atualizarLembrete(Lembrete lembrete, int posicao) {

    print("${lembrete.titulo}, ${lembrete.id}, ${lembrete.descricao}");

    var alert = AlertDialog(
      title: Text("Atualizar Lembrete"),
      content: Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controlTitulo,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Titulo",
                icon: Icon(Icons.update),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controlDescricao,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Descrição",
                icon: Icon(Icons.update),
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              Lembrete atualizarItem = Lembrete.fromMap({
                "TITULO": controlTitulo.text,
                "DESCRICAO": controlDescricao.text,
                "DATACRIACAO": dataFormatada(),
                "ID": lembrete.id
              });

              _atualizacao(posicao, lembrete);
              await db.atualizarLembrete(atualizarItem);
              setState(() {
                pegarLembretes();
                //db.recuperarLembretes();
              });
              Navigator.pop(context);
            },
            child: Text("Atualizar")),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });



  }
  void _atualizacao(int posicao, Lembrete lembrete) {
    setState(() {
      lembreteLista.removeWhere((elemento) {
        lembreteLista[posicao].titulo == lembrete.titulo;
      });
    });
  }

  _apagarLembrete(int id, int posicao) async{
    await db.apagarLembrete(id);

    setState(() {
      lembreteLista.removeAt(posicao);
    });
  }



}
