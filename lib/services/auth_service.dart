import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // GoogleSignIn nesnesini bir kere tanımlamak daha sağlıklıdır
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google ile giriş yap
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. İnteraktif giriş işlemini başlat
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // 2. Eğer kullanıcı giriş pencresini kapatırsa
      if (gUser == null) {
        print('Google girişi kullanıcı tarafından iptal edildi.');
        return null;
      }

      // 3. Kimlik bilgilerini (Token) al
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // 4. Kullanıcı için Firebase bileti (Credential) oluştur
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // 5. Son olarak Firebase'e giriş yap
      return await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (e) {
      print('Google ile giriş yapılırken bir hata oluştu: $e');
      return null;
    }
  }
}