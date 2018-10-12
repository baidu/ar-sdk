using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace DuMixARInternal
{
    public class DuMixUnityEditor : EditorWindow
    {

        static string ip = "";
        static DuMixBuilderConfigUtil configUtil = new DuMixBuilderConfigUtil();
        const string connectStr = "DuMix/Connect %#w";
        [MenuItem(connectStr)]

        static void Connect()
        {
            if (ip == "") {
                configUtil.LoadConfig();
                ip = configUtil.configItem.mobileIpAddress;
            } else {
                configUtil.configItem.mobileIpAddress = ip;
                configUtil.SaveConfig();  
            }
            Debug.Log("DuMix View Connect: "+ ip);
            string dumixViewAddress = ip + ":8222";
            DuMixARNetwork.Instance.Connect(dumixViewAddress,HandleConnectState);
        }

        [MenuItem(connectStr, true)]
        public static bool MenuConnectCheck()
        {
            return DuMixARNetwork.Instance.connectState == DuMixARNetwork.ConnectState.NotConnect;
        }

        static void HandleConnectState(DuMixARNetwork.ConnectState state)
        {
            
        }

        const string refreshStr = "DuMix/Sync %#r";
        [MenuItem(refreshStr)]
        static void Refresh()
        {
            Debug.Log("Sync");
            DuMixCaseBuilder builder = new DuMixCaseBuilder();
            builder.Run();
        }

        const string settingsStr = "DuMix/Settings %#e";
        [MenuItem(settingsStr)]
        static void Init()
        {
            configUtil.LoadConfig();
            ip = configUtil.configItem.mobileIpAddress;
            Debug.Log("Init:" + ip);
            DuMixUnityEditor window = GetWindow<DuMixUnityEditor>("DuMix");
            window.position = new Rect(Screen.width / 2, Screen.height / 2, 300, 100);
            window.Show();
        }

        void OnGUI()
        {
            GUILayout.Label("Settings", EditorStyles.boldLabel);
            ip = EditorGUILayout.TextField("DuMix View IP:", ip);
        }

    }
}
 
