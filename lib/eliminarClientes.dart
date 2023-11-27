// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:consumir/listarClientes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Eliminar extends StatefulWidget {
  final String texto;
  const Eliminar(
    this.texto, {
    super.key,
  });

  @override
  State<Eliminar> createState() => _EditarState();
}

class _EditarState extends State<Eliminar> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  final _formKey = GlobalKey<FormState>();
  var nomUsuario = "";
  TextEditingController id = TextEditingController();

  @override
  void initState() {
    super.initState();
    nomUsuario = widget.texto;
    getUsuarios();
  }

  Future<void> getUsuarios() async {
    const Center(child: CircularProgressIndicator());
    final response =
        await http.get(Uri.parse('https://api-warrior.onrender.com/api/cliente'));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);
      setState(() {
        data = decodedData['clientes'] ?? [];
        filteredData.addAll(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('cargando datos...')),
        );
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los datos...')),
        );
      });
    }
    for (var i = 0; i < data.length; i++) {
      if (data[i]['nombreUsu'] == nomUsuario) {
        id.text = data[i]['_id'];
        break;
      }
    }
  }

  Future<void> _eliminarUsuario(String usu) async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> data = {'_id': id.text};
      final response = await http.delete(
        Uri.parse('https://api-warrior.onrender.com/api/cliente'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminando usuario...')),
        );
        await Future.delayed(const Duration(seconds: 1));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ListaUsuarios()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al eliminar el usuario.. Código de error: ${response.statusCode}...')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 43, 205, 220),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        '¿Seguro que desea eliminar el usuario "$nomUsuario"?',
                        style: const TextStyle(fontSize: 20),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _eliminarUsuario(nomUsuario);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 100, 0, 0))),
                                    child: const Text('Eliminar usuario'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListaUsuarios()));
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Color.fromARGB(
                                                    255, 100, 0, 0))),
                                    child: const Text('Volver'),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
