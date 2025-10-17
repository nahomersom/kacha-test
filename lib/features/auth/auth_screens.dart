import 'package:cacha_test/features/auth/screens/register_screen.dart';
import 'package:cacha_test/shared/widgets/app_button.dart';
import 'package:cacha_test/shared/widgets/app_text_field.dart';
import 'package:cacha_test/shared/widgets/logo_container.dart';
import 'package:cacha_test/theme/colors.dart';
import 'package:cacha_test/theme/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    
    // Listen for login success and errors
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.user == null && next.user != null && !next.isLoading) {
        // User successfully logged in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${next.user?.name ?? 'User'}!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        // Navigate to dashboard after showing toast
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            // Force navigation by popping current screen and letting main.dart handle it
            Navigator.of(context).pop();
          }
        });
      } else if (next.error != null && !next.isLoading) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: AppSizes.xl.h,),
                LogoContainer(),
                
                SizedBox(height: AppSizes.xxl.h,),
     
                Text('Welcome Back,👋', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: AppSizes.lg.h,),
                AppTextField(
                  controller: _emailController,
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  hintText: 'Email',
                ),
                SizedBox(height: AppSizes.md.h,),

                AppTextField(
                  controller: _passwordController,
                  obscureText: true,
                    hintText: 'Password',
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                if (auth.error != null) Text(auth.error!, style: const TextStyle(color: Colors.red)),
                                SizedBox(height: AppSizes.xxl.h,),

                AppButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          await ref.read(authControllerProvider.notifier).login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        },
                  child: auth.isLoading ? const CircularProgressIndicator(color: AppColors.white,) :  Text('Login',style: Theme.of(context).textTheme.headlineSmall,),
                ),
                                SizedBox(height: AppSizes.lg.h,),

               RichText(
  text: TextSpan(
    text: 'Don\'t have an account? ',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
        ),
    children: [
      TextSpan(
        text: 'Register here',
        style: const TextStyle(
          color: Colors.blue, // clickable color
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
      ),
    ],
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



