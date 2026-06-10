import 'package:local_auth/local_auth.dart';

class BiometriaService {
  final _auth = LocalAuthentication();

  Future<bool> disponivel() async {
    final podeVerificar = await _auth.canCheckBiometrics;
    final isSuportado = await _auth.isDeviceSupported();
    return podeVerificar && isSuportado;
  }

  Future<bool> autenticar() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Confirme sua identidade para acessar o Lembrex',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
