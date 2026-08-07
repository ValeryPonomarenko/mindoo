class SettingsInitialParams {
  const SettingsInitialParams();

  factory SettingsInitialParams.fromRouteExtra(Object? extra) =>
      switch (extra) {
        final SettingsInitialParams value => value,
        _ => const SettingsInitialParams(),
      };
}
