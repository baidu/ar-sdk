# 简介
本文档主要介绍基于DuMix AR iOS SDK专业版进行开发。在使用本文档前，请确认并已经开通了AR服务（您可以在 DuMix AR官网 的“开放平台”页面申请开通AR服务）。
# 运行环境
- iOS: 8.0 以上
- 架构：arm64（代码可通过 `[BaiduARSDK isSupportAR]` 来判断当前设备是否支持AR功能）。
# SDK目录结构
目前只支持静态库链接
SDK目录如下:

```
-核心功能
|-DumixARCore.a          // Required DuMixARSDK

-组件能力
|-AR-TTS                 // Optional 百度TTS相关的部分，若您不使用该功能，该模块不需要添加
|-AR-Voice               // Optional 百度语音相关的部分，若您不使用该功能，该模块不需要添加
|-AR-ImageSearch         // Optional 百度识图功能，若您不使用该功能，该模块不需要添加
|-paddle                 // Optional 百度手势识别功能，若您不使用该功能，该模块不需要添加
```
# 添加FrameWorks
```
-系统库
|-libz.tbd
|-libc++.tbd
|-Accelerate.framework
|-libsqlite3.0.tbd 
|-libstdc++.6.0.9.tbd        
|-libsqlite3.0.tbd
|-libiconv.tbd (语音/TTS能力需要)
-第三方库
|-libBaiduSpeechSDK.a（如果需要语音能力，需要集成）
|-libBaiduTTSSDK.a（如果需要TTS能力，需要集成）
```
# 隐私配置
相机权限-需要在info.plist中添加 Privacy - Camera Usage Description，
麦克风权限-添加 Privacy - Microphone Usage Description，
如果需要相册权限-需要在info.plist中添加 Privacy - Photo Library Additions Usage Description
1、请设置工程的 Bundle Identifer ，内容为您创建应用时的iOS包名。

2、在工程设置中选择Build Settings，搜索 Other Linker Flags  并设置 -ObjC、-force_load、`your arsdk path`/libpaddle_capi_layers.a ，其中`your arsdk path`/libpaddle_capi_layers.a的路径配置是可选项，若您不想集成手势识别功能，您`不`需要在工程中添加paddle的文件，也`不`要设置该路径，详细请参照Demo工程。

3、证书设置：
 
> <mark>**如果您用的是正式版:**</mark>
> 
>&ensp;&ensp;&ensp;&ensp;创建完AR应用后，在“应用详情”页面下载license文件，并将license文件放到您应用的工程目录中（license文件名称必须为：aip.license ）

> <mark>**如果您用的是试用版：**</mark>
> 
> &ensp;&ensp;&ensp;&ensp;不要添加 aip.license 文件，并确保工程中无此文件

# 设置APIKey、SecretKey
通过函数[BARSDKPro setAppID:@"" APIKey:@"" andSecretKey:@""]初始化APIKey、SecretKey





