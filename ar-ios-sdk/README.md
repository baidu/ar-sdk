# 简介
本文档主要介绍基于DuMix AR iOS SDK专业版进行开发。在使用本文档前，请确认并已经开通了AR服务（您可以在 DuMix AR官网 的“开放平台”页面申请开通AR服务）。
# 运行环境
- iOS: 8.0 以上
- 架构：arm64（代码可通过 `[BaiduARSDK isSupportAR]` 来判断当前设备是否支持AR功能）。
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
# 添加FrameWorks
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
# 隐私配置
相机权限-需要在info.plist中添加 Privacy - Camera Usage Description，
麦克风权限-添加 Privacy - Microphone Usage Description，
如果需要相册权限-需要在info.plist中添加 Privacy - Photo Library Additions Usage Description
1、请设置工程的 Bundle Identifer ，内容为您创建应用时的iOS包名。

2、在工程设置中选择Build Settings，搜索 Other Linker Flags  并设置 -ObjC、-force_load、`your arsdk path`/libpaddle_capi_layers.a ，其中`your arsdk path`/libpaddle_capi_layers.a的路径配置是可选项，若您不想集成手势识别功能，您`不`需要在工程中添加paddle的文件，也`不`要设置该路径，详细请参照Demo工程。

3、证书设置：
 
> <mark>**如果您用的是正式版:**</mark>
> 
>&ensp;&ensp;&ensp;&ensp;创建完AR应用后，在“应用详情”页面下载license文件，并将license文件放到您应用的工程目录中（license文件名称必须为：aip.license ）

> <mark>**如果您用的是试用版：**</mark>
> 
> &ensp;&ensp;&ensp;&ensp;不要添加 aip.license 文件，并确保工程中无此文件

# 设置APIKey、SecretKey

通过函数[BARSDKPro setAppID:@"" APIKey:@"" andSecretKey:@""]初始化APIKey、SecretKey

# 业务逻辑 BARBusinessDemoViewController

case的几个操作流程如下：
加载AR --> 下载AR资源包并且加载AR
启动AR --> 加载AR成功后，调用startAR

##基础模块

```flow
st=>start: viewDidLoad:>
e=>end:>

op1=>operation: setupARView
op2=>operation: setupARController
op3=>operation: setupComponents

st->op1->op2->op3->e

```

###BARRenderViewController
BARRenderViewController --> 相机控制器，业务方可自定义相机

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

BARRenderViewControllerDataSource
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
property

```
@property (strong, nonatomic) UIView *arContentView;//AR视图容器
@property (nonatomic, assign) CGSize previewSizeInPixels;//预览尺寸
@property (nonatomic, assign) CGSize cameraSize;//相机尺寸
@property (nonatomic, assign) CGFloat aspect;//屏占比
@property (nonatomic, strong) BARGestureImageView *videoPreviewView;//AR渲染view
@property (nonatomic, assign) BOOL isLandscape;//是否横屏
```
###BARMainController
BARMainController --> AR控制器（处理相机samplebuffer、case管理等）

```
self.arController = [[BARMainController alloc] initARWithCameraSize:self.renderVC.cameraSize previewSize:self.renderVC.previewSizeInPixels];
[self.arController setDevicePosition:[self.renderVC devicePosition]];

```
初始化
```
/**
 初始化方法

 @param cameraSize 相机尺寸
 @param previewSize 预览尺寸
 @return BARMainController实例
 */
- (id)initARWithCameraSize:(CGSize )cameraSize previewSize:(CGSize)previewSize;
```
资源管理
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
AR控制
```
/**
加载AR
 */
- (void)loadAR:(NSString *)arKey success:(BARLoadSuccessBlock)successBlock
 failure:(BARLoadFailedBlock)failureBlock;

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
- (void)destroyCase;
```
相机操作

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
        BAROutputBlend ,
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

消息

```
/**
 获得消息
 */
 @property (nonatomic, copy) BARLuaMsgBlock luaMsgBlock;

/**
 向lua发送消息

 @param eventName 消息名
 @param msgData 消息内容
 @discussion lua中通过注册监听，获得消息Event:addEventListener("session_find_anchor", find_anchor)
 */
- (void)sendMsgToLua:(NSString *)eventName msgData:(NSDictionary *)msgData;

```
##能力组件
###语音识别
- setupARVoice
<!--需要将Demo中的BDVoice、以及libAR-SClientSDK.a、libiconv.tbd加入工程中-->
```
    self.voiceConfigure = [[BARRouter sharedInstance] voice_createVoiceConfigure];
    [[BARRouter sharedInstance] voice_setStopBlock:^{
        NSLog(@"voiceStop");
    } withConfigure:self.voiceConfigure];
    
    
    [[BARRouter sharedInstance] voice_setStartBlock:^(BOOL success){
        NSLog(@"voiceStart");
    } withConfigure:self.voiceConfigure];
```
###TTS
- setUpTTS
<!--需要将Demo中的BDTTS、以及libAR-TTS.a、libiconv.tbd加入工程中-->

```
- (void)setUpTTS {
    [[BARRouter sharedInstance] setUpTTS];
}
```
###识图
- setUpSameSearch
<!--kBARTypeCloudSameSearch：云端识图  kBARTypeLocalSameSearch：本地识图-->

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




