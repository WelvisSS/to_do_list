# To-Do List App - Flutter

Aplicativo de lista de tarefas desenvolvido em Flutter seguindo os princípios de **Clean Architecture**, **SOLID** e utilizando **BLoC** para gerenciamento de estado.

## 🏗️ Estrutura da Arquitetura

O projeto segue a **Clean Architecture** organizada por features com 3 camadas principais:

```
lib/
├── 📂 core/                          # Código compartilhado
│   ├── di/
│   │   └── injection_container.dart  # Configuração GetIt
│   ├── errors/
│   │   └── failures.dart             # Classes de falhas
│   └── usecases/
│       └── usecase.dart              # Interface base UseCase
│
└── 📂 features/
    └── tasks/                        # Feature de Tarefas
        │
        ├── 📂 domain/                # 🎯 CAMADA DE DOMÍNIO
        │   ├── entities/
        │   │   └── task.dart         # Entidade Task
        │   ├── repositories/
        │   │   └── task_repository.dart          # Interface do repositório
        │   └── usecases/
        │       ├── get_tasks.dart    # UC: Buscar tarefas
        │       ├── add_task.dart     # UC: Adicionar tarefa
        │       ├── delete_task.dart  # UC: Deletar tarefa
        │       └── toggle_task.dart  # UC: Alternar status
        │
        ├── 📂 data/                  # 💾 CAMADA DE DADOS
        │   ├── models/
        │   │   └── task_model.dart   # Model com serialização JSON
        │   ├── datasources/
        │   │   └── task_local_datasource.dart    # SharedPreferences
        │   └── repositories/
        │       └── task_repository_impl.dart     # Implementação do repositório
        │
        └── 📂 presentation/          # 🎨 CAMADA DE APRESENTAÇÃO
            ├── bloc/
            │   ├── task_bloc.dart    # Lógica de negócio (BLoC)
            │   ├── task_event.dart   # Eventos
            │   └── task_state.dart   # Estados
            ├── pages/
            │   └── tasks_page.dart   # Tela principal
            └── widgets/
                ├── add_task_button.dart      # Botão flutuante
                ├── add_task_dialog.dart      # Dialog para adicionar
                ├── filter_tabs.dart          # Abas de filtro
                ├── task_item.dart            # Item da lista
                └── task_list.dart            # Lista de tarefas

test/
└── features/
    └── tasks/
        ├── domain/usecases/          # Testes de Use Cases
        ├── data/repositories/        # Testes de Repository
        └── presentation/bloc/        # Testes de BLoC
```
## 🚀 Como Rodar o Projeto

### 1️⃣ Clonar o Repositório

```bash
git clone https://github.com/WelvisSS/to_do_list.git
cd to_do_list
```

### 2️⃣ Instalar Dependências

```bash
flutter pub get
```

### 3️⃣ Gerar Código de Mocks (para testes)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4️⃣ Executar o Aplicativo

**Em um dispositivo/emulador conectado:**
```bash
flutter run
```

## 🧪 Como Rodar os Testes

### Executar Todos os Testes

```bash
flutter test
```