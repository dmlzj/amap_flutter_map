import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:amap_flutter_base/amap_flutter_base.dart';

class PolylineTextureDemoPage extends BasePage {
  PolylineTextureDemoPage(String title, String subTitle)
      : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_Body> {
  _State();

  Map<String, Polyline> _polylines = <String, Polyline>{};
  String selectedPolylineId;

  void _onMapCreated(AMapController controller) {}

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final int polylineCount = _polylines.length;
    final double offset = polylineCount * -(0.01);
    points.add(LatLng(39.938698 + offset, 116.275177));
    points.add(LatLng(39.966069 + offset, 116.289253));
    points.add(LatLng(39.944226 + offset, 116.306076));
    points.add(LatLng(39.966069 + offset, 116.322899));
    points.add(LatLng(39.938698 + offset, 116.336975));
    return points;
  }

  void _add() {
    final Polyline polyline = Polyline(
        width: 20,
        customTexture:
            BitmapDescriptor.fromIconPath('assets/texture_green.png'),
        joinType: JoinType.round,
        points: _createPoints());

    setState(() {
      _polylines[polyline.id] = polyline;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      onMapCreated: _onMapCreated,
      polylines: Set<Polyline>.of(_polylines.values),
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: map,
          ),
          Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: _add,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textColor: Colors.white,
                highlightColor: Colors.blueAccent,
                child: Text('添加纹理线'),
                color: Colors.blue,
              )),
        ],
      ),
    );
  }
}
