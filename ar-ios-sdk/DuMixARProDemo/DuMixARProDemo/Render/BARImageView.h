#import <UIKit/UIKit.h>
#import "BARImageContext.h"

typedef enum {
    kBARImageFillModeStretch,                       // Stretch to fill the full view, which may distort the image outside of its normal aspect ratio
    kBARImageFillModePreserveAspectRatio,           // Maintains the aspect ratio of the source image, adding bars of the specified background color
    kBARImageFillModePreserveAspectRatioAndFill     // Maintains the aspect ratio of the source image, zooming in on its center to fill the view
} BARImageFillModeType; 

/**
 UIView subclass to use as an endpoint for displaying BARImage outputs
 */
@interface BARImageView : UIView <BARImageInput>
{
    BARImageRotationMode inputRotation;
}

/** The fill mode dictates how images are fit in the view, with the default being kBARImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) BARImageFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;

/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

@end
