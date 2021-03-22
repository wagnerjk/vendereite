import 'package:app_vendas/services/AuthenticationProvider.dart';
import 'package:app_vendas/views/Home.dart';
import 'file:///D:/Projetos/Flutter/Meus_projetos/app_vendas/lib/views/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vendereite',
        //themeMode: ThemeMode.dark,
        //darkTheme: ThemeData(brightness: Brightness.dark),
        theme: ThemeData(
          //brightness: Brightness.light,
          primaryColor: Colors.indigo,
          textTheme: GoogleFonts.varelaTextTheme(
            Theme.of(context).textTheme,
          )
        ),
        home: Authenticate(),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if(firebaseUser != null){
      return Home();
    } else {
      return SignIn();
    }
  }
}
