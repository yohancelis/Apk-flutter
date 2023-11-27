// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:consumir/listarClientes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Editar extends StatefulWidget {
  final String texto;
  const Editar(
    this.texto, {
    super.key,
  });

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  List<dynamic> data = [];
  List<dynamic> filteredData = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomUsuario = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController celular = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController secPass = TextEditingController();

  // ignore: prefer_final_fields
  bool _obscureText = true;

  final List<String> listRol = ['Seleccione una opción'];
  String seleccion = 'Seleccione una opción';

  RegExp valEmail = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
  RegExp valPass = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
  RegExp valCelular = RegExp(r'^\d{10}$');

  bool valIngreso = false;

  @override
  void initState() {
    super.initState();
    nomUsuario.text = widget.texto;
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

      for (var i = 0; i < data.length; i++) {
        if (data[i]['nombreUsu'] == nomUsuario.text) {
          nombre.text = data[i]['nombre'];
          apellidos.text = data[i]['apellidos'];
          correo.text = data[i]['correo'];
          celular.text = data[i]['celular'];
          pass.text = data[i]['password'];
          valIngreso = true;
          break;
        } else {
          valIngreso = false;
        }
      }
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los datos...')),
        );
      });
    }
  }

  Future<void> _modificarUsuario(String nom, String ape, String ema,
      String cel, String pas) async {
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
              content: const Text('Revise la contraseña ingresado.'),
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
        final Map<String, dynamic> data = {
          'nombreUsu': nomUsuario.text,
          'nombre': nom,
          'apellidos': ape,
          'correo': ema,
          'celular': cel,
          'password': pas,
        };

        final response = await http.put(
          Uri.parse('https://api-warrior.onrender.com/api/cliente'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario modificado...')),
          );
          // const CircularProgressIndicator();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ListaUsuarios()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al modificar el usuario...')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            color: Color.fromARGB(255, 43, 205, 220),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nomUsuario,
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: InputBorder.none,
                        floatingLabelStyle: const TextStyle(
                            color: Color.fromARGB(255, 100, 0, 0)),
                        icon: const Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 100, 0, 0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          value = widget.texto;
                          return 'Ingrese un usuario!';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.only(bottom: 5),
                    //     child: Column(
                    //       children: [
                    //         const Text('Seleccione una opción: '),
                    //         DropdownButton<String>(
                    //             value: seleccion,
                    //             items: listRol.map((String opcion) {
                    //               return DropdownMenuItem<String>(
                    //                 value: opcion,
                    //                 child: Text(opcion),
                    //               );
                    //             }).toList(),
                    //             onChanged: (String? newValue) {
                    //               if (newValue != null) {
                    //                 setState(() {
                    //                   seleccion = newValue;
                    //                 });
                    //               }
                    //             }),
                    //       ],
                    //     )),
                    TextFormField(
                      controller: nombre,
                      keyboardType: TextInputType.name,
                      readOnly: true,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        labelText: 'nombre',
                        border: InputBorder.none,
                        floatingLabelStyle: const TextStyle(
                            color: Color.fromARGB(255, 100, 0, 0)),
                        icon: const Icon(
                          Icons.photo_camera_front_rounded,
                          color: Color.fromARGB(255, 100, 0, 0),
                        ),
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
                    TextFormField(
                      controller: apellidos,
                      keyboardType: TextInputType.name,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        border: InputBorder.none,
                        floatingLabelStyle:
                            TextStyle(color: Color.fromARGB(255, 100, 0, 0)),
                        icon: Icon(
                          Icons.photo_camera_front_rounded,
                          color: Color.fromARGB(255, 100, 0, 0),
                        ),
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
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 100, 0, 0))),
                          floatingLabelStyle: const TextStyle(
                              color: Color.fromARGB(255, 100, 0, 0)),
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _modificarUsuario(
                                            nombre.text,
                                            apellidos.text,
                                            correo.text,
                                            celular.text,
                                            pass.text);
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color.fromARGB(
                                                      255, 100, 0, 0))),
                                      child: const Text('Modificar usuario'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
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
                        )),
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
