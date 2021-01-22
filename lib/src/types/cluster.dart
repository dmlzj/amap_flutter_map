/*
 * @Description: cluster
 * @Author: dmlzj
 * @Github: https://github.com/dmlzj
 * @Email: 284832506@qq.com
 * @Date: 2021-01-21 11:48:43
 * @LastEditors: dmlzj
 * @LastEditTime: 2021-01-22 09:57:44
 * @如果有bug，那肯定不是我的锅，嘤嘤嘤
 */
import 'dart:ui' show hashValues, Offset;
import 'package:amap_flutter_map/src/types/base_overlay.dart';
import 'package:flutter/foundation.dart' show ValueChanged, VoidCallback;
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:meta/meta.dart';
import 'bitmap.dart';
import 'base_overlay.dart';

class Cluster extends BaseOverlay {
  /// 位置,不能为空
  final LatLng position;
  final dynamic data;

  Cluster({@required this.position, this.data});

  /// copy的真正复制的参数，主要用于需要修改某个属性参数时使用
  Cluster copyWith({
  
    LatLng positionParam,
    dynamic dataParam,
   
  }) {
    Cluster copyCluster = Cluster(
  
      position: positionParam ?? position,
      data: dataParam ?? data,
   
    );
    copyCluster.setIdForCopy(id);
    return copyCluster;
  }
  Cluster clone() => copyWith();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['position'] = position?.toJson();
    json['data'] = data;
    return json;
  }
}
