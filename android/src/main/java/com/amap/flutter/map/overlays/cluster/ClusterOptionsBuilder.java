package com.amap.flutter.map.overlays.cluster;

import com.amap.api.maps.model.LatLng;

/**
 * Created by yiyi.qi on 16/10/10.
 */

public class ClusterOptionsBuilder implements ClusterOptionsSink {
    final ClusterOptions clusterOptions;
    public ClusterOptionsBuilder() {
        this.clusterOptions = new ClusterOptions();
    }

    public ClusterOptions build() {
        return clusterOptions;
    }


    @Override
    public void setPosition(LatLng position) {
        clusterOptions.setPosition(position);
    }


    @Override
    public LatLng getPosition() {
        return clusterOptions.position;
    }

    @Override
    public void setData(String data) {
        clusterOptions.setData(data);
    }

    @Override
    public String getData() {
        return clusterOptions.data;
    }

}
