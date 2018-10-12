using System.Collections.Generic;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixImageTarget {
        public string id = "0";
        public string name = "image_target";
        public string model_path = "models/model";
        public int template_width = -1;
        public int template_height = -1;
        public int target_width = -1;
        public int target_height = -1;
        public string centre_pos = "240,240,0";
    }

    [System.Serializable]
    public class DuMixSlamConfig {
        public string id = "demo";
        public int place_type = 1;
        public string position = "0.5,0.5";
        public int distance = 1500;
        public int pitch_angle = -45;
        public string rotate = "0,0,0";
    }

    [System.Serializable]
    public class DuMixServiceConfig {
        public int open_track_service = 0;
    }

    [System.Serializable]
    public class DuMixTipsConfig {
        public string hint = "";
        public string not_found_tip = "";
        public string too_far_hint = "";
        public string too_near_hint = "";
        public int far_threshold = 99999;
        public int near_threshold = 0;
    }

    [System.Serializable]
    public class DuMixCaseConfig {
        public DuMixTipsConfig UI = new DuMixTipsConfig();
        public List<DuMixImageTarget> targets = new List<DuMixImageTarget>();
        public DuMixServiceConfig service = new DuMixServiceConfig();
        public DuMixSlamConfig slam_model = new DuMixSlamConfig();

        public DuMixCaseConfig() {
            var target = new DuMixImageTarget();
            this.targets.Add(target);
        }
    }

}
