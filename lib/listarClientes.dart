import 'package:consumir/editarClientes.dart';
import 'package:consumir/eliminarClientes.dart';
import 'package:consumir/menu.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaUsuarios extends StatefulWidget {
  const ListaUsuarios({Key? key}) : super(key: key);

  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  List<dynamic> data = [];
  // List<dynamic> prueba = [];
  List<dynamic> filteredData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsuarios();
  }

  Future<void> getUsuarios() async {
    const Center(child: CircularProgressIndicator());
    final response =
        await http.get(Uri.parse('https://api-warrior.onrender.com/api/cliente'));
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedData = json.decode(response.body);

      //String body = utf8.decode(response.bodyBytes); //para que no salga error si hay palabras con tilde o 'ñ'
      // print(decodedData["usuarios"][0]["nombre"]); //navegar en la api
      // for (var item in decodedData["usuarios"]) {
      //   prueba.add(Gif(item["nombreUsu"], item["password"]));
      // } consultar griview.count(crossAxisCount: 2)
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listando usuarios...')),
        );
        data = decodedData['clientes'] ?? [];
        filteredData
            .addAll(data); // Inicializar la lista filtrada con todos los datos
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al listar los usuarios...')),
        );
      });
    }
  }

  void _filterList(String searchText) {
    setState(() {
      filteredData = data
          .where((user) =>
              user['nombreUsu']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              user['nombre'].toLowerCase().contains(searchText.toLowerCase()) ||
              user['apellidos']
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              user['correo'].toLowerCase().contains(searchText.toLowerCase()) ||
              user['celular'].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  var selUser = "";

  void editar() {
    // final route = MaterialPageRoute(builder: (context) => editar());
    // Navigator.push(context, route);
    // Navigator.pushNamed(context, './editarUsuario.dart',
    //     arguments: {"selUser": selUser});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Editar(selUser)));
  }

  void eliminar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Eliminar(selUser)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu()));
          },
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: Image.asset(
              'assets/logo-twbs-blanco.png', // Reemplaza con la URL de tu imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del Card
              width: 150,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 43, 205, 220),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterList(value);
              },
              decoration: const InputDecoration(
                labelText: 'Buscar...',
                labelStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
                floatingLabelStyle:
                    TextStyle(color: Color.fromARGB(255, 100, 0, 0)),
                prefixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 100, 0, 0)),
                // border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 0, 0, 0), width: 1)),
                focusedBorder: UnderlineInputBorder(
                    // borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 100, 0, 0))),
                // fillColor: Color.fromARGB(255, 255, 200, 200),
                // filled: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Card(
                    elevation: 10,
                    color: const Color.fromARGB(255, 43, 205, 220),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 5),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 100, 0, 0),
                                ),
                              ),
                              Text('Usuario: ' +
                                  filteredData[index]['nombreUsu']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.photo_camera_front_rounded,
                                  color: Color.fromARGB(255, 100, 0, 0),
                                ),
                              ),
                              Text('Nombre:  ' + filteredData[index]['nombre']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.photo_camera_front_rounded,
                                  color: Color.fromARGB(255, 100, 0, 0),
                                ),
                              ),
                              Text('Apellido:  ' +
                                  filteredData[index]['apellidos']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.mail,
                                  color: Color.fromARGB(255, 100, 0, 0),
                                ),
                              ),
                              Text('Correo:  ' + filteredData[index]['correo']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.phone,
                                  color: Color.fromARGB(255, 100, 0, 0),
                                ),
                              ),
                              Text('Celular:  ' +
                                  filteredData[index]['celular']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          selUser =
                                              filteredData[index]['nombreUsu'];
                                          editar();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                            Color.fromARGB(255, 100, 0, 0),
                                          ),
                                        ),
                                        child: const Text('Modificar'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          selUser =
                                              filteredData[index]['nombreUsu'];
                                          eliminar();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                            Color.fromARGB(255, 100, 0, 0),
                                          ),
                                        ),
                                        child: const Text('Eliminar'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // GridView.count(crossAxisCount: 2),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
