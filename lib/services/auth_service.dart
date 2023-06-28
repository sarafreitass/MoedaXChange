import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//cria-se um serviço de autenticação, que se estende no ChangeNotifier para
//notificar todas a telas se houve uma mudança de notificação

class AuthException implements Exception {
  String messagem;
  AuthException(this.messagem);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false; //pois já carregou a tela do usuário
      notifyListeners(); //falar pra todo mundo que está usando esses dados que eles mudaram
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  registrar(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('Senha fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Email já cadastrado');
      }
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Email não cadastrado no sistema');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  Future<void> atualizarDados(String newEmail, String newPassword) async {
    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        await currentUser.updateEmail(newEmail);
        await currentUser.updatePassword(newPassword);
        await _getUser(); // Aguarde a conclusão da atualização antes de chamar _getUser()
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException('Não foi possível atualizar as informações');
    }
  }
}
