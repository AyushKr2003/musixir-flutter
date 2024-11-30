import 'package:client/core/theme/app_pallet.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ConsumerStatefulWidget is Riverpod's version of StatefulWidget
// It provides access to ref which allows us to interact with providers
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

// ConsumerState is Riverpod's version of State
// It gives us access to ref throughout the widget's lifecycle
class _SignupPageState extends ConsumerState<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch() subscribes to the authViewModelProvider
    // Rebuilds the widget whenever the provider's state changes
    // isLoading checks if the AsyncValue is in loading state
    final isLoading = ref.watch(authViewModelProvider.select((val)=> val?.isLoading == true));

    // ref.listen() is used to perform side effects when the provider changes
    // Unlike watch, listen doesn't cause rebuilds
    ref.listen(
      authViewModelProvider,
      // Previous and next state are provided to the listener
      (_, next) {
        // next?.when() handles all possible states of AsyncValue
        next?.when(
          // Called when the Future completes successfully with data
          data: (data) {
            Fluttertoast.showToast(msg: 'Account Created Successfully. Please login!', timeInSecForIosWeb: 5);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          // Called when the Future completes with an error
          error: (error, st) {
            Fluttertoast.showToast(msg: error.toString());
          },
          // Called while the Future is in progress
          loading: () {},
        );
      },
    );
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      CustomField(
                        hintText: 'Name',
                        textEditingController: nameController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: 'Email',
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        hintText: 'Password',
                        textEditingController: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                        buttonText: "Sign Up",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            // ref.read() is used to read the provider once without subscribing
                            // .notifier gives us access to the provider's methods
                            // This is used for triggering actions rather than reading state
                            ref.read(authViewModelProvider.notifier).signUpUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: const [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Pallet.gradient2),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
