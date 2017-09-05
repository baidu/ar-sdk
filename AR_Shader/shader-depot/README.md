# Shader 列表
### 以下所有shader 使用均可根据开发者需要改动(非专业shader开发者请使用原版)

```
* frame-gles 用于图片序列帧渲染

* nobone-pod-gles 用于非骨骼POD，贴图上色，不带光
* pod-gles 用于骨骼POD，贴图和带光
* pod-nolight-gles 用于骨骼POD，贴图上色 不带光

* forward-directional-gles 用于按钮等图片渲染(已弃用,涵盖在plane_gles中)
* plane-gles 用于图片渲染，按钮，普通图片，视频等

* video-gles 用于视频渲染,建议使用透明视频,支持普通视频,绿幕视频.(根据不同需求请选择对应shader)
```


``` 
** 划重点！**
在3月9号后的case请用带new的pod-shader,和模型师商量后颠倒过贴图

* 带 "old-" 前缀的pod shader已弃用.

* nobone-pod-gles 用于非骨骼POD，贴图上色，不带光
* pod-gles 用于骨骼POD，贴图和带光
* pod-nolight-gles 用于骨骼POD，贴图上色 不带光
```

```
**2017-03-20**
1.将所有fs增加alpha支持，可以设置颜色+半透混合。默认不变。
```

```
**2017-07-18**
1.新增透明视频shader,可取代绿幕视频及序列帧使用 
* alpha-video-gles-android 
* alpha-video-gles
```

```
**2017-08-01**
1.新增材质shader,配合环境光使用
* mesh_basic_gles --- 
* mesh_lambert_gles --- 
* mesh_phong_gles --- 
* mesh_physical_gles --- 

2.新增动态阴影
* shadow_map_depth_shader

3.新增天空盒
* skybox-gles
```


```
**2017-09-05**
1.新增粒子shader
* particle-gles --- 

