import 'package:easytrip/data/model/user.dart';
import 'package:easytrip/logic/loginbloc/bloc/login_bloc.dart';
import 'package:easytrip/presentation/screens/mainscreen.dart';
import 'package:easytrip/presentation/screens/registrationscreen.dart';
import 'package:easytrip/presentation/widgets/custom_button.dart';
import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginUserFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red.shade800,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
            if (state is LoginUserSuccessfull) {
              final userData = state.data['user'];

              // Check if account is activated
              if (userData['activated'] == 0) {
                // Show message about unactivated account
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.pleaseActivateAccount,
                    ),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );

                // Navigate to activation screen (for now, staying on login)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                // Account is activated, proceed with normal login - Navigate to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              }
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.hourglass_empty,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeBack,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.logInToContinue,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: emailController,
                          labelText: l10n.emailAddress,
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          //textColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterEmail;
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return l10n.pleaseEnterValidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: passwordController,
                          labelText: l10n.password,
                          prefixIcon: Icons.lock,
                          // textColor: Colors.white,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              // color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.pleaseEnterPassword;
                            }
                            if (value.length < 8) {
                              return l10n.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigate to Forgot Password Screen
                            },
                            child: Text(
                              l10n.forgotPasswordLink,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          onPressed: state is LogingUser
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    final user = User(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      remember_me: false,
                                    );
                                    context.read<LoginBloc>().add(
                                      LoginUser(user: user),
                                    );
                                  }
                                },
                          child: state is LogingUser
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  l10n.signIn,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.dontHaveAccount,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                l10n.signUpButton,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
