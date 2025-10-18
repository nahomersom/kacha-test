import 'package:cacha_test/features/auth/views/loginView.dart';
import 'package:cacha_test/shared/widgets/app_button.dart';
import 'package:cacha_test/shared/widgets/app_text_field.dart';
import 'package:cacha_test/shared/widgets/logo_container.dart';
import 'package:cacha_test/theme/colors.dart';
import 'package:cacha_test/theme/sizes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/auth_controller.dart';
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    
    // Listen for registration success and errors
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (previous?.user == null && next.user != null && !next.isLoading) {
        // User successfully registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully registered! Welcome to the app!'),
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
     
                Text('Register to get started', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: AppSizes.lg.h,),
                AppTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                SizedBox(height: AppSizes.md.h,),

                AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                ),
                SizedBox(height: AppSizes.md.h,),

                AppTextField(
                  controller: _passwordController,
                  obscureText: true,
                  hintText: 'Password', 
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    return null; // Let strength indicator handle password requirements
                  },
                ),
                // Password strength indicator
                const SizedBox(height: 8),
                _PasswordStrengthIndicator(controller: _passwordController),
                SizedBox(height: AppSizes.md.h,),

                AppTextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  hintText: 'Confirm Password', 
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (auth.error != null) Text(auth.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                AppButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          await ref.read(authControllerProvider.notifier).register(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        },
                  child: auth.isLoading ? const CircularProgressIndicator(color: AppColors.white,) :  Text('Register',style: Theme.of(context).textTheme.headlineSmall,),
                ),
                SizedBox(height: AppSizes.lg.h,),

               RichText(
  text: TextSpan(
    text: 'Already have an account? ',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
        ),
    children: [
      TextSpan(
        text: 'Login here',
        style: const TextStyle(
          color: Colors.blue, // clickable color
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
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

class _PasswordStrengthIndicator extends StatefulWidget {
  final TextEditingController controller;
  
  const _PasswordStrengthIndicator({required this.controller});
  
  @override
  State<_PasswordStrengthIndicator> createState() => _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<_PasswordStrengthIndicator> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPasswordChanged);
  }
  
  @override
  void dispose() {
    widget.controller.removeListener(_onPasswordChanged);
    super.dispose();
  }
  
  void _onPasswordChanged() {
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    final password = widget.controller.text;
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final strength = _calculateStrength(password);
    final color = _getStrengthColor(strength);
    final label = _getStrengthLabel(strength);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength / 4,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Length: ${password.length} characters',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }
  
  int _calculateStrength(String password) {
    if (password.length < 6) return 0;
    
    int strength = 1; // Base strength for 6+ characters
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    return strength.clamp(0, 4);
  }
  
  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  String _getStrengthLabel(int strength) {
    switch (strength) {
      case 0:
        return 'Too Short';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Very Weak';
    }
  }
}

