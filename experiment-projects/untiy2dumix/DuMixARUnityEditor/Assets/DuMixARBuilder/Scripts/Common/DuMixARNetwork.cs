using UnityEngine;
using WebSocketSharp;
using System;
using System.IO;

namespace DuMixARInternal
{
    public class DuMixARNetwork 
    {

        public static DuMixARNetwork _instance;
        public static DuMixARNetwork Instance
        {
            get
            {
                if (null == _instance)
                {
                    _instance = new DuMixARNetwork();
                }

                return _instance;
            }
        }


        public enum ConnectState
        {
            NotConnect,
            Connecting,
            Connected,
        };

        public ConnectState connectState = ConnectState.NotConnect;

        private WebSocket ws;

        public void Connect(string ip , Action<ConnectState> callback)
        {
            Debug.Log("DuMix WebSocket Connect");

            if (connectState != ConnectState.NotConnect)
                return;
            
            ws = new WebSocket("ws://"+ip);
            connectState = ConnectState.Connecting;

            ws.OnOpen += (sender, e) =>
            {
                connectState = ConnectState.Connected;
                callback(connectState);
                Debug.Log("WebSocket OnOpen");
            };

            ws.OnMessage += (sender, e) =>
            {
                var msg = !e.IsPing ? e.Data : "Received a ping.";
                Debug.Log("WebSocket OnMessage: "+ msg);
            };
            ws.OnError += (sender, e) =>
            {
                connectState = ConnectState.NotConnect;
                callback(connectState);
                var error = e.Message;
                Debug.Log("WebSocket OnError: " + error);

            };

            ws.OnClose += (sender, e) =>
            {
                connectState = ConnectState.NotConnect;
                callback(connectState);
                var code = String.Format("WebSocket Close ({0})", e.Code);
                var reason = e.Reason;
                Debug.Log("WebSocket OnClose: " + code + " reason: "+ reason);
            };

            ws.Log.Level = LogLevel.Trace;
            ws.Connect();
        }

        public void sendFile(string path)
        {
            if (connectState != ConnectState.Connected) {
                Debug.LogError("Websocket 未连接");
                return; 
            }
            Debug.Log("WebSocket Send File Path: " + path);
            byte[] data = File.ReadAllBytes(path);
            ws.Send(data);
            Debug.Log("WebSocket Send Ok");
        }

        public void sendString(string payload) {
            if (connectState != ConnectState.Connected) {
                Debug.LogError("Websocket 未连接");
                return; 
            }
            ws.Send(payload);
        }
    }
}
