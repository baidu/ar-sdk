using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System;

namespace BaiduARInternal
{
    public class ARFPS : MonoBehaviour
    {
        
        private float fpsMeasuringDelta = 1.0f;
        private float timePassed;
        private int m_FrameCount = 0;
        private float m_FPS = 0.0f;

        private void Start()
        {
            timePassed = 0.0f;

        }

        private void Update()
        {
            m_FrameCount = m_FrameCount + 1;
            timePassed = timePassed + Time.deltaTime;

            if (timePassed > fpsMeasuringDelta)
            {
                m_FPS = m_FrameCount / timePassed;

                timePassed = 0.0f;
                m_FrameCount = 0;

            }

        }


        private void OnGUI()
        {

            GUIStyle bb = new GUIStyle();
            bb.normal.textColor = new Color(1.0f, 0.0f, 0.0f);   //设置字体颜色的
            bb.fontSize = 40;       //当然，这是字体大小

            //居中显示FPS
            GUI.Label(new Rect(10, 150, 200, 200), "FPS: " + m_FPS.ToString("f1"), bb);

        }
        
    }
}
