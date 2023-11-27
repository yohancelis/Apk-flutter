// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:consumir/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  List<dynamic> data = []; //Para almacenar los datos obtenidos de la api.
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomUsuario = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool valIngreso = false;
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    _logeo();
  }

  Future<void> _logeo() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http
          .get(Uri.parse('https://api-warrior.onrender.com/api/cliente'));

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedData = json.decode(response.body);
        setState(
          () {
            data = decodedData['clientes'] ?? [];
          },
        );
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al ingresar...')),
          );
        });
      }
      for (var i = 0; i < data.length; i++) {
        if (data[i]['nombreUsu'] == nomUsuario.text &&
            data[i]['password'] == pass.text) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const Menu()),
            ),
          );
          nomUsuario.clear();
          pass.clear();
          valIngreso = true;
          break;
        } else {
          valIngreso = false;
        }
      }
      if (valIngreso) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ingresando...')),
          );
        });
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al ingresar...')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 255, 100, 40),
      //   title: const Text('Registro de usuarios'),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 10,
                  color: Color.fromARGB(255, 164, 231, 240),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 10),
                        child: Image.asset(
                          'assets/logo-twbs-negro.png', // Reemplaza con la URL de tu imagen
                          fit: BoxFit
                              .cover, // Ajusta la imagen al tamaño del Card
                              width: 500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  controller: nomUsuario,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    labelText: 'Usuario',
                                    floatingLabelStyle: TextStyle(
                                        color: Color.fromARGB(255, 43, 205, 220)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 43, 205, 220))),
                                    icon: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 100, 0, 0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingrese un usuario!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  controller: pass,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      color:
                                          Color.fromARGB(255, 100, 0, 0),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    floatingLabelStyle: const TextStyle(
                                        color: Color.fromARGB(255, 43, 205, 220)),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 43, 205, 220))),
                                    icon: const Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(255, 100, 0, 0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingrese una contraseña!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ElevatedButton(
                                  onPressed: _logeo,
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 100, 0, 0),
                                    ),
                                  ),
                                  child: const Text('Ingresar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
