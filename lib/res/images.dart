/// Статические ссылки на ресурсы-картинки
class Images {
  Background background({bool portrait = false}) =>
      portrait ? PortraitBackground() : Background();
}

/// Картинки ландшафтного режима
class Background extends Images {
  get stub => 'image/stub_back.jpg';
}

/// Картинки портретного режима
class PortraitBackground extends Background {
  @override
  get stub => 'image/stub_back_port.jpg';
}

