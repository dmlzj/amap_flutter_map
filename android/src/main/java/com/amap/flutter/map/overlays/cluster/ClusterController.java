package com.amap.flutter.map.overlays.cluster;

import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yiyi.qi on 16/10/10.
 */

public class ClusterController implements ClusterOptionsSink {


    private LatLng mLatLng;
    private List<ClusterOptionsSink> mClusterItems;
    private Marker mMarker;


    ClusterController() {

//        mLatLng = latLng;
        mClusterItems = new ArrayList<ClusterOptionsSink>();
    }

    void addClusterItem(ClusterOptionsSink clusterItem) {
        mClusterItems.add(clusterItem);
    }

    int getClusterCount() {
        return mClusterItems.size();
    }



    LatLng getCenterLatLng() {
        return mLatLng;
    }

    void setMarker(Marker marker) {
        mMarker = marker;
    }

    Marker getMarker() {
        return mMarker;
    }

    List<ClusterOptionsSink> getClusterItems() {
        return mClusterItems;
    }



    @Override
    public void setPosition(LatLng position) {
        mLatLng = position;
    }


    @Override
    public LatLng getPosition() {
        return mLatLng;
    }
}
