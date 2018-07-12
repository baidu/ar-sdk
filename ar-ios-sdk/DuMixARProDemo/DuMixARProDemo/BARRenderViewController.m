//
//  BARRenderViewController.m
//  ARAPP-Pro
//
//  Created by Asa on 2017/10/23.
//  Copyright © 2018年 JIA CHUANSHENG. All rights reserved.
//

#import "BARRenderViewController.h"
#if defined (__arm64__)

@interface BARRenderViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureConnection* _audioConnection;
    dispatch_queue_t _audioQueue;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic, retain) AVCaptureDevice *avCaptureDevice;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) dispatch_queue_t videoOperationQueue;
@property (nonatomic, strong) dispatch_queue_t audioOperationQueue;

@property (nonatomic, assign) int pixelFormatType;
@property (nonatomic, assign) CGSize previewSize;
@end

@implementation BARRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoOperationQueue = dispatch_queue_create("com.baidu.arsdk.videocapture", DISPATCH_QUEUE_SERIAL);
    self.audioOperationQueue = dispatch_queue_create("com.baidu.arsdk.audiocapture", DISPATCH_QUEUE_SERIAL);
    
    self.pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    
    _cameraSize = CGSizeMake(1280, 720);
    
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        _previewSize = CGSizeMake([UIScreen mainScreen].bounds.size.height , ceil( [UIScreen mainScreen].bounds.size.height * self.aspect));
    }else {
        _previewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , ceil( [UIScreen mainScreen].bounds.size.width * self.aspect));
    }
    
    [self setupBaseContainerView];
    [self setupSession];
    [self setupCameraPreview];
    [self initVideoPreviewView];
    
    float scale = self.videoPreviewView.layer.contentsScale;
    _previewSizeInPixels = CGSizeMake(self.previewSize.width * scale , self.previewSize.height * scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.captureSession startRunning];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Private
- (void)setupBaseContainerView {

    self.arContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.previewSize.width, self.previewSize.height)];
    [self.arContentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.arContentView];
    
    if (self.isLandscape) {
        self.arContentView.transform = CGAffineTransformIdentity;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationPortrait == orientation) {
            
            self.arContentView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            
            self.arContentView.layer.position = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
            
        }else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
            self.arContentView.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.arContentView.layer.position = CGPointMake(self.view.frame.size.height/2, self.view.frame.size.width/2);
            
        }else {
            [self adjustViewsForOrientation:orientation];
        }
        
    }
}

- (void)initVideoPreviewView
{
    if(!self.videoPreviewView){
        _videoPreviewView = [[BARGestureImageView alloc]initWithFrame:self.arContentView.bounds];
        [self.videoPreviewView setFillMode:kBARImageFillModePreserveAspectRatioAndFill];
        [self.videoPreviewView setBackgroundColor:[UIColor clearColor]];
        [self.arContentView addSubview:self.videoPreviewView];
        _videoPreviewView.gesturedelegate = (id<BARGestureImageViewDelegate>)self;
    }
}

- (void)setupCameraPreview
{
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewLayer setFrame:self.arContentView.bounds];
    [self.arContentView.layer addSublayer:self.previewLayer];
}

- (void) setupAudioCapture {
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"Error getting audio input device: %@", error.description);
    }
    if ([_captureSession canAddInput:audioInput]) {
        [_captureSession addInput:audioInput];
    }
    
    _audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [_audioOutput setSampleBufferDelegate:self queue:_audioQueue];
    if ([_captureSession canAddOutput:_audioOutput]) {
        [_captureSession addOutput:_audioOutput];
    }
    _audioConnection = [_audioOutput connectionWithMediaType:AVMediaTypeAudio];
}

- (void)setupSession
{
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    
    // 设置换面尺寸
    [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    
    // 设置输入设备
    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionBack)
        {
            inputCamera = device;
            self.avCaptureDevice = device;
        }
    }
    
    if (!inputCamera) {
        return;
    }
    
    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:&error];
    if ([_captureSession canAddInput:_videoInput])
    {
        [_captureSession addInput:_videoInput];
    }
    
    // 设置输出数据
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [_videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    
    [self setupAudioCapture];
    
    [_captureSession commitConfiguration];
    
    NSDictionary* outputSettings = [_videoOutput videoSettings];
    for(AVCaptureDeviceFormat *vFormat in [self.avCaptureDevice formats] )
    {
        CMFormatDescriptionRef description= vFormat.formatDescription;
        float maxrate=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
        
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(description);
        FourCharCode formatType = CMFormatDescriptionGetMediaSubType(description);
        if(maxrate == 30 && formatType ==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange && dimensions.width ==[[outputSettings objectForKey:@"Width"]  intValue] && dimensions.height ==[[outputSettings objectForKey:@"Height"]  intValue]  )
        {
            if ( YES == [self.avCaptureDevice lockForConfiguration:NULL] )
            {
                self.avCaptureDevice.activeFormat = vFormat;
                [self.avCaptureDevice setActiveVideoMinFrameDuration:CMTimeMake(1,24)];
                [self.avCaptureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1,24)];
                [self.avCaptureDevice unlockForConfiguration];
            }
        }
    }

}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!self.captureSession.isRunning) {
        return;
    }else if (captureOutput == _videoOutput) {
        CFRetain(sampleBuffer);
        dispatch_async(self.videoOperationQueue, ^{
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(updateSampleBuffer:)]) {
                [self.dataSource updateSampleBuffer:sampleBuffer];
            }
            if (self.videoPreviewView.enabled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showARView:YES];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showARView:NO];
                });
            }

            CFRelease(sampleBuffer);
            
        });
    }else if (captureOutput == _audioOutput) {
        CFRetain(sampleBuffer);
        dispatch_async(self.audioOperationQueue, ^{
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(updateAudioSampleBuffer:)]) {
                [self.dataSource updateAudioSampleBuffer:sampleBuffer];
            }
            
            CFRelease(sampleBuffer);
        });
    }
}

- (void)changeToSystemCamera{
    self.videoPreviewView.enabled = NO;
    self.videoPreviewView.hidden = YES;
}

- (void)changeToARCamera{
    self.videoPreviewView.enabled = YES;
    self.videoPreviewView.hidden = NO;
}

- (void)showARView:(BOOL)show
{
    if(show){
        self.videoPreviewView.hidden = NO;
        self.videoPreviewView.enabled = YES;
    }
    else{
        self.videoPreviewView.hidden = YES;
        self.videoPreviewView.enabled = NO;
    }
}

- (void)onViewGesture:(UIGestureRecognizer *)gesture{
    [self.dataSource onViewGesture:gesture];
}
- (void)touchesBegan:(CGPoint)point scale:(CGFloat)scale{
    [self.dataSource touchesBegan:point scale:scale];
}
- (void)touchesMoved:(CGPoint)point scale:(CGFloat)scale;
{
    [self.dataSource touchesMoved:point scale:scale];
}
- (void)touchesEnded:(CGPoint)point scale:(CGFloat)scale{
    [self.dataSource touchesEnded:point scale:scale];
}
- (void)touchesCancelled:(CGPoint)point scale:(CGFloat)scale{
    [self.dataSource touchesCancelled:point scale:scale];
}

- (int)devicePosition
{
    AVCaptureDevicePosition currentCameraPosition = [[self.videoInput device] position];
    
    if (currentCameraPosition == AVCaptureDevicePositionBack)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

- (void)rotateCamera
{
    NSError *error;
    AVCaptureDeviceInput *newVideoInput;
    AVCaptureDevicePosition currentCameraPosition = [[self.videoInput device] position];
    
    if (currentCameraPosition == AVCaptureDevicePositionBack)
    {
        currentCameraPosition = AVCaptureDevicePositionFront;
    }
    else
    {
        currentCameraPosition = AVCaptureDevicePositionBack;
    }
    
    AVCaptureDevice *backFacingCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == currentCameraPosition)
        {
            backFacingCamera = device;
        }
    }
    newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
    
    if (newVideoInput != nil)
    {
        [_captureSession beginConfiguration];
        
        [_captureSession removeInput:self.videoInput];
        if ([_captureSession canAddInput:newVideoInput])
        {
            [_captureSession addInput:newVideoInput];
            self.videoInput = newVideoInput;
        }
        else
        {
            [_captureSession addInput:self.videoInput];
        }
        [_captureSession commitConfiguration];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
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
        {
            //load the portrait view
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            self.arContentView.transform = CGAffineTransformIdentity;
            
            self.arContentView.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.arContentView.layer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            self.arContentView.transform = CGAffineTransformIdentity;
            
            self.arContentView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            self.arContentView.layer.position = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)stopCapture
{
    if (self.captureSession)
    {
        [self.videoOutput setSampleBufferDelegate:nil queue:nil];
        
        [self.captureSession stopRunning];
        [self.captureSession removeInput:self.videoInput];
        [self.captureSession removeOutput:self.videoOutput];
        [self.captureSession removeOutput:self.audioOutput];

        self.videoOutput = nil;
        self.videoInput = nil;
        self.captureSession = nil;
        self.avCaptureDevice = nil;
    }
}

- (void)startCapture {
    if (self.captureSession) {
        if (NO == [self.captureSession isRunning]) {
            [self.captureSession startRunning];
        }
    }
}
@end

#endif
