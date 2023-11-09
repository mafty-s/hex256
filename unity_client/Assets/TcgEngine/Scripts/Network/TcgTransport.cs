// using System.Collections;
// using System.Collections.Generic;
// using Unity.Netcode.Transports.UTP;
// using UnityEngine;
//
// namespace TcgEngine
// {
//     //Just a wrapper of UnityTransport to make it easier to replace with WebSocketTransport if planning to build for WebGL
//
//     public class TcgTransport : MonoBehaviour
//     {
//         private UnityTransport transport;
//
//         private const string listen_all = "0.0.0.0";
//
//         public virtual void Init()
//         {
//             transport = GetComponent<UnityTransport>();
//         }
//
//         public virtual void SetServer(ushort port)
//         {
//             transport.ConnectionData.ServerListenAddress = listen_all;
//             transport.SetConnectionData(listen_all, port);
//         }
//
//         public virtual void SetClient(string address, ushort port)
//         {
//             transport.SetConnectionData(address, port);
//         }
//
//         public virtual string GetAddress() { return transport.ConnectionData.Address; }
//         public virtual ushort GetPort() { return transport.ConnectionData.Port; }
//     }
// }

using System;
using System.Threading;
using UnityEngine;
using UnityWebSocket;

namespace TcgEngine
{
    public class TcgTransport : MonoBehaviour
    {
        // private ClientWebSocket webSocket;
        private CancellationTokenSource cancellationTokenSource;

        private const string defaultServerAddress = "ws://localhost";
        private const ushort defaultServerPort = 8777;

        private bool isConnected;

        public bool IsConnected()
        {
            return isConnected;
        }

        public virtual void Init()
        {

            Debug.Log("Websocket Init");
            string url = "ws://" + "localhost" + ":" + "8777";
            webSocket = new WebSocket(url); 
            webSocket.OnError += WebSocketError;
            webSocket.OnOpen += WebSocketOpen;
            webSocket.OnMessage += WebSocketReceive;
            isConnected = false;
            // webSocket = new ClientWebSocket();
            // cancellationTokenSource = new CancellationTokenSource();
        }


        //发送消息给服务端
        public void SendMessageByte(byte[] writer)
        {
            if (webSocket == null) return;
            // 发送消息给服务端
            // if (isConnected)
            // {
                try
                {
                    webSocket.SendAsync(writer);
                    Debug.Log("Message sent to server");
                }
                catch (Exception e)
                {
                    Debug.LogError("Failed to send message to server: " + e.Message);
                }
            // }
            // else
            // {
            //     Debug.LogError("WebSocket connection is not open");
            // }
        }

        WebSocket webSocket;

        //todo callback类型
        public void OnMessage(Action<byte[]> callback)
        {
            webSocket.OnMessage += (sender, e) =>
            {
                Debug.Log("Client Recv Msg From Server OnMessage");
                if (e.IsText)
                {
                    Debug.LogError("is Text");
                }
                else if (e.IsBinary)
                {
                    // 处理二进制数据的逻辑
                    callback(e.RawData);
                }
                else
                {
                    Debug.LogError("Unknown");
                }
            };
        }

        public void OnOpen(Action<ulong> callback)
        {
            webSocket.OnOpen += (sender, e) =>
            {
                Debug.Log("TcgTransport OnOpen");
                callback(0);
            };
        }
        
        private void WebSocketReceive(object sender, MessageEventArgs e)
        {

            if (e.IsText)
            {
                Debug.Log(e.Data);
            
            }
            else if (e.IsBinary)
            {
                Debug.Log(string.Format("Bytes ({1}): {0}", e.Data, e.RawData.Length));
            }
        }
        
        public void OnClose(Action<ulong> callback)
        {
            webSocket.OnClose += (sender, e) =>
            {
                Debug.LogError(string.Format("网络已断开: StatusCode: {0}, Reason: {1}", e.StatusCode, e.Reason));
                callback(0);
            };
        }
        
        public virtual void SetClient(string address, ushort port)
        {
            Debug.Log("Websocket Client Starting..." );
            try
            {
                webSocket.ConnectAsync();
            }
            catch (Exception e)
            {
                Debug.LogError("WebSocket connection error: " + e.Message);
            }
        }

        private void WebSocketError(object sender, ErrorEventArgs e)
        {
            Debug.LogError(string.Format("Websocket WebSocketError: Reason: {0}", e.Message));
            isConnected = false;
        }
        
        private void WebSocketOpen(object sender, OpenEventArgs e)
        {
            Debug.Log("Websocket Connected");
       
        }


        public virtual void Close()
        {
            webSocket.CloseAsync();
        }

        public virtual string GetAddress()
        {
            return defaultServerAddress;
        }

        public virtual ushort GetPort()
        {
            return defaultServerPort;
        }
    }
}