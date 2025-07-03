import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    final account = await googleSignIn.authenticate();
    final auth = account.authentication;

    final googleIdToken = auth.idToken;
    if (googleIdToken == null) throw Exception('Google ID token is null');

    final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
    final userCredential = await _auth.signInWithCredential(credential);

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) throw Exception('Firebase user is null');

    return firebaseUser;
  }

  Future<String> getIdToken(User firebaseUser) async {
    final firebaseIdToken = await firebaseUser.getIdToken();
    if (firebaseIdToken == null) throw Exception('Firebase ID token is null');
    return firebaseIdToken;
  }
}
