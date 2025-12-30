/// Avatar physiological evolution state.
///
/// This is *not* tied to Unity/3D; it is a pure domain signal intended to
/// drive future visuals.
///
/// NOTE: We intentionally keep this enum separate from the existing
/// gamification EvolutionState to avoid breaking persisted Hive indexes.
enum AvatarEvolutionState {
  /// Extreme low-mass / unhealthy low energy availability trend.
  emaciated,

  /// Low body mass / lean trend.
  lean,

  /// Lean + disciplined cut / visibly defined trend.
  defined,

  /// Fit / performance-oriented maintenance trend.
  athletic,

  /// Controlled surplus aimed at gaining mass.
  bulking,

  /// Excessive surplus and/or low consistency trend.
  obese,
}
