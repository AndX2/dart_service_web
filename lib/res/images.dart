class Images {
  static Background background({bool portrait = false}) =>
      portrait ? PortraitBackground() : Background();
}

class Background extends Images {
  get stub => 'image/stub_back.webp';
}

class PortraitBackground implements Background {
  @override
  get stub => 'image/stub_back_port.webp';
}
