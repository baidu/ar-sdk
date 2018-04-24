//
//  BARViewController.h
//  ARSDK
//
//  Created by LiuQi on 16/1/12.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BARImageShareTypeImage,
    BARImageShareTypeUrl
}BARImageShareType;

typedef NS_ENUM(NSUInteger, BARShareResult){
    
    BARShareResultSucceeded   = 0,
    BARShareResultFailed      = 1,
    BARShareResultCancelled   = 2,
    BARShareResultUnknown     = 3
};

@interface BARImageShareObj : NSObject
@property (assign, nonatomic) BARImageShareType type;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) UIImage* image;
@end


typedef void (^BARImageShareCompletionHandler)(BARShareResult result, NSString *actionName, NSDictionary *response, NSError *error);
typedef void (^BARImageShareBlock)(NSString* title, NSString* description, BARImageShareObj* thumbImg, BARImageShareObj* shareImg,BARImageShareCompletionHandler completion);

typedef void (^BARImageShareURLBlock)(NSString* title, NSString* description, BARImageShareObj* thumbImg, NSString* url,BARImageShareCompletionHandler completion);

typedef void (^BAROpenSDKShareBlock)(NSString* title, NSString* description, UIImage* thumbImg, NSString* h5Url,NSInteger shareType,NSString *videoOrImageUrl);

@interface BARViewController : UIViewController

typedef void (^BARViewCloseEventBlock)(void);
typedef void (^BARViewRescanEventBlock)(void);
typedef void (^BARViewClickEventBlock)(NSString* url);
typedef void (^BARDumixARRefuseEventBlock)(NSString* url);
typedef void (^BARViewOpenUrlWithO2Block)(NSString* url);

typedef void (^BARScreenImageBlock)(UIImage *image);
typedef void (^BARScreenVideoBlock)(NSString *videoPath);

@property (nonatomic, copy) BARViewCloseEventBlock closeEventBlock;
@property (nonatomic, copy) BARViewRescanEventBlock rescanEventBlock;
@property (nonatomic, copy) BARViewClickEventBlock clickEventBlock;
@property (nonatomic, copy) BARDumixARRefuseEventBlock dumixARRefuseEventBlock;
@property (nonatomic, copy) BARViewOpenUrlWithO2Block o2oUrlBlock;
@property (nonatomic, copy) BARImageShareBlock shareBlock;
@property (nonatomic, copy) BARImageShareURLBlock shareURLBlock;
@property (nonatomic, copy) NSDictionary *dataInfo;
@property (nonatomic, copy) BARScreenImageBlock screenImageBlock;
@property (nonatomic, copy) BARScreenVideoBlock screenVideoBlock;
@property (nonatomic, copy) BAROpenSDKShareBlock openSDKShareBlock;


- (UIImage *)getLastPriviewImage;

@end
