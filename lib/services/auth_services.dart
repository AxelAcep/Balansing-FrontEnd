import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:balansing/config.dart';
import 'package:balansing/models/customer.dart' as customer_data;
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  customer_data.Customer? _customer;
  customer_data.Customer? get customer => _customer;

  // Fungsi untuk mendaftarkan pengguna baru
  Future<String> registration({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        // Menyimpan data user ke dalam model _customer
        _customer = customer_data.Customer(
          id: user.id,  
          email: email,
        );
        
        return 'Success';
      } else {
        return 'Registration failed';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Fungsi untuk mengecek apakah user sudah login
  Future<bool> isUserLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final user = session.user;

      // Menyimpan data user ke dalam _customer jika sudah login
      _customer = customer_data.Customer(
        id: user.id,  
        email: user.email ?? '',
      );
          notifyListeners();
      return true;  
    } else {
      return false;  
    }
  }

  // Fungsi untuk mendapatkan data customer
  Future<customer_data.Customer?> getCustomer() async {
    // Memperbarui customer dengan data dari API
    _customer = await getCustomerData();
    notifyListeners();

    return _customer;
  }

  // Fungsi untuk mengambil data customer dari API
  Future<customer_data.Customer?> getCustomerData() async {
    // Mengambil UID dari user yang sedang login
    final customerUid = Supabase.instance.client.auth.currentSession?.user.id;
    
    if (customerUid == null) {
      return null;
    }

    final url = Uri.parse('${AppConfig.apiUrl}api/user/$customerUid');
    
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message']);
      } else {
        final body = jsonDecode(response.body)['data'];

        if (body == null) {
          return null;
        }
        // Mengubah data yang diterima ke dalam model user_data.User
        return customer_data.Customer.fromJson(body);
      }
    } catch (e) {
      // Menghandle error jika terjadi kesalahan pada API atau jaringan
      throw Exception('Error fetching user data: $e');
    }
  }
}

  /*
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  user_data.User? _user;
  user_data.User? get user => _user;

  Future<String> registration({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      await addRegisterData(user!.uid, email);

      _user = user_data.User(id: user.uid, email: email);

      notifyListeners();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete();
      }

      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message.toString();
      }
    } catch (e) {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete();
      }
      return e.toString();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      final existingUser = await getUserData();

      if (existingUser == null) {
        await addRegisterData(user!.uid, googleUser!.email);
        _user = user_data.User(id: user.uid, email: googleUser.email);
      } else {
        return 'Success';
      }
      notifyListeners();

      return 'Success Create';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = await getUserData();
      notifyListeners();

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'Wrong email or password.';
      } else {
        return e.message.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }

  Future<String> addUserInfo(
      {required String name,
      required String username,
      required File? image}) async {
    try {
      String imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/wicara-6c82d.appspot.com/o/Default.png?alt=media&token=b42dcd9c-aa99-4689-a9cf-de8c63ce468c';
      
      if (image != null) {
        String fileName =
            'uploads/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask = _storage.ref().child(fileName).putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final url =
          Uri.parse('${AppConfig.apiUrl}api/user/${_auth.currentUser!.uid}');
      print(url);
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'username': username,
          'profile_url': imageUrl
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message']);
      }

      _user = user_data.User.fromJson(jsonDecode(response.body)['data']);
      notifyListeners();
      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<user_data.User?> getUserData() async {
    final url =
        Uri.parse('${AppConfig.apiUrl}api/user/${_auth.currentUser!.uid}');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      final body = jsonDecode(response.body)['data'];

      if (body == null) {
        return null;
      }
      return user_data.User.fromJson(jsonDecode(response.body)['data']);
    }
  }

  Future<user_data.User?> getUser() async {
    _user = await getUserData();
    notifyListeners();

    return _user;
  }

  Future<void> addRegisterData(String id, String email) async {
    final url = Uri.parse('${AppConfig.apiUrl}api/user');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<bool> isUserLoggedIn() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      _user = await getUserData();
    }

    notifyListeners();

    return user != null;
  } */
