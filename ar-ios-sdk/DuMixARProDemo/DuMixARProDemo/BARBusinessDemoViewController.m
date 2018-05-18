//
//  ViewController.m
//  BaiduAROpenSDKProDemo
//
//  Created by Asa on 2018/3/8.
//  Copyright © 2018年 JIA CHUANSHENG. All rights reserved.
//

#import "BARBusinessDemoViewController.h"

#if defined (__arm64__)
#import "BARMainController.h"
#import "BARRenderViewController.h"
#import "BARRouter.h"
#import "BARSDKPro.h"
#import "BARRouter+BARVoice.h"
#import "BARRouter+BARPaddleGesture.h"
#import "BARRouter+BARImageSearchModule.h"
#import "BARVideoRecorder.h"
#import "BARMainController+Public.h"
#import "BARRouter+BARTTS.h"
#import "BARCaseTask.h"
#import "BARCaseManager.h"

#define IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ASPECT_RATIO (IPAD ? (4.0/3.0) : (16.0/9.0))

@interface BARBusinessDemoViewController ()<BARRenderViewControllerDataSource, UIAlertViewDelegate, BARCaseTaskDelegate,UINavigationControllerDelegate>
{
    BOOL _downloadFinished;
    BOOL _sameSearching;
    BOOL _recording;
    
}

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic,strong) NSArray *actinArray;
@property (nonatomic,strong) BARMainController *arController;
@property (nonatomic,strong) BARRenderViewController *renderVC;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, copy) NSString *arKey;
@property (nonatomic, copy) NSString *arType;

@property (nonatomic, strong) id voiceConfigure;
@property (nonatomic, strong) id searchModule;

@property (nonatomic, strong) BARVideoRecorder *videoRecorder;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *recorderButton;
@property (nonatomic, strong) UIButton *screenShotButton;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) dispatch_queue_t delegateQueue;
@property (nonatomic, strong) NSOperationQueue *taskQueue;
@property (nonatomic, strong) NSMutableDictionary * tasks;
@property (nonatomic, strong) NSMutableArray *caseDicArray;

@end

@implementation BARBusinessDemoViewController

/**
 ReadMe：
 case的几个操作流程如下：
 加载AR --> 下载AR资源包并且加载AR
 启动AR --> 加载AR成功后，调用startAR
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpNotifications];
    
    if([BARSDKPro isSupportAR]){
        
        [self buildButtonData];
        [self buildView];
        [self buildARController];
        self.arKey = @"10064265";
        self.arType = @"5";
        
        //#error 设置申请的APPID、APIKey https://dumix.baidu.com/dumixar
        [BARSDKPro setAppID:@"10000" APIKey:@"2288883fb087c4a37fbaf12bce65916e" andSecretKey:@""];
        
        [self setUpARVoice];
        [self setUpTTS];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotificationsObserver];
    [[BARRouter sharedInstance] voice_cleanUpWithConfigure:self.voiceConfigure];
    [[BARRouter sharedInstance] cleanUpTTS];
    
    [self stop:nil];
}

#pragma mark - Private

- (NSOperationQueue *)taskQueue {
    if (!_taskQueue) {
        _taskQueue = [[NSOperationQueue alloc] init];
        _taskQueue.maxConcurrentOperationCount = 4;
    }
    return _taskQueue;
}

- (dispatch_queue_t)delegateQueue {
    if (!_delegateQueue) {
        _delegateQueue = dispatch_queue_create("com.baidu.bar.sdk.casetask.queue",DISPATCH_QUEUE_SERIAL);
    }
    return _delegateQueue;
}

- (NSMutableDictionary *)tasks {
    if (!_tasks) {
        _tasks = [[NSMutableDictionary alloc] init];
    }
    return _tasks;
}

- (NSMutableArray *)caseDicArray {
    if (!_caseDicArray) {
        _caseDicArray = [[NSMutableArray alloc] init];
    }
    return _caseDicArray;
}

- (NSDictionary *)findDownloadCase:(NSString *)arKey {
    
    __block NSDictionary *resultDic = nil;
    [self.caseDicArray enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *innerARKey = [dic objectForKey:@"ar_key"];
        if ([innerARKey isEqualToString:arKey]) {
            resultDic = dic;
            *stop = YES;
        }
    }];
    return resultDic;
}

#pragma mark - Notifications

- (void)setUpNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)removeNotificationsObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self.arController pauseAR];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self.arController pauseAR];
}

- (void)applicationEnterForeground:(NSNotification *)notification
{
    [self.arController resumeAR];
}


#pragma mark - UI

- (void)buildARController{
    self.arController = [[BARMainController alloc]initARWithCameraSize:self.renderVC.cameraSize previewSize:self.renderVC.previewSizeInPixels];
    [self.arController setDevicePosition:[self.renderVC devicePosition]];
    __weak typeof(self) weakSelf = self;
    [self.arController setUiStateChangeBlock:^(BARSDKUIState state, NSDictionary *stateInfo) {
        switch (state) {
            case BARSDKUIState_TrackLost_HideModel:{
                [weakSelf.arController setBAROutputType:BAROutputVideo];
                break;
            }
            case BARSDKUIState_TrackLost_ShowModel:{
                break;
            }
            case BARSDKUIState_TrackOn:{
                [weakSelf.arController setBAROutputType:BAROutputBlend];
                break;
            }
            default:
                break;
        }
    }];
    
}

- (void)buildButtonData{
    
    self.actinArray = @[
                        @{@"action":@"downloadAR:",
                          @"des":@"预下载AR",
                          },
                        @{@"action":@"cancelAllTask:",
                          @"des":@"取消下载",
                          },
                        @{@"action":@"loadAR:",
                          @"des":@"加载AR",
                          }
                        ,@{@"action":@"pause:",
                           @"des":@"暂停AR",
                           }
                        ,@{@"action":@"resume:",
                           @"des":@"恢复AR",
                           }
                        ,@{@"action":@"stop:",
                           @"des":@"停止AR",
                           }
                        ,
                        @{@"action":@"switchAR:",
                          @"des":@"切换AR",
                          },
                        @{@"action":@"startSameSearch",
                          @"des":@"开始识图",
                          },
                        @{@"action":@"stopSameSearch",
                          @"des":@"停止识图",
                          },
                        
                        @{@"action":@"startVoice:",
                          @"des":@"启动语音",
                          },
                        @{@"action":@"stopVoice:",
                          @"des":@"结束语音",
                          },
                        @{@"action":@"closeAR:",
                          @"des":@"关闭页面",
                          }
                        ];
}

- (void)buildView{
    
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
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraButton addTarget:self action:@selector(cameraSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton setTitle:@" 翻转 " forState:UIControlStateNormal];
    [self.cameraButton sizeToFit];
    self.cameraButton.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.cameraButton];
    
    
    self.recorderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recorderButton addTarget:self action:@selector(shootVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.recorderButton setTitle:@" 录制 " forState:UIControlStateNormal];
    [self.recorderButton sizeToFit];
    self.recorderButton.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.recorderButton];
    
    self.screenShotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.screenShotButton addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.screenShotButton setTitle:@" 拍摄 " forState:UIControlStateNormal];
    [self.screenShotButton sizeToFit];
    self.screenShotButton.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.screenShotButton];
    
    self.cameraButton.layer.position = CGPointMake(50,self.view.frame.size.height - 30);
    self.recorderButton.layer.position = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height - 30);
    self.screenShotButton.layer.position = CGPointMake(self.view.frame.size.width/2 + 60, self.view.frame.size.height - 30);
    
    if (self.isLandscape) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationPortrait == orientation || UIInterfaceOrientationPortraitUpsideDown == orientation) {
            self.cameraButton.layer.position = CGPointMake(self.view.frame.size.height - 30, 50);
            self.recorderButton.layer.position = CGPointMake(self.view.frame.size.height - 30, self.view.frame.size.width/2);
            self.screenShotButton.layer.position = CGPointMake(self.view.frame.size.height - 30, self.view.frame.size.width/2 + 60);
        }else {
            [self adjustViewsForOrientation:orientation];
        }
    }
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(closeAR:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setTitle:@" 返回 " forState:UIControlStateNormal];
    [self.backButton sizeToFit];
    self.backButton.backgroundColor = [UIColor orangeColor];
    self.backButton.frame = CGRectMake(15, 30, 45, 45);
    [self.view addSubview:self.backButton];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreButton setTitle:@" 更多 " forState:UIControlStateNormal];
    [self.moreButton sizeToFit];
    self.moreButton.backgroundColor = [UIColor blueColor];
    self.moreButton.frame = CGRectMake(self.backButton.frame.size.width + self.backButton.frame.origin.x + 30, 30, 45, 45);
    [self.view addSubview:self.moreButton];
    
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
}

- (void)more:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"操作" message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    for (NSDictionary *dic in self.actinArray) {
        
        NSString *title = dic[@"des"];
        SEL selector = NSSelectorFromString(dic[@"action"]);
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (selector) {
                [weakSelf performSelector:selector withObject:nil];
            }
        }];
        
        [actionSheet addAction:action];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    [actionSheet addAction:cancelAction];
    
    if (actionSheet.popoverPresentationController) {
        actionSheet.popoverPresentationController.sourceView = sender;
        actionSheet.popoverPresentationController.sourceRect = [sender bounds];
    }
    
    [self presentViewController:actionSheet animated:YES completion:NULL];
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = self.view.center;
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.text = @"             ";
        [_progressLabel sizeToFit];
        _progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor lightGrayColor];
        _progressLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:_progressLabel];
    }
    return _progressLabel;
}

#pragma mark - Actions

- (void)downloadAR:(id)sender {
    self.progressLabel.text = @"";
    [self.indicatorView startAnimating];
    BARCaseTask *task = [[BARCaseTask alloc] initWithDelegateQueue:self.delegateQueue];
    task.arkey = self.arKey;
    [task addDelegate:self];
    [self.tasks setObject:task forKey:self.arKey];
    [self.taskQueue addOperation:task];
}

- (void)cancelAllTask:(id)sender {
    //默认取消所有task，业务方可自定义下载、取消逻辑
    [self.taskQueue cancelAllOperations];
    @synchronized (self.tasks) {
        NSArray *allKey = [self.tasks allKeys];
        for (NSString *arKey in allKey) {
            BARCaseTask* task = [self.tasks objectForKey:arKey];
            if(![task isCancelled]){
                [task cancel];
            }
            [task removeDelegate:self];
        }
        [self.tasks removeAllObjects];
    }
    [self.indicatorView stopAnimating];
    self.progressLabel.text = @"";
    [self.progressLabel removeFromSuperview];
    self.progressLabel = nil;
}

//加载AR
- (void)loadAR:(id)sender {
    [self.indicatorView startAnimating];
    
    __weak typeof(self) weakSelf = self;
    [self.arController loadAR:self.arKey success:^(NSString *arKey, kBARType arType) {
        [weakSelf.indicatorView stopAnimating];
        [weakSelf handleARKey:arKey arType:arType];
    } failure:^{
        [weakSelf.indicatorView stopAnimating];
        NSLog(@"LoadAR Failed");
    }];
}

- (void)handleARKey:(NSString *)arKey arType:(kBARType)arType {
    self.arKey = arKey;
    self.arType = [NSString stringWithFormat:@"%i",arType];
    if (kBARTypeLocalSameSearch == arType || kBARTypeCloudSameSearch == arType) {
        [self startSameSearch];
    }else if (kBARTypeARKit == arType) {
        
    }else {
        [self start:nil];
    }
}

//启动AR
- (void)start:(id)sender{
    
    [self.arController startAR];
    self.renderVC.videoPreviewView.enabled = YES;
    if(self.renderVC.videoPreviewView){
        [self.arController setTargetView:self.renderVC.videoPreviewView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.renderVC changeToARCamera];
        });
    }
}

//停止AR
- (void)stop:(id)sender{
    [self.arController stopAR];
    [self.renderVC changeToSystemCamera];
    self.renderVC.videoPreviewView.enabled = NO;
}

- (void)closeARView {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf stop:nil];
        [weakSelf.renderVC stopCapture];
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    });
}

//暂停AR
- (void)pause:(id)sender{
    [self.arController pauseAR];
}

//恢复AR
- (void)resume:(id)sender{
    [self.arController resumeAR];
}

//切换AR：需要输入内容平台ARKey以及ARType
- (void)switchAR:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入ARKey&ARType" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    [[alert textFieldAtIndex:0] setPlaceholder:@"ARKey"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"ARType"];
    [alert textFieldAtIndex:0].text = self.arKey;
    [alert textFieldAtIndex:1].text = self.arType;
    [alert textFieldAtIndex:0].clearButtonMode = UITextFieldViewModeAlways;
    [alert textFieldAtIndex:1].clearButtonMode = UITextFieldViewModeAlways;
    [alert show];
}

- (void)shootVideo:(id)sender {
    
    if (_recording) {
        [self stopShootVideo:sender];
        [(UIButton *)sender setTitle:@" 录制 " forState:UIControlStateNormal];
    }else {
        [(UIButton *)sender setTitle:@" 停止 " forState:UIControlStateNormal];
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if(status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if(granted){
                    [self.videoRecorder updateWriterWithAudioTrack:YES];
                    [self shootVideoBtnStartAction:YES];
                }
                else{
                    [self.videoRecorder updateWriterWithAudioTrack:NO];
                    [self shootVideoBtnStartAction:NO];
                }
            }];
        }
        else if(status == AVAuthorizationStatusDenied) {
            [self shootVideoBtnStartAction:NO];
        }
        else{
            [self shootVideoBtnStartAction:YES];
        }
    }
    _recording = !_recording;
}

- (void)shootVideoBtnStartAction:(BOOL)enableAudioTrack {
    if(self.videoRecorder.isRecording) {
        return ;
    }
    [self.videoRecorder startRecordingWithAudioTrack:YES];
    [self.arController setRenderMovieWriter:self.videoRecorder.movieWriter];
}

- (void)stopShootVideo:(id)sender {
    [self.videoRecorder stopRecording:^{
        [self.arController setRenderMovieWriter:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"videoDuration %f",self.videoRecorder.videoDuration);
            NSString *videoPath = [BARSDKPro getVideoPath];
            NSLog(@"videoPath %@",videoPath);
            UISaveVideoAtPathToSavedPhotosAlbum([NSURL URLWithString:videoPath].path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"录制成功" message:[@"已经保存至" stringByAppendingString:videoPath] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        });
    }];
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"didFinishSavingWithError %@",error);
}

- (void)takePic:(id)sender {
    [self.arController takePicture:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已保存至相册" delegate:nil
                                                          cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        });
    }];
}

- (void)startVoice:(id)sender {
    [[BARRouter sharedInstance] voice_startVoiceWithConfigure:self.voiceConfigure];
}

- (void)stopVoice:(id)sender {
    [[BARRouter sharedInstance] voice_stopVoiceWithConfigure:self.voiceConfigure];
}

- (void)closeAR:(id)sender {
    [self closeARView];
}

- (void)cameraSwitchBtnClick:(id)resp {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.renderVC rotateCamera];
        [self.arController setDevicePosition:[self.renderVC devicePosition]];
        
        __weak typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition* anim = [CATransition animation];
            anim.type = @"oglFlip";
            anim.subtype = @"fromLeft";
            anim.duration = .5f;
            [weakSelf.view.layer addAnimation:anim forKey:@"rotate"];
        });
    });
}

#pragma mark - BARRenderViewControllerDataSource

/**
 Render DataSource
 @param srcBuffer 相机buffer源
 */
- (void)updateSampleBuffer:(CMSampleBufferRef)srcBuffer {
    
    if (_sameSearching) {
        [[BARRouter sharedInstance] imageSearch_setBufferFrame:(__bridge id _Nonnull)(srcBuffer) withCaller:self.searchModule];
    }else {
        [self.arController updateSampleBuffer:srcBuffer];
    }
}

- (void)updateAudioSampleBuffer:(CMSampleBufferRef)audioBuffer {
    if(self.videoRecorder.isRecording){
        [self.videoRecorder.movieWriter processAudioBuffer:audioBuffer];
    }
}

#pragma mark - Gesture

- (void)onViewGesture:(UIGestureRecognizer *)gesture{
    [self.arController onViewGesture:gesture];
}
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale{
    [self.arController touchesBegan:point scale:scale];
}
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale{
    [self.arController touchesMoved:point scale:scale];
}
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale{
    [self.arController touchesEnded:point scale:scale];
}
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale{
    [self.arController touchesCancelled:point scale:scale];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        self.arKey = [alertView textFieldAtIndex:0].text;
        self.arType = [alertView textFieldAtIndex:1].text;
    }
}

#pragma mark - Voice

- (void)setUpARVoice{
    self.voiceConfigure = [[BARRouter sharedInstance] voice_createVoiceConfigure];
    [[BARRouter sharedInstance] voice_setStopBlock:^{
        NSLog(@"voiceStop");
    } withConfigure:self.voiceConfigure];
    
    
    [[BARRouter sharedInstance] voice_setStartBlock:^(BOOL success){
        NSLog(@"voiceStart");
    } withConfigure:self.voiceConfigure];
    
    [[BARRouter sharedInstance] voice_setStatusBlock:^(int status, id aObj) {
        switch (status) {
            case BARVoiceUIState_ShowLoading:
            {
                break;
            }
            case BARVoiceUIState_StopLoading:
            {
                break;
            }
            case BARVoiceUIState_ShowWave:
            {
                break;
            }
            case BARVoiceUIState_StopWave:
            {
                break;
            }
            case BARVoiceUIState_WaveChangeVolume:
            {
                NSLog(@"volume %li",(long)[aObj integerValue]);
                break;
            }
            case BARVoiceUIState_ShowTips:
            {
                NSLog(@"tips %@",aObj);
                break;
            }
            case BARVoiceUIState_HideVoice:
            {
                break;
            }
            default:
                break;
        }
    } withConfigure:self.voiceConfigure];
    
    [[BARRouter sharedInstance] voice_setUpWithConfigure:self.voiceConfigure];
}

#pragma mark - TTS Component

- (void)setUpTTS {
    [[BARRouter sharedInstance] setUpTTS];
}

#pragma mark - SameSearch Component

- (void)setUpSameSearch {
    __weak typeof(self) weakSelf = self;
    
    //没有设置过,则初始化 否则changeType:本地识图或者语段识图
    if(!self.searchModule)
    {
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
        
        [[BARRouter sharedInstance] imageSearch_setErrorBlock:^(NSError * _Nonnull error) {
            
        } withCaller:self.searchModule];
    }else{
        [[BARRouter sharedInstance] imageSearch_switchARType:kBARTypeCloudSameSearch withCaller:self.searchModule];
    }
}

- (void)startSameSearch {
    [self setUpSameSearch];
    _sameSearching = YES;
    [[BARRouter sharedInstance] imageSearch_startImageSearchWithCaller:self.searchModule];
}

- (void)stopSameSearch {
    _sameSearching = NO;
    [[BARRouter sharedInstance] imageSearch_stopImageSearchWithCaller:self.searchModule];
}

#pragma mark - Orientations

- (BOOL)shouldAutorotate {
    return self.isLandscape;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if (self.isLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    if (!self.isLandscape) {
        return;
    }
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            self.cameraButton.layer.position = CGPointMake(30, self.view.frame.size.height - 30);
            self.recorderButton.layer.position = CGPointMake(30, self.view.frame.size.height/2);
            self.screenShotButton.layer.position = CGPointMake(30, self.view.frame.size.height/2 + 60);
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            self.cameraButton.layer.position = CGPointMake(self.view.frame.size.width - 30, 50);
            self.recorderButton.layer.position = CGPointMake(self.view.frame.size.width - 30, self.view.frame.size.height/2);
            self.screenShotButton.layer.position = CGPointMake(self.view.frame.size.width - 30, self.view.frame.size.height/2 + 60);
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.videoRecorder = [[BARVideoRecorder alloc] initVideoRecorder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark - CaseTaskDelegate

- (void)caseTask:(BARCaseTask *)task downloadProgress:(float)downloadProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = [NSString stringWithFormat:@"%.2f",downloadProgress];
    });
}

- (void)caseTask:(BARCaseTask *)task taskResult:(NSDictionary *)taskResult error:(NSError *)error {
    NSString *taskArKey = task.arkey;
    
    [self removeCaseTasking:task];
    
    if(error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.progressLabel.text = @"";
            [self.progressLabel removeFromSuperview];
            self.progressLabel = nil;
        });
    }else{
        NSString *arPath = [taskResult objectForKey:@"path"];
        NSDictionary *queryresult = [taskResult objectForKey:@"queryresult"];
        NSDictionary *queryresultRet = [queryresult objectForKey:@"ret"];
        
        NSString *arTypeInServer = [queryresultRet objectForKey:@"ar_type"];
        NSString *version_code = [queryresultRet objectForKey:@"version_code"];
        NSMutableArray *tempArray = [@[] mutableCopy];
        
        for (NSDictionary *dic in self.caseDicArray) {
            NSString *arkey = [dic objectForKey:@"ar_key"];
            if([taskArKey isEqualToString:arkey]){
                NSMutableDictionary *mdic = [dic mutableCopy];
                if(arTypeInServer){
                    [mdic setObject:arTypeInServer forKey:@"ar_type"];
                }
                if(arPath){
                    [mdic setObject:arPath forKey:@"path"];
                }
                if(version_code){
                    [mdic setObject:version_code forKey:@"version_code"];
                }
                [tempArray addObject: [mdic copy]];
            }else{
                [tempArray addObject:dic];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.progressLabel.text = @"";
            [self.progressLabel removeFromSuperview];
            self.progressLabel = nil;
            self.caseDicArray = [tempArray mutableCopy];
        });
    }
}


- (void)caseTaskQueryArResourceSuccess:(BARCaseTask *)task {
}

- (void)caseTaskDealloc:(BARCaseTask *)task {
    [self removeCaseTasking:task];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        self.progressLabel.text = @"";
        [self.progressLabel removeFromSuperview];
        self.progressLabel = nil;
        
    });
}

- (void) removeCaseTasking:(BARCaseTask*) task {
    if(![task.arkey length]){
        return;
    }
    [task removeDelegate:self];
    @synchronized (self.tasks) {
        [self.tasks removeObjectForKey:task.arkey];
    }
}

@end
#endif


