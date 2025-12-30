# Pivot — Habit Tracker Gamificado (Flutter + Unity)

## 0) O que mudou

- O app agora inicia no módulo de **hábitos gamificados**.
- O protótipo anterior (academia/calorias) permanece no repositório, mas não é mais a home.

Entry point:
- `lib/main.dart` -> `HabitsHomePage`

## 1) Arquitetura geral (Clean Architecture + MVVM)

**Princípio:** o domínio não conhece Flutter, Unity, Firebase, Supabase.

### Camadas

- **domain** (por feature)
  - entities: regras/modelos puros (Habit, HabitCompletion, UserProgress)
  - repositories: contratos (interfaces)
  - services: fórmulas e curvas (XP/level)
  - usecases: orquestração (criar hábito, toggle completion, reward)

- **data**
  - datasources: fonte concreta (nesta fase: in-memory)
  - repositories: implementações dos contratos

- **presentation**
  - pages/widgets: UI
  - controllers: chamam usecases + invalidam providers

### Onde entra o Unity (Unity as a Library)

- Flutter chama Unity via **bridge** (interface) no domínio:
  - `AvatarBridge` (setLevel, playIdle, playLevelUp)
- A implementação concreta usa **platform channels** (Android/iOS):
  - `MethodChannelAvatarBridge` (por enquanto)
- A View do avatar vira um **PlatformView** (AndroidView/UiKitView) quando a integração nativa estiver pronta.

Assim: regras de XP/level/streak não dependem do Unity.

## 2) Decisões técnicas (e por quê)

### 2.1 Riverpod vs Bloc

**Escolha: Riverpod**
- Melhor para DI + Clean (providers como composição)
- Menos boilerplate para MVP
- Facilita trocar repositórios (in-memory -> Firebase/Supabase) sem mexer na UI

### 2.2 Firebase vs Supabase

**Escolha recomendada: Firebase**, por ser mais “produto grande + gamificação”:
- Auth + Analytics + Crashlytics + Remote Config prontos
- Bom para A/B, eventos, funil de engajamento
- Firestore funciona bem para hábitos + progressos

**Quando eu escolheria Supabase**:
- Você quer SQL/Postgres e queries complexas
- Quer self-host / maior controle de infra

MVP: comece local (in-memory/local db), depois pluga backend.

## 3) MVP técnico (o mínimo que valida o core)

### Funcionalidades
- Criar hábito (nome + XP)
- Listar hábitos do dia
- Marcar/desmarcar conclusão por dia
- Somar/subtrair XP
- Calcular level por curva simples
- Streak simples (se todos hábitos ativos do dia forem concluídos: streak++)
- Enviar sinais para o avatar:
  - se level aumentou => playLevelUp
  - senão => playIdle

### Telas
- Home (dashboard do dia: lista + progresso + placeholder do avatar)
- Nova criação de hábito

## 4) Fórmulas (XP e Level)

Arquivo:
- `lib/features/gamification/domain/services/progression_service.dart`

Curva escolhida (tunable):

`nextLevelTotalXp(level) = 100 * (level + 1)^2`

Exemplos:
- level 0 -> próximo level quando totalXp >= 100
- level 1 -> próximo level quando totalXp >= 400
- level 2 -> próximo level quando totalXp >= 900

Isso cria progressão mais lenta com o tempo sem ficar impossível.

## 5) Fluxo de dados (toggle completion)

1. UI (Checkbox) chama `HabitsDashboardController.toggleCompletion`
2. Controller chama `ToggleCompletionUseCase` (marca/desmarca)
3. Controller aplica XP (+/- xpReward)
4. Controller recalcula streak (regra simples)
5. Controller calcula progress antes/depois e sinaliza o AvatarBridge
6. Providers são invalidados -> UI atualiza

## 6) Checklist (ordem certa, evitando retrabalho)

### Etapa A — Core local (já em andamento)
- [x] Entidades + repositórios + use cases
- [x] Persistência in-memory
- [x] Dashboard e telas básicas

### Etapa B — Persistência local de verdade
- [ ] Trocar in-memory por um storage local (ex.: Hive/Isar/SQLite)
- [ ] Migrar datasource sem mudar domínio/presentation

### Etapa C — Backend (Firebase)
- [ ] Definir modelo de dados (coleções): users, habits, completions, progress
- [ ] Auth (anônimo -> email/Google depois)
- [ ] Sync: offline-first (cache local + merge)

### Etapa D — Unity as a Library
- [ ] Criar projeto Unity (avatar idle + level up)
- [ ] Exportar como Library (Android) e Framework (iOS)
- [ ] Registrar PlatformView para exibir a cena Unity dentro do Flutter
- [ ] Implementar MethodChannel no Android/iOS para:
  - setLevel(level)
  - playIdle()
  - playLevelUp()

### Etapa E — Animações (Rive/Lottie)
- [ ] Micro-feedback: check, confetti, “level up” overlay
- [ ] Garantir que animações não carreguem regra de negócio

## 7) Onde estão as coisas (mapa rápido)

- Providers/DI: `lib/features/app/app_providers.dart`
- Controller: `lib/features/app/presentation/controllers/habits_dashboard_controller.dart`
- Home: `lib/features/app/presentation/pages/habits_home_page.dart`
- Novo hábito: `lib/features/app/presentation/pages/new_habit_page.dart`
- Avatar bridge: `lib/features/avatar/domain/repositories/avatar_bridge.dart`
- Bridge (MethodChannel): `lib/features/avatar/presentation/widgets/method_channel_avatar_bridge.dart`
