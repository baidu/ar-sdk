# iOS SDK Pro版
(请至官网下载最新SDK：https://ai.baidu.com/sdk#ar)
# 简介

本文档主要介绍基于DuMix AR iOS SDK Pro版进行开发。

**【必需】创建百度AR试用应用授权：**
请先前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情，[点击此处](https://ar.baidu.com/testapply)（需登录）创建您的试用应用授权，后续SDK鉴权需用到相关信息。

# 运行环境

- iOS: 8.0 以上
- 架构：arm64（代码可通过 `[BARSDKPro isSupportAR]` 来判断当前设备是否支持AR功能）。

# SDK目录结构

目前只支持静态库链接
SDK目录如下:

```
-核心功能
|-DumixARCore.a          // Required DuMixARSDK

-组件能力
|-AR-TTS                 // Optional 百度TTS相关的部分，若您不使用该功能，该模块不需要添加
|-AR-Voice               // Optional 百度语音相关的部分，若您不使用该功能，该模块不需要添加
|-AR-ImageSearch         // Optional 百度识图功能，若您不使用该功能，该模块不需要添加
|-paddle                 // Optional 百度手势识别功能，若您不使用该功能，该模块不需要添加
```

# SDK集成步骤

## 第1步：创建AR应用

**创建百度AR<mark>试用应用授权</mark>**

请先前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情，[点击此处](https://ar.baidu.com/testapply)（需登录）创建您的试用应用授权:
![图片](http://agroup-bos.su.bcebos.com/d3c968535a3d2b1d64bddde91b38058373273501)

## 第2步：添加FrameWorks

```
-系统库
|-libz.tbd
|-libc++.tbd
|-Accelerate.framework
|-libsqlite3.0.tbd 
|-libstdc++.6.0.9.tbd        
|-libsqlite3.0.tbd
|-libiconv.tbd (语音/TTS能力需要)
-第三方库
|-libBaiduSpeechSDK.a（如果需要语音能力，需要集成）
|-libBaiduTTSSDK.a（如果需要TTS能力，需要集成）
```

## 第3步：设置工程配置

1、相机权限-需要在info.plist中添加 Privacy - Camera Usage Description，
麦克风权限-添加 Privacy - Microphone Usage Description，
如果需要相册权限-需要在info.plist中添加 Privacy - Photo Library Additions Usage Description

2、请设置工程的 Bundle Identifer ，内容为您创建应用时的iOS包名。

3、在工程设置中选择Build Settings，搜索 Other Linker Flags  并设置 -ObjC、-force_load、`your arsdk path`/libpaddle_capi_layers.a ，其中`your arsdk path`/libpaddle_capi_layers.a的路径配置是可选项，若您不想集成手势识别功能，您`不`需要在工程中添加paddle的文件，也`不`要设置该路径，详细请参照Demo工程。

## 第4步：设置AppID、APIKey

```
//说明：初始化AppID、APIKey

#define APP_ID       @"您创建应用的 AppID"   
#define API_KEY      @"您创建应用的 API_KEY"

通过函数[BARSDKPro setAppID: APP_ID APIKey: API_KEY andSecretKey:@""]

```

# API介绍


## BARMainController

AR控制器（处理相机samplebuffer、case管理等）

```
self.arController = [[BARMainController alloc] initARWithCameraSize:self.renderVC.cameraSize previewSize:self.renderVC.previewSizeInPixels];
[self.arController setDevicePosition:[self.renderVC devicePosition]];

```

* 初始化

```
/**
 初始化方法

 @param cameraSize 相机尺寸
 @param previewSize 预览尺寸
 @return BARMainController实例
 */
- (id)initARWithCameraSize:(CGSize )cameraSize previewSize:(CGSize)previewSize;
```

* 资源管理

```
/**
 下载AR资源包

 @param arKey case key
 @param progress 下载进度block
 @param complete 下载完成block
 */
- (void)downloadARCase:(NSString *)arKey
    downLoadProgress:(BARDownloadARCaseProgressBlock)progress
            complete:(BARDownloadARCaseCompleteBlock)complete;

/**
 取消下载AR资源包
 */
- (void)cancelDownLoadArCase;
```

* AR控制

```
/**
加载AR
 */
- (void)loadAR:(NSString *)arKey success:(BARLoadSuccessBlock)successBlock
 failure:(BARLoadFailedBlock)failureBlock;
 
 /**
  从本地路径加载AR

 @param filePath case资源包路径,下载并解压完后的路径：比如 ../bar_10070173/ar/...，传递的参数filePath为../bar_10070173
 @param arType case对应的artype
 @param successBlock 加载成功回调
 @param failureBlock 加载失败回调：case包有问题或者鉴权失败
 */
- (void)loadARFromFilePath:(NSString *)filePath arType:(NSString *)arType success:(BARLoadSuccessBlock)successBlock failure:(BARLoadFailedBlock)failureBlock;

/**
 启动AR
 */
- (void)startAR;

/**
 停止AR
 */
- (void)stopAR;

/**
 暂停AR
 */
- (void)pauseAR;

/**
 恢复AR
 */
- (void)resumeAR;

/**
 销毁case
 */
- (void)destroyCase:(dispatch_block_t)destroyFinish;


```

* 相机操作

```
/**
 改变帧率

 @param frameRate 帧率
 */
- (void)changeFrameRate:(NSInteger)frameRate;

/**
 @param sampleBuffer 相机数据
 @return bgra 数据
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 *  设置是否是前置摄像头
 */

- (void) changeToFrontCamera:(BOOL) front;
/**
 设置render容器

 @param targetView 目标view
 */
- (void)setTargetView:(BARImageView *)targetView ;


/**
 设置AR输出格式

 @param type
        BAROutputBlend,
        BAROutputVideo,
        BAROutputEngine,
 */
- (void)setBAROutputType:(BAROutput)type;


/**
 设置相机size、预览size数据

 @param cameraSize 相机尺寸
 @param previewSize 预览尺寸
 */
- (void)setArCameraSize:(CGSize)cameraSize previewSize:(CGSize)previewSize;

```

* 拍摄

```
/**
 拍摄

 @param finishBlock 拍照回调 返回UIImage
 */
- (void)takePicture:(BARTakePictureFinishBlock)finishBlock;

```

* 消息

```
/**
该回调会接受case发出的消息,类型说明如下
 
BARMessageTypeNone                    = -1,
BARMessageTypeCustom                 = 1000,//自定义
BARMessageTypeOpenURL                 = 1001,//打开URL
BARMessageTypeEnableFrontCamera       = 1002,//开启前置摄像头
BARMessageTypeChangeFrontBackCamera   = 1003,//前后摄像头切换
BARMessageTypeIntitialClick           = 1004,//引导页点击
BARMessageTypeNativeUIVisible         = 1005,//Native UI处理（显示、隐藏）
BARMessageTypeCloseAR                 = 1006,//关闭AR
BARMessageTypeShowAlert               = 1007,//弹出alert
BARMessageTypeShowToast               = 1008,//弹出toast
BARMessageTypeSwitchCase              = 1009,//切换case
BARMessageTypeLogoStart               = 1010,//Logo识别开始
BARMessageTypeLogoStop                = 1011,//Logo识别结束
BARMessageTypeBatchDownloadRetryShowDialog = 1012,//分布加载batch包(失败后弹窗)
 
 */
 @property (nonatomic, copy) BARLuaMsgBlock luaMsgBlock;

/**
 向lua发送消息

 @param eventName 消息名
 @param msgData 消息内容
 @discussion lua中通过注册监听，获得消息Event:addEventListener("session_find_anchor", find_anchor)
 */
- (void)sendMsgToLua:(NSString *)eventName msgData:(NSDictionary *)msgData;


/**
该回调会接受运行时AR的消息,类型说明如下
BARSDKUIState_UnKnown = -1,
BARSDKUIState_TrackOn,  				//跟上
BARSDKUIState_TrackLost_HideModel, 	//跟丢隐藏模型
BARSDKUIState_TrackLost_ShowModel,   //跟丢显示模型
BARSDKUIState_TrackTimeOut,			 //跟踪超时
BARSDKUIState_DistanceNormal,        //距离正常
BARSDKUIState_DistanceTooFar,        //距离过近
BARSDKUIState_DistanceTooNear,       //距离过远
*/

@property (nonatomic, copy) BARSDKUIStateEventBlock uiStateChangeBlock;

```

## BARVideoRecorder

录制视频类

```
/**
开始录制
@param enable 是否带音频
	
*/
- (void)startRecordingWithAudioTrack:(BOOL)enable;

/**
 录制视频时，需要设置movieWriter 停止录制时传nil

 @param movieWriter 视频录制
 */
- (void)setRenderMovieWriter:(BARImageMovieWriter *)movieWriter;

/**
停止录制
@param handler 停止录制回调
*/
- (void)stopRecording:(void (^)(void))handler;

```

## BARCaseTask

下载AR资源包的工具类，可以在程序内做预下载功能


```
/**
下载进度回调
@param task task类
@param downloadProgress 下载进度
*/
- (void)caseTask:(BARCaseTask *)task downloadProgress:(float)downloadProgress;

/**
下载完成回调
@param task task类
@param taskResult 下载结果
@param error 下载错误
*/
- (void)caseTask:(BARCaseTask *)task taskResult:(NSDictionary *)taskResult error:(NSError *)error;

/**
查询完成回调
@param task task类
*/
- (void)caseTaskQueryArResourceSuccess:(BARCaseTask *)task;

/**
查询销毁回调
@param task task类
*/
- (void)caseTaskDealloc:(BARCaseTask *)task;	

具体预下载&本地加载请参考Demo中代码BARCaseTask相关部分

```


# 能力组件

## 语音识别

- setupARVoice

需要将Demo中的BDVoice、以及libAR-SClientSDK.a、libiconv.tbd加入工程中。


```
    self.voiceConfigure = [[BARRouter sharedInstance] voice_createVoiceConfigure];
    [[BARRouter sharedInstance] voice_setStopBlock:^{
        NSLog(@"voiceStop");
    } withConfigure:self.voiceConfigure];
    
    
    [[BARRouter sharedInstance] voice_setStartBlock:^(BOOL success){
        NSLog(@"voiceStart");
    } withConfigure:self.voiceConfigure];
```

## TTS

- setUpTTS

需要将Demo中的BDTTS、以及libAR-TTS.a、libiconv.tbd加入工程中。

```
- (void)setUpTTS {
    [[BARRouter sharedInstance] setUpTTS];
}
```

## 识图

- setUpSameSearch

1. kBARTypeCloudSameSearch：云端识图  
1. kBARTypeLocalSameSearch：本地识图


```
self.searchModule = [[BARRouter sharedInstance] imageSearch_initWithARType:kBARTypeCloudSameSearch];
[[BARRouter sharedInstance] imageSearch_loadSameSearchWithCaller:self.searchModule];
        [[BARRouter sharedInstance] imageSearch_setResultBlock:^(id  _Nonnull result) {
            if (result && [result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = result;
                NSString *arKey = dic[@"arKey"];
                NSString *arType = dic[@"arType"];
                if (arKey && arType && weakSelf) {
                    //识别到ARKey&ARType，加载AR
                    weakSelf.arKey = arKey;
                    weakSelf.arType = arType;
                    [weakSelf stopSameSearch];
                    [weakSelf loadAR:nil];
                }
            }
        } withCaller:self.searchModule];
        
        
[[BARRouter sharedInstance] imageSearch_setErrorBlock:^(NSError * _Nonnull error){
 } withCaller:self.searchModule];

```

# Demo业务逻辑类 

## BARBusinessDemoViewController

业务控制类,集成方可自定义

```
case的几个操作流程如下：
加载AR --> 下载AR资源包并且加载AR
启动AR --> 加载AR成功后，调用startAR

flow
st=>start: viewDidLoad:>
e=>end:>

op1=>operation: setupARView
op2=>operation: setupARController
op3=>operation: setupComponents

st->op1->op2->op3->e

```

## BARRenderViewController

相机控制器，集成方可自定义相机

```    
self.renderVC = [[BARRenderViewController alloc] init];
self.renderVC.aspect = ASPECT_RATIO;
self.renderVC.dataSource = self;
self.renderVC.isLandscape = self.isLandscape;
CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
self.renderVC.frame = CGRectMake(0, 0, screenWidth, screenHeight);
[self addChildViewController:self.renderVC];
[self.view addSubview:self.renderVC.view];
self.renderVC.view.backgroundColor = [UIColor clearColor];
[self.renderVC didMoveToParentViewController:self];
```

## BARRenderViewControllerDataSource

* 相机回调

```
/**
 将相机流数据传给MainController，进行渲染处理

 @param srcBuffer 相机流原始数据
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)srcBuffer;

/**
 录制视频时，将音频数据传给BARVideoRecorder

 @param srcBuffer 音频数据
 */
- (void)updateAudioSampleBuffer:(CMSampleBufferRef)srcBuffer;
```

* property

```
@property (strong, nonatomic) UIView *arContentView;//AR视图容器
@property (nonatomic, assign) CGSize previewSizeInPixels;//预览尺寸
@property (nonatomic, assign) CGSize cameraSize;//相机尺寸
@property (nonatomic, assign) CGFloat aspect;//屏占比
@property (nonatomic, strong) BARGestureImageView *videoPreviewView;//AR渲染view
@property (nonatomic, assign) BOOL isLandscape;//是否横屏
```

# 版本更新说明

**DuMix AR iOS SDK 2.4.1 Pro版-2018年7月** 
新增本地内容接口






