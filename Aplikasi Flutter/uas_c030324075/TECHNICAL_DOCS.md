# 🔧 WebSpace Support - Dokumentasi Teknis

Dokumentasi untuk developer yang ingin memahami atau memodifikasi aplikasi Flutter WebSpace Support.

## 📚 Struktur Data Model

### User Model
```dart
class User {
  final int id;
  final String name;
  final String email;
  final String role;  // 'user' atau 'admin'
}
```

### Category Model
```dart
class Category {
  final int id;
  final String name;
  final String slug;
}
```

### Inquiry Model (Tiket Support)
```dart
class Inquiry {
  final int id;
  final int userId;
  final int categoryId;
  final String nama;
  final String email;
  final String website;
  final String telp;
  final String pesan;
  final String status;  // 'open', 'in_progress', 'closed'
  final Category category;
  final User? user;
  final List<Reply>? replies;
}
```

### Reply Model
```dart
class Reply {
  final int id;
  final int inquiryId;
  final int userId;
  final String message;
  final User user;
}
```

## 🔌 API Service Architecture

### Singleton Pattern
```dart
class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();
}
```

### Token Management
```dart
// Simpan token
await ApiService().setToken(token);

// Ambil token
final token = await ApiService().getToken();

// Hapus token
await ApiService().clearToken();
```

### Error Handling Strategy

1. **Try-Catch** untuk network errors
2. **Status Code Check** untuk HTTP errors
3. **Response Parsing** untuk API errors
4. **User-Friendly Messages** di UI

## 🔄 State Management Flow

### Authentication Flow
```
Splash Screen
    ↓
Check Token (SharedPreferences)
    ↓
   ┌─────────────────┬─────────────────┐
   ↓                 ↓
Has Token?       No Token?
   ↓                 ↓
Home Screen      Login Screen
                      ↓
                  Register/Login
                      ↓
                   Token Saved
                      ↓
                  Home Screen
```

### Inquiry Management Flow
```
Home Screen
    ↓
┌───┴───┐
↓       ↓
My      Create New
Tickets Ticket
↓       ↓
List    Form
  ↓       ↓
  └─→ Detail Screen ←─┘
        ↓
    View/Reply
```

## 📧 API Endpoints & Usage

### 1. Register
```dart
final response = await apiService.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);

if (response.status) {
  // Success - Token sudah disimpan otomatis
  // Navigate ke Home
}
```

### 2. Login
```dart
final response = await apiService.login(
  email: 'user@webspace.test',
  password: 'password',
);

if (response.status) {
  // Token disimpan otomatis
  // Navigate ke Home
}
```

### 3. Get Categories
```dart
final categories = await apiService.getCategories();
// Hasil: List<Category>
```

### 4. Create Inquiry
```dart
final response = await apiService.createInquiry(
  categoryId: 3,
  nama: 'User Demo',
  email: 'user@webspace.test',
  website: 'https://example.com',
  telp: '081234567890',
  pesan: 'Saya membutuhkan bantuan teknis...',
);

if (response.status) {
  // Tiket berhasil dibuat
  // response.data berisi Inquiry object
}
```

### 5. Get My Inquiries
```dart
final inquiries = await apiService.getMyInquiries();
// Hasil: List<Inquiry>
```

### 6. Get Inquiry Detail
```dart
final inquiry = await apiService.getInquiryDetail(inquiryId);
// Hasil: Inquiry? (dengan replies)
```

### 7. Send Reply
```dart
final reply = await apiService.sendReply(inquiryId, 'Response message');

if (reply != null) {
  // Reply berhasil dikirim
}
```

## 🎨 Screen Navigation

### Named Routes
```dart
'/': SplashScreen()                    // Initial
'/login': LoginScreen()                // Login page
'/register': RegisterScreen()          // Register page
'/home': HomeScreen()                  // Dashboard
'/inquiry-form': InquiryFormScreen()   // Create ticket
```

### Navigation Examples
```dart
// Push ke halaman baru
Navigator.of(context).pushNamed('/inquiry-form');

// Replace halaman (untuk login/logout)
Navigator.of(context).pushReplacementNamed('/home');

// Pop kembali ke halaman sebelumnya
Navigator.pop(context);

// Pop dengan result
Navigator.pop(context, true);  // Kirim data ke parent
```

## ✅ Validasi Input

### API Service Static Methods
```dart
// Email validation
ApiService.isValidEmail('user@example.com');  // true
ApiService.isValidEmail('invalid');            // false

// URL validation
ApiService.isValidUrl('https://example.com');  // true
ApiService.isValidUrl('not a url');            // false

// Phone number validation
ApiService.isValidPhoneNumber('081234567890');  // true
ApiService.isValidPhoneNumber('081ABC');        // false
```

### Form Validation Pattern
```dart
TextFormField(
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'Field tidak boleh kosong';
    }
    if (!ApiService.isValidEmail(value!)) {
      return 'Format email tidak valid';
    }
    return null;  // Valid
  },
)
```

## 🧩 Custom Widgets

### CustomButton
```dart
CustomButton(
  text: 'Submit',
  onPressed: () {},
  isLoading: false,
  width: double.infinity,
  color: Colors.blue,
  textColor: Colors.white,
)
```

### CustomTextField
```dart
CustomTextField(
  label: 'Email',
  hint: 'Masukkan email Anda',
  controller: emailController,
  prefixIcon: Icons.email,
  keyboardType: TextInputType.emailAddress,
  validator: (value) => /* validation logic */,
)
```

### Dialog Widgets
```dart
// Loading
showDialog(
  context: context,
  builder: (context) => LoadingDialog(message: 'Loading...'),
);

// Error
showDialog(
  context: context,
  builder: (context) => ErrorDialog(
    message: 'Something went wrong!',
    onDismiss: () => Navigator.pop(context),
  ),
);

// Success
showDialog(
  context: context,
  builder: (context) => SuccessDialog(
    message: 'Operation successful!',
    onDismiss: () => Navigator.pop(context),
  ),
);
```

## 🎨 Theme Customization

### Current Theme
```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
)
```

### Mengubah Primary Color
```dart
// Di main.dart, ubah seedColor
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.green,  // Ganti dari Colors.blue
)
```

## 📦 Localization Setup

### Bahasa Indonesia
```dart
void main() {
  Intl.defaultLocale = 'id_ID';  // Set locale ke Indonesia
  runApp(const MyApp());
}
```

### Format Tanggal
```dart
import 'package:intl/intl.dart';

final date = DateTime.now();
final formatted = DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(date);
// Output: 03 Jul 2026 14:30
```

## 🔒 Security Best Practices

### Token Storage
- ✅ Token disimpan di SharedPreferences (ada enkripsi di level OS)
- ✅ Token dikirim via Bearer token di Authorization header
- ✅ Token dihapus saat logout

### API Calls
- ✅ Selalu gunakan HTTPS di production
- ✅ Validate SSL certificates
- ✅ Never log sensitive data (passwords, tokens)

### User Data
- ✅ Validasi input di client side
- ✅ Jangan menyimpan sensitive data di local storage

## 🚨 Error Handling Patterns

### API Error Pattern
```dart
try {
  final response = await apiService.login(...);
  
  if (response.status) {
    // Success
  } else {
    // API returned error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message)),
    );
  }
} catch (e) {
  // Network atau parsing error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
}
```

## 📊 Dependency Management

### pubspec.yaml Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8      # iOS icons
  http: ^1.1.0                 # HTTP client
  shared_preferences: ^2.2.0   # Local storage
  intl: ^0.19.0                # Localization
```

### Menambah Dependency Baru
```bash
flutter pub add package_name
```

## 🔍 Debugging Tips

### Enable Debug Logging
```dart
// Di ApiService, tambahkan logging
print('API Request: $method $url');
print('Headers: $headers');
print('Response: ${response.statusCode} ${response.body}');
```

### Use DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Common Issues
1. **API Connection Failed**: Check backend URL
2. **Token Expired**: Automatic logout & redirect to login
3. **Validation Error**: Check error messages dari API
4. **Widget Build Errors**: Check console untuk stack trace

## 📈 Performance Optimization

### Lazy Loading
```dart
ListView.builder(  // Lebih efisien daripada ListView
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)
```

### FutureBuilder Caching
```dart
// Gunakan StatefulWidget untuk cache Future
late Future<List<Inquiry>> _inquiriesFuture;

@override
void initState() {
  _inquiriesFuture = apiService.getMyInquiries();
}

// Hanya refresh saat diperlukan
setState(() {
  _inquiriesFuture = apiService.getMyInquiries();
});
```

### Image Optimization
- Gunakan NetworkImage dengan proper error handling
- Cache images di level device

## 🧪 Testing Todo

- [ ] Unit tests untuk API Service
- [ ] Widget tests untuk Screens
- [ ] Integration tests untuk complete flows
- [ ] Mock API responses untuk testing

## 🚀 Deployment Checklist

- [ ] Update version di pubspec.yaml
- [ ] Remove debug logging
- [ ] Enable ProGuard/R8 untuk Android
- [ ] Test di actual devices
- [ ] Update API_DOCUMENTATION.md jika ada perubahan
- [ ] Create release APK/IPA

---

**Happy Coding! 🎉**
