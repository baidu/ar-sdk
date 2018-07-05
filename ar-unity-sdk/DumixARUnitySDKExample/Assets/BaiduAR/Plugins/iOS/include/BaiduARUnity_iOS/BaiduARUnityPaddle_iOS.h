//
//  BaiduARUnityPaddle_iOS.h
//  BaiduARUnity_iOS
//
//  Created by Liu,Qi(ART) on 2018/4/8.
//  Copyright © 2018年 BaiduAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern "C" {
    int UnityARInitPaddle(const char* modelPath);
    
    typedef void(*UnityARPaddleCallBack)(int result, float* matrix, int matrixLength);
    void UnityARPaddle(unsigned char* pixels,int width ,int height, UnityARPaddleCallBack callBack);
    void UnityARPaddle2(unsigned char* pixels,int width ,int height, UnityARPaddleCallBack callBack);
    bool UnityARReleasePaddle();
}


@interface BaiduARUnityPaddle_iOS : NSObject

+ (BaiduARUnityPaddle_iOS *)sharedInstance;
- (int)initPaddle:(const char *)modelPath;
- (float*)paddle:(float *)buffer;
- (float*)paddle2:(unsigned char *)buffer width:(int)width height:(int)height;
- (bool)releasePaddle;

@end
