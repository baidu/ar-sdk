# 简介

本文档主要介绍基于DuMix AR Android SDK Pro版进行开发。

**【必需】创建百度AR试用应用授权：**
请先前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情，[点击此处](https://ar.baidu.com/testapply)（需登录）创建您的试用应用授权，后续SDK鉴权需用到相关信息。

# 快速入门

支持的系统和硬件版本

- 系统：支持 Android 4.4（API Level 19）到Android8.0（API Level 26）系统。需要开发者通过minSdkVersion来保证支持系统的检测。
- CPU架构：armeabi-v7a，arm64-v8a
- 硬件要求：要求设备上有相机模块，CPU 4核及以上，内存2G及以上。
- 网络：支持WIFI及移动网络，移动网络支持使用NET网关及WAP网关（CMWAP、CTWAP、UNIWAP、3GWAP）。

## 开发包说明

    DuMix AR Android SDK Pro版.zip
        |- libs                                   // lib库，包括各平台的so库及jar包。
        |- sample                                 // sample code
        |- Pro版Android文档.md                     // 说明文档

SDK提供的demo工程以Android Studio方式提供。

## SDK集成步骤

### 第1步：导入jar包和so库
将libs文件夹中的 dumixar.jar 拷贝到您的工程的 libs 文件夹中，并检查编译依赖。
将libs文件夹中的arm64-v8a和armeabi-v7a文件夹拷贝到Android Studio工程`src/main/jniLibs`目录中。

### 第2步：配置Mannifest文件，添加必要的权限

```java
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

### 第3步：创建AR应用


***创建百度AR试用应用授权**
请先前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情，[点击此处](https://ar.baidu.com/testapply)（需登录）创建您的试用应用授权:
![图片](http://agroup-bos.su.bcebos.com/d3c968535a3d2b1d64bddde91b38058373273501)


### 第5步：初始化相关参数

初始化参数示例代码如下：

```
// 设置您的App Id
DuMixARConfig.setAppId("您的App Id");
// 设置API Key
DuMixARConfig.setAPIKey("您的API Key");

```

注1：在试用版中，Secret Key不需要设置。
注2：在试用版中，assets目录中不能存在名字为【aip.license】的文件。

### 第5步：在代码中启动AR

初始化 arControler
```java
arControler = new ARControler(context);
```
启动 ar
```java
arControler.setup(DuMixSource source, DuMixTarget target, DuMixCallback callback)
```
设置 Camera 预览帧
```java
mARController.onCameraPreviewFrame(data, width, height);
```
注：关于Camera功能的操作，Demo已封装了Camera的Module,开发者可以直接使用或替换项目中已有的Camera。

DuMixSource:  AR输入参数类
```
// ar场景的唯一标示ID
private String mArKey;

// 如果是百度服务器下载资源，则以下两个参数无需设置
// ar场景类型，目前支持Track，IMU，SLAM
private int mArType = -1;
// ar场景所需要的资源
private String mResFilePath;

// 如果最终输出不需要绘制相机数据，以下三个参数则无需设置
// 相机数据输入
private boolean mFrontCamera = false;
private SurfaceTexture mCameraSource;
private int mSourceWidth = 0;
private int mSourceHeight = 0;
```
#### AR类型说明

| 类型      |    Type | 说明  |
| :-------- | :--------:| :--: |
| 2D跟踪类型  | 0 | 对平面图像进行即时识别和跟踪，可基于商品外包装、宣传海报、印刷品、服饰图案等局部图片触发AR内容|
| SLAM类型   | 5 | 即时定位与跟踪的AR效果，将AR内容自然地呈现在现实空间中，应用于3D人物角色、商品模型展示等场景。 |
| 本地识图    | 6 |  在手机端进行图像识别检索，用于实现基于2D图片的AR内容识别触发。 |
| 云端识图    | 7 | 云端图像识别检索，用于实现基于2D图片的AR内容识别触发。  |
| IMU类型     | 8|基于手机IMU，实时获取手机在空间中的相对位置和姿态，将AR内容定位呈现在手机当前所处的三维空间中|
DuMixTarget:  AR返回参数类
```
// ar绘制目标，用于将最终绘制完的图像返回
private SurfaceTexture mDrawTarget;
private SurfaceTexture.OnFrameAvailableListener mTargetFrameAvailableListener;
// 返回目标的宽高
private int mTargetWidth;
private int mTargetHeight;
// 绘制返回目标变形控制
private ScaleType mScaleType;
// 是否绘制相机背景
private boolean mDrawPreview;
```

#DuMixCallback接口回调说明

```
/**
 * 百度AR内部流程状态返回
 *
 * @param state 内部流程状态，用于被动状态返回
 * @param data  外部需要的相关信息，比如提示字符串等
 */
void onStateChange(int state, Object data);

/**
 * lua消息透传给上层的接口
 *
 * @param luaMsg lua消息
 */
void onLuaMessage(HashMap<String, Object> luaMsg);

/**
 * 百度AR内部错误状态返回
 *
 * @param error 内部错误状态，用于被动状态返回
 * @param msg   内部错误信息
 */
void onStateError(int error, String msg);

/**
 * 百度AR启动结果返回
 *
 * @param result 是否成功
 */
void onSetup(boolean result);

/**
 * AR场景切换结果返回
 *
 * @param result 是否成功
 */
void onCaseChange(boolean result);

/**
 * AR case创建成功
 *
 * @param arResource 创建的arResource资源
 */
void onCaseCreated(ARResource arResource);

/**
 * AR场景暂停返回
 *
 * @param result 是否成功
 */
void onPause(boolean result);

/**
 * AR场景恢复返回
 *
 * @param result 是否成功
 */
void onResume(boolean result);

/**
 * AR场景重置，恢复初始状态
 *
 * @param result 是否成功
 */
void onReset(boolean result);

/**
 * 百度AR结束结果返回
 *
 * @param result 是否成功
 */
void onRelease(boolean result);
```

##onStateChange 状态说明
| 类型      | 字段（MsgField）|   ID | 说明  |
| :-------- | :-------- | :--------:| :--: |
| 通用型  |MSG_ON_QUERY_RESOURCE| 2300 | 开始查询资源|
|        |MSG_ON_QUERY_RESOURCE_ERROR| 2301 | 资源查询出错|
|        |MSG_ON_DOWNLOAD_SO| 2302 | 开始下载so文件|
|        |MSG_ON_DOWNLOAD_SO_ERROR| 2303 | 下载so库文件出错|
|        |MSG_ON_DOWNLOAD_RES| 23031 | 开始下载资源|
|        |MSG_ON_DOWNLOAD_RES_SUCCESS| 2304 | 资源下载成功|
|        |MSG_ON_DOWNLOAD_RES_ERROR| 2305 | 资源下载出错|
|SO资源   |IMSG_SO_LOAD_SUCCESS| 1201 | SO加载成功|
|        |IMSG_SO_LOAD_FAILED| 1202 | SO加载失败|
|解析资源 |MSG_ON_PARSE_RESOURCE_UNZIP_ERROR| 4202 | 解压ZIP错误|
|        |MSG_ON_PARSE_RESOURCE_JSON_ERROR | 4203 | 解析资源json错误|
|识图     |IMSG_ON_DEVICE_IR_START| 1806 | 本地识图初始化成功|
|        |IMSG_CLORD_ID_START| 1807 | 云端识图初始化成功|
|        |MSG_ON_DEVICE_IR_RESULT| 2503 | 本地识图返回结果成功|
|        |IMSG_CLOUDAR_RECG_RESULT| 2106 | 云端识图返回结果成功|
|模型     |IMSG_MODEL_LOADED| 1817 | 模型加载成功|
|        |IMSG_MODE_SHOWING| 2101 | 模型展示|
|        |MSG_ID_TRACK_MODEL_CAN_DISAPPEARING| 2104 | 模型隐藏|
|鉴权    |MSG_AUTH_FAIL| 1111 | 鉴权失败|
|Track识图|IMSG_TRACK_LOST| 1812 | 跟踪丢失|
|         |IMSG_TRACK_FOUND| 1813 | 跟踪成功|
|         |IMSG_TRACK_DISTANCE_TOO_FAR|1814 | 跟踪距离过远|
|         |IMSG_TRACK_DISTANCE_TOO_NEAR|1815 | 跟踪距离过近|
|         |IMSG_TRACK_DISTANCE_NORMAL| 1816 | 跟踪距离正常|
|URL   |MSG_OPEN_URL| 2501 | 打开URL|
|分享   |MSG_SHARE| 2502 | 分享回调|
|版本异常  |MSG_ON_SDK_VERSION_LOW | 1801 | SDK版本过低|
|设备不支持AR   |IMSG_DEVICE_NOT_SUPPORT| 30001 | 设备不支持AR|
|网络   |IMSG_NO_NETWORK| 2511 | 网络未连接|

#接口说明

##下载Case 接口

    arKey：需要下载的内容id
    mARController.downloadCase(arKey, new ArCaseDownloadListener() {
                @Override
                public void onProgress(String s, int i) {
                  //下载进度
                }
                @Override
                public void onFinish(String s, boolean b, String s1) {
                 //下载成回调
                }
            });
##拍摄
	path: 拍照后图片文件保存路径
    mARController.takePicture(path, new TakePictureCallback() {
                @Override
                public void onPictureTake(final boolean result, final String filePath) {
                //result 拍照状态, filePath 返回路径
                }
            });
##录制
	path: 拍照后图片文件保存路径
    mARController.startRecord(path, mRecordMaxTime, new MovieRecorderCallback() {
                @Override
                public void onRecorderStart(boolean b) {
                // begin 开始录制
                }

                @Override
                public void onRecorderProcess(int i) {
                    // TODO: 2018/6/1 当进度大于100时停止录制
                }

                @Override
                public void onRecorderComplete(final boolean b, final String result) {
                // result b ,result：file path
                }

                @Override
                public void onRecorderError(int i) {
                // error
                }
            });
##停止录制

    mARController.stopRecord();

#Demo 说明

 1. Camera Module 对系统Camera进行的封装.包括打开，关闭和PreviewFrame的获取等接口。
 2. Speech Module  语音识别能力的封装
 3. TTS Modle         TTS能力封装

#注意事项
 4. DuMix AR引擎正常运行依赖必要的硬件基础，因此对硬件有一定的要求，对不满足的手机采用“黑名单”策略，也就是命中“黑名单”的手机会被屏蔽，不能正常使用DuMix AR。屏蔽依据的参数主要有内存大小，CPU核数，安卓版本等等手机基本信息；还有针对特殊机型的屏蔽，依据手机型号。
 5. DuMix AR SDK的 minSdkVersion为 19；targetSdkVersion 建议设为 24。
 6. AR内容平台的项目只有“审核通过”并执行“上线”后，才能通过SDK被调起。
 7. LOGO识别与其他功能组合使用时，请注意性能问题。

# 版本更新说明

**DuMix AR iOS SDK 2.4.1 Pro版-2018年7月**
 新增本地内容CASE加载能力、增加鉴权
<br>
