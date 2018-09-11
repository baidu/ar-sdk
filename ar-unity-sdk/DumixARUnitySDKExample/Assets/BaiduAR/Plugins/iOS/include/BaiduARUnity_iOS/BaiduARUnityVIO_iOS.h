//
//  BaiduARUnityVIO_iOS.h
//  BaiduARUnity_iOS
//
//  Created by Liu,Qi(ART) on 2018/5/24.
//  Copyright © 2018年 BaiduAR. All rights reserved.
//

#import <Foundation/Foundation.h>

extern "C" {
    bool UnityARVIOInit();
    typedef void(*UnityARVIOCallBack)(float* matrix, int matrixLength);
    void UnityARVIO(unsigned char* data, UnityARVIOCallBack callBack);
    bool UnityARVIORelease();
}

@interface BaiduARUnityVIO_iOS : NSObject

@end
