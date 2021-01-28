# amap_flutter_map

基于[高德开放平台地图SDK](https://lbs.amap.com/api/)的flutter插件 QQ交流群：731946579

## Usage
使用Flutter插件，请参考[在Flutter里使用Packages](https://flutter.cn/docs/development/packages-and-plugins/using-packages), 添加amap_flutter_map的引用

## 准备工作
* 登录[高德开放平台官网](https://lbs.amap.com/)申请ApiKey。Android平台申请配置key请参考[Android获取key](https://lbs.amap.com/api/poi-sdk-android/develop/create-project/get-key/?sug_index=2), iOS平台申请配置请参考[iOS获取key](https://lbs.amap.com/api/poi-sdk-ios/develop/create-project/get-key/?sug_index=1)。
* 引入高得地图SDK，Android平台请参考[Android Sudio配置工程](https://lbs.amap.com/api/android-sdk/guide/create-project/android-studio-create-project), iOS平台请参考[ios安装地图SDK](https://lbs.amap.com/api/ios-sdk/guide/create-project/cocoapods)

## 基本使用示例
``` Dart
import 'package:amap_flutter_map_example/base_page.dart';
import 'package:flutter/material.dart';

import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';

class ShowMapPage extends BasePage {
  ShowMapPage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _ShowMapPageBody();
  }
}

class _ShowMapPageBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowMapPageState();
}

class _ShowMapPageState extends State<_ShowMapPageBody> {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10.0,
  );
  List<Widget> _approvalNumberWidget = List<Widget>();
  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
    );

    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: map,
          ),
          Positioned(
              right: 10,
              bottom: 15,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _approvalNumberWidget),
              ))
        ],
      ),
    );
  }

  AMapController _mapController;
  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
      getApprovalNumber();
    });
  }

  /// 获取审图号
  void getApprovalNumber() async {
    //普通地图审图号
    String mapContentApprovalNumber =
        await _mapController?.getMapContentApprovalNumber();
    //卫星地图审图号
    String satelliteImageApprovalNumber =
        await _mapController?.getSatelliteImageApprovalNumber();
    setState(() {
      if (null != mapContentApprovalNumber) {
        _approvalNumberWidget.add(Text(mapContentApprovalNumber));
      }
      if (null != satelliteImageApprovalNumber) {
        _approvalNumberWidget.add(Text(satelliteImageApprovalNumber));
      }
    });
    print('地图审图号（普通地图）: $mapContentApprovalNumber');
    print('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }
}

```

## 点聚合使用示例：参考demo中的marker_add_with_map.dart文件即可
* 效果图如下：
![image](https://github.com/dmlzj/amap_flutter_map/blob/master/test/Screenshot.jpg)
```Dart
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
```

## 插件使用注意问题：
 ### 我使用插件时添加了点聚合功能，使用注意问题：
 - Cluster数据格式没做限制，解析的时候解析的是json，所以传值data必须是json字符串，否则运行崩溃
 ```
var data = {"shopid": item.shopid, "warning_num": item.warning_num};
        Cluster cluster = Cluster(
            position: LatLng(item.lat, item.lng), data: jsonEncode(data));
_initClusterMap[cluster.id] = cluster;

 ```

 ### Android配置时尤其要注意，参考demo进行配置，否则会运行不起来，几个注意的地方：
 - 引入demo中高德sdk到flutter项目Android目录中：把example/android/app/libs 文件夹的都复制到 ##/android/app/libs 中
 - build.gradle配置：
 ```
 android {
  ........

  buildTypes {
        release {
            ....
            //关闭混淆, 否则在运行release包后可能出现运行崩溃， TODO后续进行混淆配置
            minifyEnabled false //删除无用代码
            shrinkResources false //删除无用资源
        }
  }
  sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }
  }
 }
 dependencies {
    //demo中引入高德地图SDK
    implementation fileTree(include: ['*.jar'], dir: 'libs')
}

 ```
## 已知问题：
1. Flutter插件在iOS端，MapView销毁时，一定概率触发Main Thread Checker的报警，
经过对比测试确认是Flutter的bug所致；https://github.com/flutter/flutter/issues/68490 
（对比1.25.0-8.1.pre版本已修复，从github的issues中得知，有其它开发着反馈1.24.0-6.0.pre已修复；该问题依赖Flutter升级修复） 




