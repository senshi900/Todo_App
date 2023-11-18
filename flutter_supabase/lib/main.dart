import 'package:flutter/material.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:flutter_supabase/pages/home_page.dart';
import 'package:flutter_supabase/pages/start_page.dart';
import "package:supabase_flutter/supabase_flutter.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Load env
  await dotenv.load();
  // Initialize Supabase
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl,anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthPage()
    );
  }
}


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    _getAuth();
    super.initState();
    
  }

  // To get current user : supabase.auth.currentUser

  Future<void> _getAuth()async{
      setState(() {
        _user = supabase.auth.currentUser;
      });
      supabase.auth.onAuthStateChange.listen((event){
        setState(() {
          _user = event.session?.user;
        });
      });
  }
  
  @override
  Widget build(BuildContext context) {
    //  return _user == null ? const StartPage() : HomePage();
    return HomePage();
  }
}
