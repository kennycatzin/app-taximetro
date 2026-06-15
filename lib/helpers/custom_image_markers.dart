part of 'helpers.dart';

Future<BitmapDescriptor>? _networkImageMarkerFuture;

Future<BitmapDescriptor> getAssetImageMarker() async {
  return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/custom-pin.png');
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  _networkImageMarkerFuture ??= _downloadNetworkImageMarker();
  return _networkImageMarkerFuture!;
}

Future<BitmapDescriptor> _downloadNetworkImageMarker() async {
  try {
    final resp = await Dio().get(
        'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-512.png',
        options: Options(responseType: ResponseType.bytes));

    final bytes = resp.data;
    final imageCode = await ui.instantiateImageCodec(bytes,
        targetHeight: 150, targetWidth: 150);

    final frame = await imageCode.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    if (data == null) {
      _networkImageMarkerFuture = null;
      return BitmapDescriptor.defaultMarker;
    }

    return await BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  } catch (_) {
    _networkImageMarkerFuture = null;
    return BitmapDescriptor.defaultMarker;
  }
}
