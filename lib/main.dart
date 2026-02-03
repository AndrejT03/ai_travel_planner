import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'core/router.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'services/plans_repository.dart';
import 'services/templates_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accentBlue = Color(0xFF66B7FF);

    return p.MultiProvider(
      providers: [
        p.Provider<AuthService>(create: (_) => AuthService()),
        p.Provider<PlansRepository>(create: (_) => PlansRepository()),
        p.Provider<TemplatesRepository>(create: (_) => TemplatesRepository()),
        p.ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(ctx.read<AuthService>()),
        ),
      ],
      child: p.Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'AI Travel Planner',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black.withOpacity(0.65),
                elevation: 0,
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                elevation: 0,
                indicatorColor: accentBlue.withOpacity(0.22),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(MaterialState.selected);
                  return TextStyle(
                    color: isSelected ? accentBlue : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  );
                }),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  final isSelected = states.contains(WidgetState.selected);
                  return IconThemeData(
                    color: isSelected ? accentBlue : Colors.white70,
                  );
                }),
              ),
            ),
            routerConfig: createRouter(auth),
          );
        },
      ),
    );
  }
}