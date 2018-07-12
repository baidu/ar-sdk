//
//  BaiduARUnitySlam.h
//  BaiduARUnity_iOS
//
//  Created by Liu,Qi(ART) on 2017/12/5.
//  Copyright © 2017年 BaiduAR. All rights reserved.
//

#import <Foundation/Foundation.h>

extern "C" {
    int UnityARSlamInit(const char* msg, const char* path);
    typedef void(*UnityARSlamTrackingCallBack)(int result, float* matrix, int matrixLength);
    bool UnityARSlamTracking(unsigned char* data, UnityARSlamTrackingCallBack callBack);
    bool UnityARSlamRelease();
    const char* UnityARSlamStatus();
    const char* UnityARSlamVersion();
    int UnityARInsertModelInCamera(float x, float y, const char* flag, float distance);
    int UnityARRemoveModelInCamera(const char* flag);
}

@interface BaiduARUnitySlam_iOS : NSObject
@end
