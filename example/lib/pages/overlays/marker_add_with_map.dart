/*
 * @Description: test
 * @Author: dmlzj
 * @Github: https://github.com/dmlzj
 * @Email: 284832506@qq.com
 * @Date: 2020-12-18 21:36:13
 * @LastEditors: dmlzj
 * @LastEditTime: 2021-01-28 13:58:56
 * @如果有bug，那肯定不是我的锅，嘤嘤嘤
 */
import 'dart:convert';
import 'dart:math';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:amap_flutter_map_example/const_config.dart';
import 'package:flutter/material.dart';

class MarkerAddWithMapPage extends BasePage {
  MarkerAddWithMapPage(String title, String subTitle) : super(title, subTitle);

  @override
  Widget build(BuildContext context) => _Body();
}

class _Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  static final LatLng mapCenter = const LatLng(39.909187, 116.397451);
  final Map<String, Marker> _initMarkerMap = <String, Marker>{};
  final Map<String, Cluster> _initClusterMap = <String, Cluster>{};

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 10; i++) {
      LatLng position = LatLng(mapCenter.latitude + sin(i * pi / 12.0) / 20.0,
          mapCenter.longitude + cos(i * pi / 12.0) / 20.0);
      Marker marker = Marker(position: position);
      _initMarkerMap[marker.id] = marker;
      Map data = {"test": "test"};
      Cluster cluster = Cluster(position: position, data: jsonEncode(data));
      _initClusterMap[cluster.id] = cluster;
    }

    final AMapWidget amap = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      markers: Set<Marker>.of(_initMarkerMap.values),
      clusters: Set<Cluster>.of(_initClusterMap.values),
      onClusterTap: (items) {
        print('==================\n');
        print(items);
      },
    );
    return Container(
      child: amap,
    );
  }
}
