/*import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class editarDados extends StatefulWidget {
  const editarDados({Key? key}) : super(key: key);

  @override
  _editarDadosState createState() => _editarDadosState();
}

class _editarDadosState extends State<editarDados> {
  //vars e funçoes parea o storage
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  bool uploading = false;
  double total = 0;
  //pegar imagens da galeria
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

          // final newMetadata = SettableMetadata(
          //   cacheControl: "public, max-age=300",
          //   contentType: "image/jpeg",
          // );
          // await photoRef.updateMetadata(newMetadata);

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);
          // final SharedPreferences prefs = await _prefs;
          // prefs.setStringList('images', arquivos);

          setState(() => uploading = false);
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
    // final SharedPreferences prefs = await _prefs;
    // arquivos = prefs.getStringList('images') ?? [];

    // if (arquivos.isEmpty) {
    refs = (await storage.ref('images').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    // prefs.setStringList('images', arquivos);
    // }
    setState(() => loading = false);
  }

//deletar imagem
  deleteImage(int index) async {
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
    setState(() {});
  }

//vars do hive e configurações da tela

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final _caixa = Hive.box("box");
  String titulo = 'Editar Dados';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF84A98C),
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: uploading
            ? Text('${total.round()}% enviado')
            : const Text('Editar Dados'),
        actions: [
          uploading
              ? const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: pickAndUploadImage,
                )
        ],
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: arquivos.isEmpty
                  ? const Center(child: Text('Não há imagens ainda.'))
                  : ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 40,
                            child: Image(
                              image:
                                  CachedNetworkImageProvider(arquivos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text('Image $index'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => deleteImage(index),
                          ),
                        );
                      },
                      itemCount: arquivos.length,
                    ),
            ),
    );
  }
}*/
