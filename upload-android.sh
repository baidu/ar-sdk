# 将ar内容打包上传到Android手机上运行
#!/usr/bin/env bash

package_name=com.baidu.arsamplehost
# 停止arhost运行
adb shell am force-stop ${package_name}

set -x
work_dir=`dirname "$0"`
echo "work dir:${work_dir}"

cur_dir=`pwd`
echo "current dir:${cur_dir}"

build_dir=${cur_dir}/build
rm -rf ${build_dir}
mkdir ${build_dir}

ar_dir=${build_dir}/ar

rm -rf ${ar_dir}

# 调整顺序打包需要运行的case

ar_case=ar-test2

#######
ar_case=ar-anim-rotate
ar_case=ar-anim-rotate-repeatmode
ar_case=ar-anim-rotate-translate
ar_case=ar-anim-scale
ar_case=ar-anim-scale-repeatmode
ar_case=ar-anim-three
ar_case=ar-anim-translate
ar_case=ar-anim-translate-repeatmode

ar_case=ar-audio
ar_case=ar-audio-delay
ar_case=ar-audio-repeatcount
ar_case=ar-audio-switch
ar_case=ar-bgmusic
ar_case=ar-bgmusic2
ar_case=ar-bgmusic-repeatcount

ar_case=ar-frame-picture

ar_case=ar-huddisplay
ar_case=ar-huddisplay-pod

ar_case=ar-image
ar_case=ar-image-fullscreen
ar_case=ar-image-type

ar_case=ar-imu

ar_case=ar-light-spotlight-red
ar_case=ar-light-pointlight2
ar_case=ar-light-pointlight
ar_case=ar-light-all
ar_case=ar-light-color

ar_case=ar-model-scale

ar_case=ar-open-url

ar_case=ar-scene
ar_case=ar-scene2
ar_case=ar-scene3
ar_case=ar-scene-disable-scroll
ar_case=ar-scene-switch
ar_case=ar-scene-switch-abc

ar_case=ar-tracking-audio
ar_case=ar-tracking-video

ar_case=ar-video
ar_case=ar-video-repeatcount
ar_case=ar-video-transparent

cp -r ${ar_case}/ar ${ar_dir}

# 切换到build目录
cd ${build_dir}
zip_file=ar.zip
rm -rf ${zip_file}

# 压缩zip文件
zip -r ${zip_file} ar

# windows需要使用7z
# 7za a ${zip_file} ar

ar_content_sdcard=/sdcard/baiduar/zip

adb shell mkdir /sdcard/baiduar
adb shell mkdir ${ar_content_sdcard}

# git-shell
# ar_content_sdcard=//sdcard/baiduar/zip/

adb push ${zip_file}  ${ar_content_sdcard}/
adb shell am start -n ${package_name}/com.baidu.arsamplehost.MainActivity --ez showsdcard true
