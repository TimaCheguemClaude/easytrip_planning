import 'package:easytrip/data/model/mainuser.dart';
import 'package:easytrip/logic/loginbloc/bloc/login_bloc.dart';
import 'package:easytrip/presentation/screens/loginscreen.dart';
import 'package:easytrip/presentation/widgets/custom_button.dart';
import 'package:easytrip/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easytrip/l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  String? _userType;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _contactController.dispose();
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
            if (state is RegistrationFailure) {
              String errorMessage = state.error;
              if (state.error.contains('Exception:')) {
                errorMessage = state.error.split('Exception:')[1].trim();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red.shade800,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  action: SnackBarAction(
                    label: 'DISMISS',
                    //: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // App Logo/Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.person_add,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.createAccount,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Form Fields
                      CustomTextField(
                        controller: _nameController,
                        labelText: l10n.fullName,
                        prefixIcon: Icons.person,
                        // textColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _emailController,
                        labelText: l10n.emailAddress,
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        // textColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterEmail;
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return l10n.pleaseEnterValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: l10n.password,
                        prefixIcon: Icons.lock,
                        //  textColor: Colors.white,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterPassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: l10n.confirmPassword,
                        prefixIcon: Icons.lock,
                        //  textColor: Colors.white,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseConfirmPassword;
                          }
                          if (value != _passwordController.text) {
                            return l10n.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _addressController,
                        labelText: l10n.address,
                        prefixIcon: Icons.home,
                        // textColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterAddress;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _contactController,
                        labelText: l10n.phoneNumber,
                        prefixIcon: Icons.phone,
                        //  textColor: Colors.white,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Register Button
                      CustomButton(
                        onPressed: state is RegisteringUser
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final character = Character(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    password_confirmation:
                                        _confirmPasswordController.text,
                                    address: _addressController.text,
                                    contact: _contactController.text,
                                    type_user_id: int.parse(_userType ?? '1'),
                                  );
                                  context.read<LoginBloc>().add(
                                    RegisterUser(character: character),
                                  );
                                }
                              },
                        child: state is RegisteringUser
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.deepOrange,
                                ),
                              )
                            : Text(
                                l10n.createAccount,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.alreadyHaveAccount,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              l10n.signIn,
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
            );
          },
        ),
      ),
    );
  }
}
