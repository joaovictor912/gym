# Offline-first persistence (Hive) + migration strategy

This project uses Hive as the primary local database for offline-first behavior.

## Goals

- Offline-first: the app works with zero network.
- Deterministic aggregates: daily summaries/body state/gamification can be recomputed locally.
- Backend-ready: data is stored with stable identifiers and day buckets so we can sync later.

## Storage layout

Hive box names are centralized in `lib/data/local/hive/hive_boxes.dart`.

Current boxes (v1):
- `meta`: schema/version + small metadata.
- `user_profile`: user profile.
- `workouts` + `workout_day_index`: workout entries + per-day index.
- `foods` + `food_day_index`: food entries + per-day index.
- `daily_summary`: stored daily aggregates.
- `body_state_history`: stored computed body state snapshots.
- `gamification_stats`: current gamification snapshot.
- `xp_history`: per-day XP event log.
- `streak_history`: per-day streak snapshots.

## Keys and bucketing

- Day bucketing uses `YYYY-MM-DD` keys via `lib/core/time/date_key.dart`.
- Histories are stored as compound keys `"<userId>|<YYYY-MM-DD>"`.

This makes it easy to:
- recompute a specific day and overwrite it idempotently
- sync changes by day bucket later

## Schema versioning

- Schema version is tracked in `meta.schema_version`.
- Type ids are defined in `lib/data/local/hive/models/hive_ids.dart` and must remain stable.

When changing schemas:
1) Add new type ids (never change existing ids).
2) Bump `HiveDb.currentSchemaVersion` only when you must migrate existing data.
3) Implement incremental migrations in `HiveDb._migrateIfNeeded()`.

## Recalculation pipeline

Write path:
- create/update/delete workout or food -> `UpdateDailyAggregatesUseCase(day)`

`UpdateDailyAggregatesUseCase` performs:
- recompute & persist `DailySummary`
- compute & persist `BodyStateHistory`
- recompute & persist daily gamification (`UpdateDailyGamificationUseCase`)

This keeps reads fast and makes analytics/gamification deterministic.

## Backend migration strategy (future)

Recommended backend sync model:

- Treat `workouts` and `foods` as the source-of-truth event data.
- Treat `daily_summary`, `body_state_history`, `xp_history`, `streak_history` as derived (can be recomputed server-side or client-side).

Sync approach:
- Upload event entities with stable ids (`workoutId`, `foodEntryId`).
- Upload day bucket documents keyed by `YYYY-MM-DD` for derived snapshots.
- Resolve conflicts with a simple last-write-wins on event entities, and then recompute derived day snapshots.

Gamification is designed to be idempotent per day:
- `xp_history` stores a single record per user/day; recalculation overwrites and adjusts totals.
