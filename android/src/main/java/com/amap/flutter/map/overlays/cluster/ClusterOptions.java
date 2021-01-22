package com.amap.flutter.map.overlays.cluster;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.LatLng;

/**
 * Created by yiyi.qi on 16/10/10.
 */

public class ClusterOptions implements ClusterOptionsSink {
    public LatLng position;
    public String data;

    public void setPosition(LatLng position) {
        this.position = position;
    }

    @Override
    public LatLng getPosition() {
        return position;
    }

    @Override
    public void setData(String data) {
        this.data = data;
    }

    @Override
    public String getData() {
        return data;
    }

}
