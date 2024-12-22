import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.of(context).pushReplacementNamed('/kpi');
                      }
                    },
                    builder: (context, state) {
                      return _buildLoginForm(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();

    return Column(
      children: [
        TextField(
          controller: loginCubit.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: loginCubit.emailError,
          ),
        ),
        TextField(
          controller: loginCubit.passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: loginCubit.passwordError,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            loginCubit.login();
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () {
          },
          child: const Text("Dont have an account? Create one...!"),
        ),
      ],
    );
  }
}
