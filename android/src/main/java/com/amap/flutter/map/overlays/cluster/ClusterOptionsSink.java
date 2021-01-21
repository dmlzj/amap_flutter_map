package com.amap.flutter.map.overlays.cluster;

import com.amap.api.maps.model.LatLng;

/**
 * Created by yiyi.qi on 16/10/10.
 */

public interface ClusterOptionsSink {

    void setPosition(LatLng position);

    LatLng getPosition();
}
