enum ControlSurface {
  phone,
  windows,
  smartHome,
  medical;

  String get label => switch (this) {
        phone => 'Phone',
        windows => 'Windows PC',
        smartHome => 'Smart Home',
        medical => 'Safety',
      };

  String get shortLabel => switch (this) {
        phone => 'Phone',
        windows => 'PC',
        smartHome => 'Home',
        medical => 'SOS',
      };
}
