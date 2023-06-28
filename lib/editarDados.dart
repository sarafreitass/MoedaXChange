import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//Sara Freitas 254358
//João Quessada 237885

class editarDados extends StatefulWidget {
  @override
  State<editarDados> createState() => _editarDadosState();
}

class _editarDadosState extends State<editarDados> {
  //vars e funçoes para o storage
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  bool uploading = false;
  double total = 0;
  int lastIndex = 0; // Índice da última imagem

  //pegar imagens da galeria do usuario
  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  //subir imagens da galeria
  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpeg';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              contentType: "image/jpeg",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  //pegar imagem do storage e printar na tela em forma de lista
  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);

          setState(() => uploading = false);

          loadImages();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

//carregar imagem na tela
  loadImages() async {
    // if (arquivos.isEmpty) {
    refs = (await storage.ref('images').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    // prefs.setStringList('images', arquivos);
    // }
    setState(() {
      loading = false;
      lastIndex = arquivos.length - 1; // Atualiza o índice da última imagem
    });
  }

//deletar imagem
  deleteImage(int index) async {
    await storage.ref(refs[index].fullPath).delete();
    refs.removeAt(index);
    arquivos.removeAt(index);
    setState(() {
      lastIndex = arquivos.length - 1; // Atualiza o índice da última imagem
    });
    loadImages();
  }

//vars do hive, configurações da tela e vars de edição de dados

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final _caixa = Hive.box("box");
  String titulo = 'Editar Dados';

//função para editar dados

  atualizarDados() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().atualizarDados(email.text, senha.text);
      await context.read<AuthService>();
      //.logout(); // Desloga o usuário para que as alterações sejam aplicadas
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.messagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    //define as dimensões e condições da foto de perfil
    Widget imageWidget;
    if (arquivos.isNotEmpty && lastIndex >= 0) {
      imageWidget = ClipOval(
        child: Image(
          image: CachedNetworkImageProvider(arquivos[lastIndex]),
          fit: BoxFit.cover,
          width: 100,
          height: 100,
        ),
      );
    } else {
      imageWidget = const ClipOval(
        child: Icon(
          Icons.person,
          size: 100,
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: const Text('Editar dados'),
      ),
      backgroundColor: Color(0xFF84A98C),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: 70,
                  height: 70,
                  child: Image.asset('lib/assets/moeda.png'),
                ),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload),
                      onPressed: pickAndUploadImage,
                    ),
                    /* ClipOval(
                      child: Image(
                        image: CachedNetworkImageProvider(arquivos[lastIndex]),
                        fit: BoxFit.cover,
                        width: 100, // Defina o tamanho desejado
                        height: 100, // Defina o tamanho desejado
                      ),
                    ),*/
                    imageWidget,
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteImage(lastIndex);
                          loadImages();
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                    controller: senha,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informa sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      atualizarDados();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ]
                          : [
                              const Icon(Icons.check),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Atualizar dados',
                                  style: const TextStyle(fontSize: 20),
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
      ),
    );
  }
}
