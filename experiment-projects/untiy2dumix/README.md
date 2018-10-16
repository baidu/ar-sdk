# unity2dumix


## 简介
使用unity2dumix，在Unity3D上创造DuMix AR内容。可将制作好的AR内容上传至DuMix内容平台 (http://dumix.baidu.com/content#/) ，用百度App等进行访问。

项目目前处于实验阶段，当前仅支持Mac OS平台，需搭配iOS设备使用，更多功能持续开发中，也欢迎熟悉Unity3D、DuMix的同学一同参与本项目的开发。

## 快速开始

1. Clone代码库 打开 Assets/DuMixARBuilder/Scenes/SlamDemo.unity
	
	[建议] 调整Unity3D的视图布局，如下图，方便调试和预览场景。

	![Layout](http://ar-fm.cdn.bcebos.com/content-online/upload/20180911/png/140217_8495701f3a47c7d180d8bffa35349b7f/Unity_Layout.png)


2. 安装预览App, /preview app/Preview.ipa （安装完成后，需在设置中信任企业证书，才能正常打开App）

3. 联机调试。保持Mac和iPhone在同一局域网下（项目中unity和预览App使用局域网ip地址进行连接，需保证Mac和iPhone之间可以互相ping通），在Unity3D顶部菜单栏中选择DuMix/Settings，输入手机上展示的IP地址。点击 DuMix/Connect 完成连接。点击DuMix/Sync 启动联机调试。

## 功能说明
目前项目仅支持DuMix ARSDK的部分功能，更多功能持续开发中，也欢迎熟悉DuMix的同学一同参与本项目的开发。

### 支持的场景类型
- [x] SLAM
- [] IMU
- [] 2D 图像跟踪

### 支持的场景元素
- [x] 3D 模型 （FBX）
- [x] 平面图片
- [x] 视频
- [x] 蒙版视频
- [] 序列帧
- [] 天空盒
- [] 粒子系统

## 使用说明
### 添加3D模型
- 将下载好的FBX模型文件存放到 Assets/DuMixARCase/Resource/ 目录下。
- 将FBX拖入场景，挂到SlamScene节点下。
- 给模型节点绑定 Assets/DuMixARBuilder/Scripts/Component/3D/DuMixCMPTModel.cs 脚本，在脚本属性 [Res Path] 中填写FBX文件在 Assets/DuMixARCase/Resource/ 下的相对路径。
  ![3D Model](http://ar-fm.cdn.bcebos.com/content-online/upload/20180911/png/144442_a7c04dd9439109f2203139881a8c2b22/Add_3D.png)
- 调整模型的大小位置等。

### 添加平面图片
- 将图片文件存放到 Assets/DuMixARCase/Resource/ 目录下。
- 将 Assets/DuMixARBuilder/Prefabs/3D/Plane 拖入场景，挂在SlamScene节点下，将Plane的纹理调整为自定义图片。
- 查看Plane绑定的DuMixCMPTPlane脚本，在脚本属性 [Res Path] 中填写图片在 Assets/DuMixARCase/Resource/ 下的相对路径。
- 调整模型的大小位置等。

### 添加视频
- 将视频文件存放到 Assets/DuMixARCase/Resource/ 目录下。
- 将 Assets/DuMixARBuilder/Prefabs/3D/Video 拖入场景，挂在SlamScene节点下。
- 查看Video绑定的DuMixCMPT3DVideo脚本，在脚本属性 [Res Path] 中填写视频文件在 Assets/DuMixARCase/Resource/ 下的相对路径。
- 根据视频的类型，调整[Video Type]属性值。
- 调整模型的大小位置等。
- 配置视频播放行为：
	- 将 /Assets/DuMixARBuilder/Prefabs/Event/InitEvent 拖入场景，并挂在视频节点下(或任意SlamScene下的节点下)以创建一个初始化事件。
	- 将 /Assets/DuMixARBuilder/Prefabs/Action/PlayVideoAction 拖入场景，并挂在 InitEvent下，并配置其DuMixCMPTVideoAction脚本属性，配置视频节点名称，控制行为以及播放次数等。
	![PlayVideo](http://ar-fm.cdn.bcebos.com/content-online/upload/20180911/png/150035_3c6857cefe56b813f3070f9df4817047/Play_Video.png)
	
### 配置UI元素
- 目前UI元素仅支持 平面图片/视频。
- 将相关文件存放到 Assets/DuMixARCase/Resource/ 目录下。
- 将 Assets/DuMixARBuilder/Prefabs/UI 下的 Button/Video拖拽到场景中，并添加到 **UICanvas** 节点下。
- 配置相关脚本属性，添加资源路径（同平面图片和视频）。

### 配置Event和Action
- /Assets/DuMixARBuilder/Prefabs/Event/ 和 /Assets/DuMixARBuilder/Prefabs/Action/ 目录下提供了部分交互组件，用于配置场景交互逻辑。
- 通常将Event组件挂在场景元素节点下（如3D模型、平面图片、视频等等），并将Action组件挂在Event组件下以表达一个交互逻辑。如在3D模型节点下配置ClickEvent和AnimAction，可实现点击模型，播放模型动画的交互逻辑。
- 目前支持的Event组件包括
	- ClickEvent：绑定的节点被点击
	- InitEvent：节点初始化完成
- 目前支持的Action组件包括：
	- AnimationAction: 播放模型动画
	- AudioAction：控制音乐播放
	- VideoAction: 控制视频播放
	- OpenUrlAction: 使用默认浏览器打开URL
	- VisibilityAction: 隐藏/显示节点	

### 自定义交互脚本
- 编辑/Assets/DuMixARBuilder/LuaFiles/main.lua 文件，根据DuMix Lua API添加自定义交互逻辑。

### 获取DuMix资源包
- 在Unity3d 顶部菜单栏中点击 DuMix/Sync （是否连接预览App 不影响本操作)。
- 找到 /Assets/DuMixARCase/Build/ 目录，其中ar.zip为转换完成的DuMix AR资源包。

## 发布DuMix AR内容
制作好的DuMix AR资源包可上传到 DuMix内容平台 (http://dumix.baidu.com/content) ，并分发到百度App等渠道，详情参考

- http://dumix.baidu.com/content#/
- http://ar.baidu.com

## 项目说明 & 部分功能的实现方案

项目相关脚本代码位于 /Assets/DuMixARBuilder/Scripts/ 目录下

- Common/ 包含项目的一些基本配置以及网络、文件压缩相关功能模块。
- Component/ 包含组件相关代码，如场景元素，Event组件，Action组件等。
- Conversion/ 包含将Unity Scene转换为DuMix AR资源包相关的功能模块。转换相关功能入口为DuMixCaseBuilder的Run方法。
- EditorWindows/ 包含Unity3d 菜单扩展相关代码。
- RemoteDebug/ 包含与预览App通信所需的消息结构定义。

### 场景格式转换功能的实现
场景格式转换是解析Unity Scene中的内容，并将相应的节点、资源转换为DuMix ARSDK内容标准的过程，DuMixCaseBuilder类的Run方法实现了该功能。在Run方法中，依次完成了：

- 将/Assets/DuMixARCase/Templates/ar 文件夹下的内容拷贝到 /Assets/DuMixARCase/Build/ar 目录下，作为后续填充内容的基础。
- 遍历 DuMixCMPTScene 下的子节点，执行单个节点的格式转换，包括转换节点Transform坐标，转换资源文件格式（如将FBX模型转换为GLTF格式），拷贝资源文件到Build/ar 目录，根据DuMix Json API (http://ai.baidu.com/docs#/DuMixAR-Json-3D/top) 输出节点描述等。 单个节点转换功能的实现在 DuMixARBuilder/Scripts/Conversion/NodeConvertor.cs 中。
- 遍历 DuMixCMPTUICanvas 下的子节点，执行单个UI节点的格式转换。
- 更新 Assets/DuMixARCase/Build/ar/res/main.json 文件，更新DuMix AR场景描述。
- 遍历所有DuMixCMPTEvent / DuMixCMPTAction 对象，输出交互脚本。
- 更新 Assets/DuMixARCase/Build/ar/ 下的lua脚本文件。
- 压缩 Assets/DuMixARCase/Build/ar 目录，输出 ar.zip。
- 检查当前Websocket状态，并将ar.zip发送到预览App。（非必须）

### 交互组件的实现
DuMix ARSDK中，所有的交互逻辑都是借助Lua API (http://ai.baidu.com/docs#/DuMixAR-Lua-base/top) 实现的。在本项目中，所有Event类都继承自 DuMixCMPTEvent类，并实现了 string TransferToDuMixScript() 方法。在该方法中，根据脚本参数，输出与之相应的 Lua 脚本，并写入 ar/unity.lua 当中。

## 已知Issue
- 项目中使用的FBX模型的材质必须绑定有贴图，否则转换得到的DuMix内容无法正常预览。

## 联系我们

当前项目对DuMix ARSDK的支持还远不完整，功能持续开发中，也欢迎熟悉DuMix的同学一同参与本项目的开发。
DuMix相关资料可查询:

- http://ar.baidu.com/
- http://dumix.baidu.com/content#/

> Email: shenxuecen@baidu.com

> 百度AR开发交流群 号码：47208111
  