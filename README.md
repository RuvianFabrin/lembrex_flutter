# Lembrex

App offline-first de gestão de informações e lembretes pessoais.  
Roda em Android e Desktop (Linux e Windows) com a mesma base de código.

---

## Versão do Flutter (FVM)

O projeto usa [FVM](https://fvm.app) para fixar a versão do Flutter. A versão está registrada em `.fvm/fvm_config.json`.

```bash
# Instalar FVM (se ainda não tiver)
dart pub global activate fvm

# Instalar a versão do projeto automaticamente
fvm install

# Usar fvm flutter em vez de flutter direto
fvm flutter run -d linux
fvm flutter build linux --release
```

### VS Code — detectar automaticamente

Adicione ao `.vscode/settings.json` do projeto:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

Depois disso o VS Code usa a versão do FVM sem precisar fazer nada.

---

## Rodar no Linux

### Pré-requisitos

```bash
# Verificar se o Flutter está instalado e com Linux habilitado
fvm flutter doctor
fvm flutter config --enable-linux-desktop
```

### Dependências do sistema (Ubuntu/Debian)

```bash
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev libstdc++-12-dev
```

### Primeira vez

```bash
# Instalar a versão do Flutter fixada no projeto
fvm install

# Instalar dependências do projeto
fvm flutter pub get

# Gerar código do banco (drift)
fvm dart run build_runner build --delete-conflicting-outputs
```

### Rodar em modo debug

```bash
fvm flutter run -d linux
```

### Build release

```bash
fvm flutter build linux --release

# Binário gerado em:
# build/linux/x64/release/bundle/lembrex
```

### Executar o binário diretamente

```bash
./build/linux/x64/release/bundle/lembrex
```

---

## Rodar no Android

```bash
# Listar dispositivos conectados
fvm flutter devices

# Rodar no dispositivo (substituir <id> pelo id do dispositivo)
fvm flutter run -d <id>

# Gerar APK release
fvm flutter build apk --release
# APK em: build/app/outputs/flutter-apk/app-release.apk
```

---

## Outros comandos úteis

```bash
# Regenerar código do banco após alterar tabelas
fvm dart run build_runner build --delete-conflicting-outputs

# Limpar build
fvm flutter clean && fvm flutter pub get
```
