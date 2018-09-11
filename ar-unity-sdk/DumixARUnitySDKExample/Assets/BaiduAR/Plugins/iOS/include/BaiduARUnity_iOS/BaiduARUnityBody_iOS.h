//
//  BaiduARUnityBody_iOS.h
//  BaiduARUnityBody_iOS
//
//  Created by Liu,Qi(ART) on 2018/6/22.
//  Copyright © 2018年 Liu,Qi(ART). All rights reserved.
//

#import <Foundation/Foundation.h>



extern "C" {
    float* UnityARBodyProcess2d(unsigned char* pixels,int width ,int height ,int& count, int num ,bool isFront ,bool isYUV);
   // float* UnityARBodyProcess3d(unsigned char* pixels,int width ,int height ,int& count, int num);
    
    void UnityARBodyReleaseEstimator();
}

@interface BaiduARUnityBody_iOS : NSObject

+ (BaiduARUnityBody_iOS *)sharedInstance;
- (float*)process2d:(unsigned char *)buffer width:(int)width height:(int)height count:(int&)count num:(int)num isFront:(bool)isFront isYUV:(bool)isYUV;
//- (float*)process3d:(unsigned char *)buffer width:(int)width height:(int)height count:(int&)count num:(int)num;
- (void)releaseEstimator;
@end
