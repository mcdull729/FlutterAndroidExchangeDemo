package com.example.androidcallflutterdemo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterView;

public class MainActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        findViewById(R.id.btn_show_flutter).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //原生调用flutter页面，并显示
                startActivity(
                        FlutterActivity.createDefaultIntent(MainActivity.this)
                );
            }
        });

        //跳转到flutter的指定路由页面
        findViewById(R.id.btn_show_route_flutter).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(
                        FlutterActivity
                                .withNewEngine()
                                .initialRoute("second_page")
                                .build(MainActivity.this)
                );
            }
        });

        //采用预热引擎的方式，可以加快flutter页面构建时间
        findViewById(R.id.btn_show_engine_flutter).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(
                        FlutterActivity
                                .withCachedEngine("my_engine_id") //这里的引擎ID要和application里的保持一致
                                .build(MainActivity.this)
                );
            }
        });
    }
}
