# Lembrex — Flutter

App **offline-first** de gestão de informações e lembretes pessoais, com sincronização opcional via API REST.

Roda em **Android**, **Linux** e **Windows** com a mesma base de código.

---

## Funcionalidades

- Criação e edição de registros com editor de texto rico (AppFlowy Editor)
- Categorias: Notas, Senhas, Finanças, Saúde, Tarefas, Links, Documentos, Outros
- Banco local via [Drift](https://drift.simonbinder.eu/) (SQLite)
- Sincronização bidirecional com backend PHP via token Bearer
- Suporte a imagens inline: colar da área de transferência, arrastar & soltar e galeria/câmera
- Autenticação local via biometria ou PIN
- Notificações de lembrete
- Tema escuro nativo

---

## Tecnologias

| Camada | Lib |
|---|---|
| Estado | `flutter_riverpod` |
| Banco local | `drift` + `sqlite3_flutter_libs` |
| Editor | `appflowy_editor` (fork local com fix Windows) |
| HTTP | `http` |
| Autenticação | `local_auth` + `flutter_secure_storage` |
| Notificações | `flutter_local_notifications` + `timezone` |
| Fontes | `google_fonts` |
| Drag & drop | `desktop_drop` |

---

## Pré-requisitos

- [FVM](https://fvm.app) instalado (`dart pub global activate fvm`)
- Flutter SDK gerenciado pelo FVM (versão fixada em `.fvm/fvm_config.json`)

```bash
# Instalar a versão fixada do Flutter
fvm install

# Verificar ambiente
fvm flutter doctor
```

---

## Configuração inicial

```bash
# 1. Clonar o repositório
git clone https://github.com/RuvianFabrin/lembrex_flutter.git
cd lembrex_flutter

# 2. Instalar dependências do Flutter
fvm flutter pub get

# 3. Gerar código do banco (Drift)
fvm dart run build_runner build --delete-conflicting-outputs

# 4. Copiar e ajustar variáveis de ambiente
cp .env.example .env   # edite .env com a URL e token da sua API
```

### `.env` — variáveis disponíveis

```env
# URL base da API PHP de sincronização
API_BASE_URL=http://localhost:38080

# Token Bearer para autenticação nos endpoints protegidos
API_TOKEN=seu_token_aqui

# Intervalo padrão de sincronização automática (em minutos)
SYNC_INTERVALO_MINUTOS=5
```

> O arquivo `.env` nunca é versionado. Ele é lido em runtime pelo `flutter_dotenv`.

---

## Rodar no Android

```bash
# Listar dispositivos conectados
fvm flutter devices

# Debug em dispositivo
fvm flutter run -d <device-id>

# Build APK release
fvm flutter build apk --release
# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

---

## Rodar no Linux

### Dependências do sistema (Ubuntu/Debian)

```bash
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev libstdc++-12-dev
```

```bash
# Habilitar target Linux (se necessário)
fvm flutter config --enable-linux-desktop

# Debug
fvm flutter run -d linux

# Release
fvm flutter build linux --release
# Binário: build/linux/x64/release/bundle/minhas_infos
```

---

## Rodar no Windows

```powershell
# Habilitar target Windows (se necessário)
fvm flutter config --enable-windows-desktop

# Debug
fvm flutter run -d windows

# Release
fvm flutter build windows --release
# Executável: build\windows\x64\runner\Release\minhas_infos.exe
```

---

## VS Code com FVM

Adicione ao `.vscode/settings.json` do projeto:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

---

## Comandos úteis

```bash
# Regenerar código do banco após alterar tabelas
fvm dart run build_runner build --delete-conflicting-outputs

# Regenerar ícones do app
fvm dart run flutter_launcher_icons

# Limpar build
fvm flutter clean && fvm flutter pub get

# Rodar testes
fvm flutter test
```

---

## Estrutura do projeto

```
lib/
├── core/
│   ├── database/        # Drift — tabelas, DAOs, migrações
│   ├── sync/            # SyncService — push/pull com a API
│   └── utils/           # Clipboard, upload de imagens
├── features/
│   ├── auth/            # Lock screen, biometria
│   ├── configuracoes/   # Tela de configurações + provider
│   ├── registro/        # Editor de registro, widgets do editor
│   └── sync/            # Diálogo de progresso de sync
packages/
└── appflowy_editor/     # Fork local com fix para Flutter 3.44+ no Windows
```

---

## Backend

Este app se comunica com a [API PHP Lembrex](https://github.com/RuvianFabrin/lembrex_php).  
A sincronização é opcional — o app funciona 100% offline sem configurar a API.

---

## Licença

Uso pessoal. Todos os direitos reservados.
