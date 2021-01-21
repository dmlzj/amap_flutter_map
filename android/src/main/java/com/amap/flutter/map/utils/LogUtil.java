package com.amap.flutter.map.utils;

import android.util.Log;


/**
 * @author whm
 * @date 2020/11/6 11:04 AM
 * @mail hongming.whm@alibaba-inc.com
 * @since
 */
public class LogUtil {
    private static final boolean DEBUG = false;
    private static final String TAG = "AMapFlutter_";
    public static void i(String className, String message) {
        if(DEBUG) {
            Log.i(TAG+className, message);
        }
    }
    public static void d(String className, String message) {
        if(DEBUG) {
            Log.d(TAG+className, message);
        }
    }

    public static void w(String className, String message) {
        if(DEBUG) {
            Log.w(TAG+className, message);
        }
    }


    public static void e(String className, String methodName, Throwable e) {
        if (DEBUG) {
            Log.e(TAG+className, methodName + " exception!!", e);
        }
    }

}
