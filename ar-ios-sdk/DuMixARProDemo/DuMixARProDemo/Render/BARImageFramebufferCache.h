#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "BARImageFramebuffer.h"

@interface BARImageFramebufferCache : NSObject

// Framebuffer management
- (BARImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(BARTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (BARImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(BARImageFramebuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(BARImageFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(BARImageFramebuffer *)framebuffer;

@end
