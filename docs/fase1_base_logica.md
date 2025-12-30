# Fase 1 — Base lógica (treino + dieta + balanço calórico)

## 1) Arquitetura (Clean Architecture)

**Objetivo:** manter cálculo/calorias e regras de negócio estáveis e testáveis, sem depender de UI, banco, Firebase/Supabase ou Unity.

- **domain/**
  - **entities/**: modelos do negócio (User, Workout, FoodEntry, DailySummary, CalorieBalance) + enums.
  - **repositories/**: contratos (interfaces) para persistência.
  - **services/**: cálculos puros (BMR/TDEE, MET, saldo).
  - **usecases/**: orquestram regras do domínio e repositórios.

- **data/**
  - **models/**: DTOs serializáveis (toJson/fromJson), com mapeamento para entities.
  - **datasources/**: fonte de dados concreta (nesta fase: in-memory).
  - **repositories/**: implementações dos contratos do domínio.

- **presentation/**
  - **pages/**: telas simples Material.
  - **controllers/**: chamam use cases e invalidam providers.
  - **widgets/**: UI reutilizável (ex.: card de resumo diário).

- **app_providers.dart**
  - composição (DI) via Riverpod: decide qual repository/datasource usar.

## 2) Por que Riverpod (nesta base)

Escolha prática para MVVM/Clean em Flutter:
- DI simples e testável (providers como composição de dependências).
- Fácil substituir in-memory por banco/Firebase/Supabase sem tocar em UI.
- Menos boilerplate que Bloc/Cubit para um MVP de cálculos.

> Observação: o projeto usa `flutter_riverpod 3.x`, cujo conjunto de exports é mais enxuto; por isso usamos `NotifierProvider`/`FutureProvider`.

## 3) Modelos de dados (obrigatórios)

### User
Atributos principais:
- `id`, `name`
- `heightCm`, `weightKg`
- `sex` (male/female)
- `activityLevel` (sedentary, lowActivity, moderateActivity, intenseActivity)
- `ageYears?` (opcional; para BMR mais preciso)

### Workout
- `id`
- `startedAt`
- `type` (strengthTraining, running, walking, cycling, other)
- `durationMinutes`
- `intensity` (light/moderate/high)
- `metOverride?` (permite trocar a tabela)
- `caloriesOverride?` (edição manual total)

### FoodEntry
- `id`
- `eatenAt`
- `foodName`
- `quantity`, `unit` (ex.: 100 g)
- `calories` (total do registro)

### DailySummary
- `date`
- `totalCaloriesIn`
- `totalCaloriesOutExercise`
- `baselineCalories`
- `calorieBalance`

### CalorieBalance
- `date`
- `intakeCalories`
- `exerciseCalories`
- `baselineCalories`
- `netCalories`
- `status` (deficit/neutral/surplus)

## 4) Cálculos (isolados em serviço)

Arquivo: `lib/domain/services/calorie_calculator_service.dart`

### 4.1 BMR (Mifflin-St Jeor)

- Homem: `BMR = 10*w + 6.25*h - 5*age + 5`
- Mulher: `BMR = 10*w + 6.25*h - 5*age - 161`

Onde:
- `w` = peso (kg)
- `h` = altura (cm)
- `age` = idade (anos)

### 4.2 Baseline (TDEE simplificado)

O seu texto chama de “taxa metabólica basal + condição”; isso na prática é o **gasto diário basal ajustado pela atividade**.

`baseline = BMR * activityFactor`

Factors usados:
- sedentary: 1.2
- lowActivity: 1.375
- moderateActivity: 1.55
- intenseActivity: 1.725

### 4.3 Gasto do treino (MET)

Estimativa padrão:

`calories = MET * weightKg * hours`

- `hours = durationMinutes / 60`
- MET vem de uma tabela simples por `WorkoutType + IntensityLevel`
- se `metOverride` existe, ele substitui a tabela
- se `caloriesOverride` existe, ele substitui tudo

### 4.4 Saldo calórico (superávit/déficit)

No app implementamos a convenção mais comum:

`net = intake - (baseline + exercise)`

- `net > 0` => superávit
- `net < 0` => déficit
- `≈ 0` => equilíbrio (usamos tolerância de 50 kcal)

> Seu texto tinha: `baseline + (intake - burned)`. Isso muda o significado do “saldo”. Se você quiser seguir exatamente essa equação, dá para trocar a função `calculateDailyBalance` sem mexer na UI.

## 5) Exemplos numéricos

### Exemplo A (BMR + baseline)
Usuário:
- homem, 30 anos, 75 kg, 175 cm, activityLevel=moderate (1.55)

BMR:
- `10*75 + 6.25*175 - 5*30 + 5`
- `750 + 1093.75 - 150 + 5 = 1698.75 kcal/dia`

Baseline:
- `1698.75 * 1.55 = 2633.06 kcal/dia`

### Exemplo B (treino)
Corrida moderada, 45 min, MET=9.8, peso 75 kg:
- horas = 45/60 = 0.75
- `cal = 9.8 * 75 * 0.75 = 551.25 kcal`

### Exemplo C (saldo diário)
No mesmo dia:
- intake = 2200
- baseline = 2633
- exercise = 551

`net = 2200 - (2633 + 551) = 2200 - 3184 = -984 kcal` => déficit

## 6) Fluxo de dados (end-to-end)

1. Tela chama Controller (presentation)
2. Controller chama UseCase (domain)
3. UseCase chama Repository (domain interface)
4. Repository (data) grava no Datasource (data)
5. Controller invalida providers
6. Home/History recompõem e chamam `GetDailySummaryUseCase` novamente

## 7) Onde o Unity entra no futuro (sem implementar agora)

Recomendação para Fase 2:
- Criar um **módulo/feature separado** (ex.: `lib/features/avatar/`)
- Expor uma interface no domínio (ex.: `AvatarProgressRepository`) que consome os dados de `DailySummary/CalorieBalance`
- A integração Unity-as-a-Library fica **fora** do domínio (presentation/infrastructure)

Assim, trocar “avatar 2D/3D/Unity” não mexe em treino/dieta/cálculos.
