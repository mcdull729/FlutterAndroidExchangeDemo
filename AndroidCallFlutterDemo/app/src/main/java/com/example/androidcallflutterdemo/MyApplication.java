package com.example.androidcallflutterdemo;

import android.app.Application;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

/**
 * @author: ping.sir
 * @data: 17:10
 * @desc:
 */
public class MyApplication extends Application {
    private FlutterEngine flutterEngine;

    @Override
    public void onCreate() {
        super.onCreate();
        //预热flutter引擎
        flutterEngine = new FlutterEngine(this);

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );

        //预热flutter 引擎的方式
        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache
                .getInstance()
                .put("my_engine_id", flutterEngine);
    }

}
