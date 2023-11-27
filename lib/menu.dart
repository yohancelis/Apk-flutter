import 'package:consumir/Login.dart';
import 'package:consumir/listarClientes.dart';
import 'package:consumir/registrarClientes.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
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
        backgroundColor: Color.fromARGB(255, 43, 205, 220)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 43, 205, 220),
              child: ListTile(
                leading: const Icon(Icons.people_alt,
                    color: Color.fromARGB(255, 100, 0, 0)),
                title: const Text('Lista de usuarios'),
                onTap: () {
                  final route = MaterialPageRoute(
                      builder: (context) => const ListaUsuarios());
                  Navigator.push(context, route);
                },
              ),
            ),
          ),
          Card(
            elevation: 10,
            color: const Color.fromARGB(255, 43, 205, 220),
            child: ListTile(
              leading: const Icon(Icons.person_add,
                  color: Color.fromARGB(255, 100, 0, 0)),
              title: const Text('Registrar usuarios'),
              onTap: () {
                final route = MaterialPageRoute(
                    builder: (context) => const RegistrarUsuario());
                Navigator.push(context, route);
              },
              // trailing: Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 255, 50, 0)),
            ),
          ),
          Card(
            elevation: 10,
            color: const Color.fromARGB(255, 43, 205, 220),
            child: ListTile(
              leading: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 100, 0, 0)),
              title: const Text('Salir'),
              onTap: () {
                final route =
                    MaterialPageRoute(builder: (context) => const Login());
                Navigator.push(context, route);
              },
            ),
          ),
        ],
      ),
    );
  }
}
