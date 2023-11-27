// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:consumir/listarClientes.dart';
import 'package:consumir/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrarUsuario extends StatefulWidget {
  const RegistrarUsuario({super.key});

  @override
  _RegistrarUsuario createState() => _RegistrarUsuario();
}

class _RegistrarUsuario extends State<RegistrarUsuario> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nomUsuario = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController secPass = TextEditingController();

  RegExp valEmail = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
  RegExp valPass = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  RegExp valCelular = RegExp(r'^\d{10}$');

  // ignore: prefer_final_fields
  bool _obscureText = true;

  Future<void> _insertarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (nomUsuario.text.length < 5 ||
          nomUsuario.text.length > 20 && nombre.text.length < 3 ||
          nombre.text.length > 25 && apellidos.text.length < 3 ||
          apellidos.text.length > 25 && correo.text.length < 12 ||
          correo.text.length > 40 && celular.text.length < 12 ||
          celular.text.length > 40 && pass.text.length < 12 ||
          pass.text.length > 40) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con los datos ingresado.'),
              content: const Text('Revise los datos ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (nomUsuario.text.length < 5 || nomUsuario.text.length > 20) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con el nombre de usuario.'),
              content: const Text('Revise el nombre de usuario ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (nombre.text.length < 3 || nombre.text.length > 25) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con el nombre.'),
              content: const Text('Revise el nombre ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (apellidos.text.length < 3 || apellidos.text.length > 25) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con los apellidos.'),
              content: const Text('Revise los apellidos ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (correo.text.length < 12 ||
          correo.text.length > 40 ||
          !valEmail.hasMatch(correo.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con el correo.'),
              content: const Text('Revise el correo ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (celular.text.length != 10 ||
          !valCelular.hasMatch(celular.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con el celular.'),
              content: const Text('Revise el celular ingresado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (pass.text.length < 8 ||
          pass.text.length > 25 ||
          !valPass.hasMatch(pass.text)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error con la contraseña.'),
              content: const Text('Revise la contraseña ingresada.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (secPass.text != pass.text) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error las contraseñas deben ser iguales!'),
              content: const Text('Revise las contraseñas ingresadas.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Cerrar el mensaje emergente al hacer clic en el botón
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        final url = Uri.parse('https://api-warrior.onrender.com/api/cliente');

        // Datos que quieres enviar al servidor
        final Map<String, dynamic> data = {
          'nombreUsu': nomUsuario.text,
          'nombre': nombre.text,
          'apellidos': apellidos.text,
          'correo': correo.text,
          'celular': celular.text,
          'rol': "Cliente",
          'password': pass.text,
        };

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrado...')),
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ListaUsuarios()));
          nomUsuario.clear();
          nombre.clear();
          apellidos.clear();
          correo.clear();
          celular.clear();
          pass.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error al registrar el usuario. Código de error: ${response.statusCode}')),
          );
        }
      }
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            color: const Color.fromARGB(255, 43, 205, 220),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextFormField(
                        controller: nomUsuario,
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        decoration: InputDecoration(
                          labelText: 'Nombre de usuario',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          icon: const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'El nombre de usuario debe ser entre 5 y 20 caracteres.',
                          counterText: '${nomUsuario.text.length}/20',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un usuario!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: nombre,
                        keyboardType: TextInputType.name,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'nombre',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          icon: const Icon(
                            Icons.photo_camera_front_rounded,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'El nombre de debe ser entre 3 y 25 caracteres.',
                          counterText: '${nombre.text.length}/25',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un nombre!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: apellidos,
                        keyboardType: TextInputType.name,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'Apellido',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          icon: const Icon(
                            Icons.photo_camera_front_rounded,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'El apellido debe ser entre 3 y 25 letras.',
                          counterText: '${apellidos.text.length}/25',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un apellido!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: correo,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 40,
                        decoration: InputDecoration(
                          labelText: 'correo',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          icon: const Icon(
                            Icons.mail,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'El correo debe ser entre 12 y 40 caracteres.',
                          counterText: '${correo.text.length}/40',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un correo!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: celular,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: 'Celular',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          icon: const Icon(
                            Icons.phone_android,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'El número de celular debe ser de 10 números.',
                          counterText: '${celular.text.length}/10',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su número de celular!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: pass,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: const Color.fromARGB(255, 100, 0, 0),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          icon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText:
                              'La contraseña debe ser entre 8 y 25 caracteres.',
                          counterText: '${pass.text.length}/25',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese una contraseña!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        controller: secPass,
                        obscureText: _obscureText,
                        keyboardType: TextInputType.visiblePassword,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: const Color.fromARGB(255, 100, 0, 0),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          icon: const Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 100, 0, 0),
                          ),
                          helperText: 'Repita la contraseña.',
                          counterText: '${secPass.text.length}/25',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese una contraseña!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: _insertarUsuario,
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(255, 100, 0, 0))),
                        child: const Text('Registrar Usuario'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
