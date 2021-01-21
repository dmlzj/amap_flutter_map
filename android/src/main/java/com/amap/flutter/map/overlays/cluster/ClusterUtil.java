package com.amap.flutter.map.overlays.cluster;
import android.text.TextUtils;
import com.amap.flutter.map.utils.ConvertUtil;

import java.util.Map;

/**
 * @author whm
 * @date 2020/11/6 8:06 PM
 * @mail hongming.whm@alibaba-inc.com
 * @since
 */
public class ClusterUtil {
    public static String interpretClusterOptions(Object o, ClusterOptionsSink sink) {
        if (null == o) {
            return null;
        }
        final Map<?, ?> data = ConvertUtil.toMap(o);

//        final Object infoWindow = data.get("infoWindow");
//        if (infoWindow != null) {
//            interpretInfoWindowOptions(sink, (Map<String, Object>) infoWindow);
//        }
        final Object position = data.get("position");
        if (position != null) {
            sink.setPosition(ConvertUtil.toLatLng(position));
        }

        final String clusterId = (String) data.get("id");
        if (clusterId == null) {
            throw new IllegalArgumentException("clusterId was null");
        } else {
            return clusterId;
        }
    }

//    private static void interpretInfoWindowOptions(
//            ClusterItem sink, Map<String, Object> infoWindow) {
//        String title = (String) infoWindow.get("title");
//        String snippet = (String) infoWindow.get("snippet");
//        // snippet is nullable.
//        if (!TextUtils.isEmpty(title)) {
//            sink.setTitle(title);
//        }
//        if (!TextUtils.isEmpty(snippet)) {
//            sink.setSnippet(snippet);
//        }
//    }
}
