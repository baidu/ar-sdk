using System;
namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixRDMessage
    {
        public string messageId = "";
        public DuMixRDMessage() {
            messageId = string.Format("{0}", System.DateTime.Now.Ticks);
        }
    }

    [System.Serializable]
    public class DuMixRDMessageData
    {

    }


    [System.Serializable]
    public class DuMixRDMessageTransformData: DuMixRDMessageData
    {
        public string position = "0,0,0";
        public string scale = "1,1,1";
        public string rotation = "0,0,0";
    }

    [System.Serializable]
    public class DuMixRDMessageScreenLayoutData: DuMixRDMessageData
    {
        public double marginTop = 0.0;
        public double marginLeft = 0.0;
        public double screenWidthRatio = 0.1;
        public double screenHeightRatio = 0.1;
    }

    [System.Serializable]
    public class DuMixRDMessageComponentUpdate: DuMixRDMessage
    {
        public string type = "component_update";
        public string node = "";
        public string component = "";
        public DuMixRDMessageData value = new DuMixRDMessageData();
    }

    [System.Serializable]
    public class DuMixRDMessageSetCaseType: DuMixRDMessage
    {
        public string type = "set_case_type";
        public string caseType = "imu";
    }
}
