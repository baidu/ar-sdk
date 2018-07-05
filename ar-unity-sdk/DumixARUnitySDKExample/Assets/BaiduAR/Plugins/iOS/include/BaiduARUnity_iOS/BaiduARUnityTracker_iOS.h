//
//  BaiduARUnityTracker_iOS.h
//  BaiduARUnity_iOS
//
//  Created by Liu,Qi(ART) on 2017/12/5.
//  Copyright © 2017年 BaiduAR. All rights reserved.
//

#import <Foundation/Foundation.h>

extern "C" {
    int UnityARInit(const char* msg, const char* path);
    typedef void(*UnityARTrackingCallBack)(int result, float* matrix, int matrixLength);
    bool UnityARTracking(unsigned char* data, UnityARTrackingCallBack callBack);
    void UnityARRelease();
    int UnityARVersion();
}

@interface BaiduARUnityTracker_iOS : NSObject
@end
