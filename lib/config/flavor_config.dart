enum Flavor { free, paid }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final bool canAddLocation;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.canAddLocation,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    return _instance ?? FlavorConfig.free();
  }

  factory FlavorConfig.free() {
    _instance = FlavorConfig._(
      flavor: Flavor.free,
      name: 'Story App Free',
      canAddLocation: false,
    );
    return _instance!;
  }

  factory FlavorConfig.paid() {
    _instance = FlavorConfig._(
      flavor: Flavor.paid,
      name: 'Story App Paid',
      canAddLocation: true,
    );
    return _instance!;
  }

  bool get isFree => flavor == Flavor.free;
  bool get isPaid => flavor == Flavor.paid;
}
