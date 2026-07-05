import 'package:flutter/material.dart';
import 'screens/inquiry_form_page.dart';

/// FILE CONTOH: Ini adalah contoh implementasi halaman form pengaduan
/// Gunakan salah satu dari 3 contoh di bawah sesuai kebutuhan Anda

/// ============================================================================
/// CONTOH 1: Simple Implementation (Recommended untuk Mulai)
/// ============================================================================
void exampleSimple() {
  runApp(const SimpleExample());
}

class SimpleExample extends StatelessWidget {
  const SimpleExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSpace Support - Simple',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SimpleHomePage(),
    );
  }
}

class SimpleHomePage extends StatelessWidget {
  const SimpleHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy token - ganti dengan token asli dari login
    const String dummyToken =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNjIwMDAwMDAwLCJleHAiOjE2MjAwMDM2MDAsIm5iZiI6MTYyMDAwMDAwMCwianRpIjoibnp4cFhR';

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSpace Support'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.support_agent,
                size: 80,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 20),
              const Text(
                'Layanan Pengaduan WebSpace',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Kami siap membantu Anda 24/7',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InquiryFormPage(token: dummyToken),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Buat Pengaduan Baru'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navigate to history page
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Halaman riwayat belum diimplementasi'),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Lihat Riwayat Pengaduan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// CONTOH 2: Dengan Dummy Login (Untuk Testing)
/// ============================================================================
void exampleWithLogin() {
  runApp(const LoginExample());
}

class LoginExample extends StatelessWidget {
  const LoginExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSpace Support - With Login',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'user@webspace.test');
  final passwordController = TextEditingController(text: 'password');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - WebSpace Support')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 80,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Dummy login - langsung navigasi
                  const String dummyToken =
                      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNjIwMDAwMDAwLCJleHAiOjE2MjAwMDM2MDAsIm5iZiI6MTYyMDAwMDAwMCwianRpIjoibnp4cFhR';

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePageWithLogin(
                        token: dummyToken,
                      ),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Demo credentials: user@webspace.test / password',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePageWithLogin extends StatelessWidget {
  final String token;

  const HomePageWithLogin({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade400),
              child: const Text(
                'WebSpace Support',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Buat Pengaduan'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiryFormPage(token: token),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur belum tersedia')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Selamat Datang!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InquiryFormPage(token: token),
                  ),
                );
              },
              child: const Text('Buat Pengaduan'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// CONTOH 3: Dengan Named Routes (Best Practice untuk App Besar)
/// ============================================================================
void exampleWithNamedRoutes() {
  runApp(const NamedRoutesExample());
}

class NamedRoutesExample extends StatelessWidget {
  const NamedRoutesExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume token disimpan di app state / provider
    const String dummyToken =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNjIwMDAwMDAwLCJleHAiOjE2MjAwMDM2MDAsIm5iZiI6MTYyMDAwMDAwMCwianRpIjoibnp4cFhR';

    return MaterialApp(
      title: 'WebSpace Support - Routes',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoutesHomePage(),
        '/inquiry-form': (context) => const InquiryFormPage(
          token: dummyToken,
        ),
      },
    );
  }
}

class RoutesHomePage extends StatelessWidget {
  const RoutesHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSpace Support')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/inquiry-form'),
              child: const Text('Buat Pengaduan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Halaman lainnya')),
                );
              },
              child: const Text('Halaman Lainnya'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// MAIN - Pilih Contoh Mana yang Ingin Dijalankan
/// ============================================================================

void main() {
  // Pilih salah satu:
  exampleSimple(); // ← Uncomment ini untuk menjalankan Simple Example
  // exampleWithLogin(); // ← Atau uncomment ini untuk With Login
  // exampleWithNamedRoutes(); // ← Atau uncomment ini untuk Named Routes
}
