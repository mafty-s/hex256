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
using System.Collections;
using System.Collections.Generic;
using System.Text;
// using System.Net.WebSockets;
using System.Threading;
using System.Threading.Tasks;
using TcgEngine.Client;
using Unity.Netcode;
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
            isConnected = false;
            // webSocket = new ClientWebSocket();
            // cancellationTokenSource = new CancellationTokenSource();
        }

        // public virtual void SetServer(ushort port)
        // {
        //     // 启动本地 WebSocket 服务端
        //     Uri serverUri = new Uri($"{defaultServerAddress}:{port}");
        //     Debug.Log("Websocket Server Starting...");
        //
        //     try
        //     {
        //         // 启动 WebSocket 服务端的逻辑
        //         // 这里可以使用第三方库或自己实现 WebSocket 服务端的逻辑
        //         // 例如：WebSocketServer.Start(serverUri);
        //         Debug.Log("Websocket Server Started");
        //         isConnected = true;
        //     }
        //     catch (Exception e)
        //     {
        //         Debug.LogError("WebSocket server startup error: " + e.Message);
        //     }
        // }


        public void SendMessageByte(byte[] writer)
        {
            if (webSocket == null) return;
            // 发送消息给服务端
            if (isConnected)
            {
                try
                {
                    webSocket.SendAsync(writer);
                    Debug.Log("Message sent to server");
                }
                catch (Exception e)
                {
                    Debug.LogError("Failed to send message to server: " + e.Message);
                }
            }
            else
            {
                Debug.LogError("WebSocket connection is not open");
            }
        }

        WebSocket webSocket;

        public virtual void SetClient(string address, ushort port)
        {
            string url = "ws://" + "localhost" + ":" + port;
            Debug.Log("Websocket Client Starting..." + url);
            try
            {
                webSocket = new WebSocket(url);
                webSocket.OnOpen += WebSocketOpen;
                webSocket.OnError += WebSocketError;
                webSocket.OnClose += WebSocketClose;
                webSocket.OnMessage += WebSocketReceive;

                webSocket.ConnectAsync();
            }
            catch (Exception e)
            {
                Debug.LogError("WebSocket connection error: " + e.Message);
            }
        }
        
        private void WebSocketReceive(object sender, MessageEventArgs e)
        {

            if (e.IsText)
            {
                Debug.Log(e.Data);
            
            }
            else if (e.IsBinary)
            {
                Debug.LogError(string.Format("Bytes ({1}): {0}", e.Data, e.RawData.Length));
                
                byte[] payload = e.RawData; // 假设 message.data 是字节数组类型

                int length = BitConverter.ToInt32(payload, 0); // 获取长度
                string type = Encoding.UTF8.GetString(payload, 4, length); // 假设类型占用4个字节，从第5个字节开始
                int contentLength = payload.Length - 4 - length; // 计算内容的长度
                byte[] content = new byte[contentLength];
                Array.Copy(payload, 4 + length, content, 0, contentLength); 
            
                Debug.Log("Length: " + length);
                Debug.Log("Type: " + type);
                Debug.Log("Content: " + content);
                
                //todo
                
            }
        }

        private void WebSocketOpen(object sender, OpenEventArgs e)
        {
            Debug.Log("Websocket Connected");
            this.isConnected = true;
            // string uid = Guid.NewGuid().ToString();
            // GameClient.Get().ConnectToGame2(uid);
        }
        
        private void WebSocketError(object sender, ErrorEventArgs e)
        {
            Debug.LogError(string.Format("Websocket WebSocketError: Reason: {0}", e.Message));
            isConnected = false;
        }
        
        private void WebSocketClose(object sender, CloseEventArgs e)
        {
            isConnected = false;
            Debug.LogError(string.Format("网络已断开: StatusCode: {0}, Reason: {1}", e.StatusCode, e.Reason));
        }
        
        public virtual void Close()
        {
            // cancellationTokenSource.Cancel();
            // webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "", CancellationToken.None).Wait();
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