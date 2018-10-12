using UnityEngine;
using System.Collections;


namespace DuMixARInternal
{
    [ExecuteInEditMode]
    public class DuMixCMPTUIVideo : DuMixCMPTUIObject
    {

        public enum VideoType
        {
            commonVideo,
            maskVideo
        }

        public VideoType videoType = VideoType.maskVideo;

        override public DuMixNode ToDuMixNode(DuMixNodeConvertor convertor)
        {
            return convertor.ConvertUIVideo(this);
        }

        public override void UpdateDuMixScreenLayout()
        {
            var position = CoordinateUtil.ConvertUIPosition(this.gameObject.transform.localPosition,
                                                               new Vector2(720, 1280));
            var scale = CoordinateUtil.ConvertUIScale(this.gameObject.transform.localScale,
                                                      new Vector2(720, 1280));
            hudData.marginTop = position.y;
            hudData.marginLeft = position.x;
            hudData.screenWidthRatio = scale.x;
            hudData.screenHeightRatio = scale.y;
        }
    }
}
