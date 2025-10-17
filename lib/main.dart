import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/auth_screens.dart';
import 'features/shell/app_shell.dart';
import 'theme/app_theme_light.dart';
import 'theme/app_theme_dark.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final auth = ref.watch(authControllerProvider);

    print('Main.dart - Auth state: user=${auth.user?.name}, isLoading=${auth.isLoading}, error=${auth.error}');

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Kacha Demo',
        theme: buildLightTheme(),
        debugShowCheckedModeBanner: false,
        darkTheme: buildDarkTheme(),
        themeMode: themeMode,
        home: auth.user == null ? const LoginScreen() : const AppShell(),
      ),
    );
  }
}

// Removed default counter page in favor of AppShell
