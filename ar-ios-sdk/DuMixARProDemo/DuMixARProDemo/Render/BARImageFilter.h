#import "BARImageOutput.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define BARImageHashIdentifier #
#define BARImageWrappedLabel(x) x
#define BARImageEscapedHashIdentifier(a) BARImageWrappedLabel(BARImageHashIdentifier)a

extern NSString *const kBARImageVertexShaderString;
extern NSString *const kBARImagePassthroughFragmentShaderString;

struct BARVector4 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
    GLfloat four;
};
typedef struct BARVector4 BARVector4;

struct BARVector3 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
};
typedef struct BARVector3 BARVector3;

struct BARMatrix4x4 {
    BARVector4 one;
    BARVector4 two;
    BARVector4 three;
    BARVector4 four;
};
typedef struct BARMatrix4x4 BARMatrix4x4;

struct BARMatrix3x3 {
    BARVector3 one;
    BARVector3 two;
    BARVector3 three;
};
typedef struct BARMatrix3x3 BARMatrix3x3;

/** BARImage's base filter class
 
 Filters and other subsequent elements in the chain conform to the BARImageInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */
@interface BARImageFilter : BARImageOutput <BARImageInput>
{
    BARImageFramebuffer *firstInputFramebuffer;
    
    BARGLProgram *filterProgram;
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform;
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    
    BOOL isEndProcessing;
    BOOL shouldPassThroughFramebuffer;

    CGSize currentFilterSize;
    BARImageRotationMode inputRotation;
    
    BOOL currentlyReceivingMonochromeInput;
    
    NSMutableDictionary *uniformStateRestorationBlocks;
    dispatch_semaphore_t imageCaptureSemaphore;
}

@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;
@property(assign, nonatomic) CMTimeRange timeRange;

/// @name Initialization and teardown

/**
 Initialize with vertex and fragment shaders
 
 You make take advantage of the SHADER_STRING macro to write your shaders in-line.
 @param vertexShaderString Source code of the vertex shader to use
 @param fragmentShaderString Source code of the fragment shader to use
 */
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;

/**
 Initialize with a fragment shader
 
 You may take advantage of the SHADER_STRING macro to write your shader in-line.
 @param fragmentShaderString Source code of fragment shader to use
 */
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
/**
 Initialize with a fragment shader
 @param fragmentShaderFilename Filename of fragment shader to load
 */
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)initializeAttributes;
- (id)initSuper;
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(BARImageRotationMode)rotation;

/// @name Managing the display FBOs
/** Size of the frame buffer object
 */
- (CGSize)sizeOfFBO;

/// @name Rendering
+ (const GLfloat *)textureCoordinatesForRotation:(BARImageRotationMode)rotationMode;
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;
- (CGSize)outputFrameSize;

/// @name Input parameters
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setInteger:(GLint)newInteger forUniformName:(NSString *)uniformName;
- (void)setFloat:(GLfloat)newFloat forUniformName:(NSString *)uniformName;
- (void)setSize:(CGSize)newSize forUniformName:(NSString *)uniformName;
- (void)setPoint:(CGPoint)newPoint forUniformName:(NSString *)uniformName;
- (void)setFloatVec3:(BARVector3)newVec3 forUniformName:(NSString *)uniformName;
- (void)setFloatVec4:(BARVector4)newVec4 forUniform:(NSString *)uniformName;
- (void)setFloatArray:(GLfloat *)array length:(GLsizei)count forUniform:(NSString*)uniformName;
- (void)setMatrix3f:(BARMatrix3x3)mat3 forUniformName:(NSString *)uniformName;
- (void)setMatrix4f:(BARMatrix4x4)mat4 forUniformName:(NSString *)uniformName;

- (void)setMatrix3f:(BARMatrix3x3)matrix forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setMatrix4f:(BARMatrix4x4)matrix forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setFloat:(GLfloat)floatValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setPoint:(CGPoint)pointValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setSize:(CGSize)sizeValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setVec3:(BARVector3)vectorValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setVec4:(BARVector4)vectorValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setFloatArray:(GLfloat *)arrayValue length:(GLsizei)arrayLength forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;
- (void)setInteger:(GLint)intValue forUniform:(GLint)uniform program:(BARGLProgram *)shaderProgram;

- (void)setAndExecuteUniformStateCallbackAtIndex:(GLint)uniform forProgram:(BARGLProgram *)shaderProgram toBlock:(dispatch_block_t)uniformStateBlock;
- (void)setUniformsForProgramAtIndex:(NSUInteger)programIndex;

@end
