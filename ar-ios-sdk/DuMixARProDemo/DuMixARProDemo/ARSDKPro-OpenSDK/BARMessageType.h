//
//  BARMessageType.h
//  ARSDKPro
//
//  Created by Asa on 2018/5/28.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#ifndef BARMessageType_h
#define BARMessageType_h

typedef enum {
    BARMessageTypeNone                    = -1,
    BARMessageTypeCustom                 = 1000,//自定义
   
    BARMessageTypeOpenURL                 = 1001,//打开URL
    BARMessageTypeEnableFrontCamera       = 1002,//开启前置摄像头
    BARMessageTypeChangeFrontBackCamera   = 1003,//前后摄像头切换
    BARMessageTypeIntitialClick           = 1004,//引导页点击
    BARMessageTypeNativeUIVisible         = 1005,//Native UI处理（显示、隐藏）
    BARMessageTypeCloseAR                 = 1006,//关闭AR
    BARMessageTypeShowAlert               = 1007,//弹出alert
    BARMessageTypeShowToast               = 1008,//弹出toast
    BARMessageTypeSwitchCase              = 1009,//切换case
    BARMessageTypeLogoStart               = 1010,//Logo识别开始
    BARMessageTypeLogoStop                = 1011,//Logo识别结束
    BARMessageTypeBatchDownloadRetryShowDialog = 1012,//分布加载batch包(失败后弹窗)
    
} BARMessageType;

#endif /* BARMessageType_h */
