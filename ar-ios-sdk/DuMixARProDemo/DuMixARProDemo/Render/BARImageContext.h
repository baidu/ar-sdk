#import "BARGLProgram.h"
#import "BARImageFramebuffer.h"
#import "BARImageFramebufferCache.h"

#define BARImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kBARImageRotateLeft || (rotation) == kBARImageRotateRight || (rotation) == kBARImageRotateRightFlipVertical || (rotation) == kBARImageRotateRightFlipHorizontal)

typedef enum { kBARImageNoRotation, kBARImageRotateLeft, kBARImageRotateRight, kBARImageFlipVertical, kBARImageFlipHorizonal, kBARImageRotateRightFlipVertical, kBARImageRotateRightFlipHorizontal, kBARImageRotate180 } BARImageRotationMode;

@interface BARImageContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) BARGLProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) BARImageFramebufferCache *framebufferCache;
@property(readonly) void *contextQueueKey;

- (id)initByCustomQueue;
+ (void *)contextKey;
+ (BARImageContext *)sharedImageProcessingContext;
+ (BARImageContext *)sharedEngineProcessingContext;
+ (BARImageContext *)sharedLoadingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (BARImageFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
+ (void)useEngineProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(BARGLProgram *)shaderProgram;
- (void)setContextShaderProgram:(BARGLProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;
+ (void)clearEngineInstance;

- (void)presentBufferForDisplay;
- (BARGLProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;

@end

@protocol BARImageInput <NSObject>
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (void)setInputFramebuffer:(BARImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(BARImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

@optional
- (void)passThroughFramebufferAtTime:(CMTime)frameTime;
- (void)preprocessingFramebufferAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;

//@optional
//- (BOOL)shouldRenderAtTime:(CMTime)frameTime;
@end

