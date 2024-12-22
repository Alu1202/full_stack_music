import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kpi_demo/authentication/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  String? emailError;
  final TextEditingController passwordController = TextEditingController();
  String? passwordError;

  void login() {
    final email = emailController.text;
    final password = passwordController.text;

    emailError = _validateEmail(email);
    passwordError = _validatePassword(password);

    if (emailError == null && passwordError == null) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(error: "Invalid input"));
    }
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Invalid email format";
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
