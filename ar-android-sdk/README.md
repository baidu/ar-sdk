# 开发文档

本文档主要介绍基于DuMix AR Android SDK专业版进行开发。在使用本文档前，请确认并已经开通了AR服务（您可以在 [DuMix AR官网](https://dumix.baidu.com) 的“开放平台”页面申请开通AR服务）。

# 快速入门

支持的系统和硬件版本

- 系统：支持 Android 4.4（API Level 19）到Android8.0（API Level 26）系统。需要开发者通过minSdkVersion来保证支持系统的检测。
- CPU架构：armeabi-v7a，arm64-v8a
- 硬件要求：要求设备上有相机模块，CPU 4核及以上，内存2G及以上。
- 网络：支持WIFI及移动网络，移动网络支持使用NET网关及WAP网关（CMWAP、CTWAP、UNIWAP、3GWAP）。

## SDK集成步骤

### 第1步：导入jar包和so库
将解压后的 libs 文件夹中的 dumixar.jar 拷贝到您的工程的 libs 文件夹中，并检查编译依赖。
将解压后的 libs 文件夹中的arm64-v8a和armeabi-v7a文件夹拷贝到Android Studio工程`src/main/jniLibs`目录中。

### 第2步：导入资源
将解压后的 res 文件夹中的所有资源拷贝到您的工程中对应的资源文件夹中。

### 第3步：配置Mannifest文件，添加必要的权限

```
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<uses-feature android:name="android.hardware.camera"/>
<uses-feature android:name="android.hardware.camera.autofocus"/>
```

### 第4步：在代码中配置aip权限

```
// 设置App Id
DuMixARConfig.setAppId("xxxx");
// 设置API Key
DuMixARConfig.setAPIKey("xxxxxxxx");
// 设置Secret Key
DuMixARConfig.setSecretKey("xxxxx");
```
### 第5步：在代码中启动AR

```
arControler.setup(DuMixSource source, DuMixTarget target, DuMixCallback callback)
```
其他API及参数说明参考 [API文档](https://github.com/baidu/ar-sdk/wiki/android-sdk-%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E)


