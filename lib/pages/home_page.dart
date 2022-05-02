import 'dart:convert';

import 'package:flutter/material.dart';


import 'estudiante.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Map _estudiantes = {};
  
  List<Info> salida =[];
  

@override
void initState(){
  super.initState();
  WidgetsBinding.instance!.addPostFrameCallback((_) => readJson(context));
}

Future<void> readJson(BuildContext context) async {
    final lectura= await http.get(Uri.parse('https://primer-rest-api-b854a-default-rtdb.firebaseio.com/Info.json'));
    final infoSalida = await json.decode(lectura.body);
    setState(() {
      _estudiantes = infoSalida;
      for(var i=1;i<=_estudiantes.length;i++){
         salida.add(Info(matricula: _estudiantes["ESTUDIANTE-$i"]["Matricula"], 
         nombre: _estudiantes["ESTUDIANTE-$i"]["Nombre"], 
         carrera: _estudiantes["ESTUDIANTE-$i"]["Carrera"], 
         semestre: _estudiantes["ESTUDIANTE-$i"]["Semestre"], 
         telefono: _estudiantes["ESTUDIANTE-$i"]["Telefono"], 
         correo: _estudiantes["ESTUDIANTE-$i"]["Correo"]));
      }
      
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Estudiantes'),
        backgroundColor: const Color.fromARGB(255, 6, 168, 160),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/fondo1.jpg'), fit: BoxFit.cover)),
          ),
          ListView.builder(
              itemCount: _estudiantes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Estudiante(
                                salida[index].matricula,
                                salida[index].nombre,
                                salida[index].carrera,
                                salida[index].semestre,
                                salida[index].telefono,
                                salida[index].correo



                              )),
                    );
                  },
                  title: Text(
                    salida[index].nombre,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    salida[index].carrera,
                    style: const TextStyle(color: Colors.white),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 53, 236, 206),
                    child: Text(
                      salida[index].nombre.substring(0, 1),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_right_outlined),
                );
              })
        ],
      ),
    );
  }
}

class Info {
  String matricula;
  String nombre;
  String carrera;
  String semestre;
  String telefono;
  String correo;
   Info({
    required this.matricula,
    required this.nombre,
    required this.carrera,
    required this.semestre,
    required this.telefono,
    required this.correo,
  });
  
}
