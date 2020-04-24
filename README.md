# FlutterAndroidExchangeDemo
在开发项目过程中，发现第三方SDK并未提供flutter版，因此需要研究flutter与native交互并获取native方法返回的结果。因此做记录如下：

还是参考Flutter中文网https://flutterchina.club/platform-channels/ 的内容来操作。具体如下：

#1、Flutter平台特定的API支持不依赖于代码生成，而是依赖于灵活的消息传递方式
》Flutter部分可以通过Platform channel将消息发送到应用程序所在的宿主（Android or Ios）上；
》宿主（Android or IOS）通过监听Platform channel，并接收该消息，然后调用宿主平台特定的API（也就是Android原生编程语言或者IOS原生编程语言）来进行native端的调用，并将响应发送给应用的Flutter代码部分。

#2、在Flutter部分，通过MethodChannel可以发送方法调用相对应的消息；在native部分，通过MethodChannel（Android）或FlutterMethodChannel（IOS）来接收方法调用并返回结果。这就OK了

# 以原有代码为Flutter开发，需要接入Android SDK并调用：
      a.> 通过Android Studio（以下简称为AS）控制面板的 File -> open... -> 定位到Flutter项目目录下，选择里面的 android 文件夹，点击  OK。！！！切记！！！操作步骤必须是这样，否则项目永远都会报错！！！
      b.> 在AS中就可以操作 Java 代码了，跟Android 原生开发一样即可。
      c.> 当我需要在A activity打开B activity，并获取 B activity返回的值时，我利用了handler，在A activity的onActivityResult方法中，通过handler将消息发送到MethodChannel的onMethodCall回调中。
      d.> flutter中文网上推荐使用getFlutterView()，而在我的代码中，FlutterActivity并没有该方法。查看源码，发现可以用getFlutterEngine().getDartExecutor().getBinaryMessenger()来代替。
      
      代码实现：
      在Android代码部分，需要定义一个String类型的channel字段常量，与Flutter部分定义的字段常量保持一致：private static final String CHANNEL  = "samples.flutter.io/battery";
      new 一个MethodChannel的匿名对象，在onMethodCall方法回调中：
                       if (call.method.equals("openSecondActivity")) {
                            openSecondActivity();
                            mHandler = new Handler() {
                                @Override
                                public void handleMessage(Message msg) {
                                    super.handleMessage(msg);
                                    returnData = (String) msg.obj;
                                    if (returnData != "" && returnData != null) {
                                        result.success(returnData);
                                    } else {
                                        result.error("UNAVAILABLE", "openSecondActivity not available.", null);
                                    }
                                }
                            };

                        } else {
                            result.notImplemented();
                        }
      在onCreate方法外，写一个openSecondActivity()方法
      private void openSecondActivity() {
        Intent intent = new Intent(this, SecondActivity.class);
        intent.putExtra("option", "openSecondActivity");
        startActivityForResult(intent, 100);
      }
      在Activity的onActivityResult方法中，获取第二个页面的返回值
      @Override
      protected void onActivityResult(int requestCode, int resultCode, Intent data) {
          super.onActivityResult(requestCode, resultCode, data);
          //        if (requestCode == 100 && resultCode == RESULT_OK) {
          returnData = data.getStringExtra("return_data");
          Log.e("tag", data.getStringExtra("return_data"));
          Message msg = Message.obtain();
          msg.obj = returnData;
          mHandler.sendMessage(msg);
          //        }
      }
      
      在flutter 部分
      Future<String> _getSecondActivity() async{
        String returnData;
        try{
          returnData = await platform2.invokeMethod('openSecondActivity');
        }catch(e){
          returnData = "获取失败 $e";
          print("error $e");
        }
        setState(() {
          _returnData = returnData;
        });
      }
      
      RaisedButton(onPressed: _getSecondActivity,child: Text("打开第二个页面并获取返回值"),),
      Text("获取到的返回值为 $_returnData"),
      
      
# 以Android原生代码为基础，接入Flutter开发
  参考Flutter 官网： https://flutter.dev/docs/development/add-to-app/android/project-setup
  API参考Flutter官网： https://flutter.dev/docs/development/add-to-app/android/add-flutter-screen
  
  1> 在原有项目中，点击AS控制面板上的 File -> new module -> 选择 flutter module ，然后一路next即可
  2> 在Menifest文件中，添加如下代码：
    <activity
    android:name="io.flutter.embedding.android.FlutterActivity"
    android:theme="@style/LaunchTheme"
    android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
    android:hardwareAccelerated="true"
    android:windowSoftInputMode="adjustResize"
    />
  3> 在调用页面，按照下面的操作进行：
  a. 启动默认页面
  
    startActivity(
      FlutterActivity.createDefaultIntent(currentActivity)
    );
  b. 启动自定义路由页面
  
      startActivity(
        FlutterActivity
          .withNewEngine()
          .initialRoute("my_route")
          .build(currentActivity)
      );
  c. 启动预热引擎的页面
  
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

  
  
