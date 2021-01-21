package com.amap.flutter.map.overlays.cluster;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.LatLng;

/**
 * Created by yiyi.qi on 16/10/10.
 */

public class ClusterOptions implements ClusterOptionsSink {
    public LatLng location;

    public void setPosition(LatLng position) {
        this.location = position;
    }

    @Override
    public LatLng getPosition() {
        return location;
    }

}
