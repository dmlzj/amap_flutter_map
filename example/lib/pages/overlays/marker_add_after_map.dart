/*
 * @Description: test
 * @Author: dmlzj
 * @Github: https://github.com/dmlzj
 * @Email: 284832506@qq.com
 * @Date: 2020-12-22 14:04:33
 * @LastEditors: dmlzj
 * @LastEditTime: 2021-01-21 11:58:28
 * @如果有bug，那肯定不是我的锅，嘤嘤嘤
 */
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

class MarkerAddAfterMapPage extends BasePage {
  MarkerAddAfterMapPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static final LatLng defaultPosition = const LatLng(39.909187, 116.397451);
  //需要先设置一个空的map赋值给AMapWidget的markers，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};

  final Map<String, Cluster> _clusters = <String, Cluster>{};
  LatLng _currentLatLng = defaultPosition;
  //添加一个marker
  void _addMarker() {
    final _markerPosition =
        LatLng(_currentLatLng.latitude, _currentLatLng.longitude + 2 / 1000);
    final Marker marker = Marker(
      position: _markerPosition,
      //使用默认hue的方式设置Marker的图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    //调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      _currentLatLng = _markerPosition;
      //将新的marker添加到map里
      _markers[marker.id] = marker;
    });
  }


  void _addCluster() {
    final _position =
        LatLng(_currentLatLng.latitude, _currentLatLng.longitude + 2 / 1000);
        final Cluster cluster = Cluster(position: _position);
        setState(() {
          _clusters[cluster.id] = cluster;
        });
  }

  FlatButton _createMyFloatButton(String label, Function onPressed) {
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textColor: Colors.white,
      highlightColor: Colors.blueAccent,
      child: Text(label),
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      // //创建地图时，给marker属性赋值一个空的set，否则后续无法添加marker
      markers: Set<Marker>.of(_markers.values),
      clusters: Set<Cluster>.of(_clusters.values),
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
            child: amap,
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _createMyFloatButton('添加marker', _addMarker),
                _createMyFloatButton('添加cluster', _addCluster)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
