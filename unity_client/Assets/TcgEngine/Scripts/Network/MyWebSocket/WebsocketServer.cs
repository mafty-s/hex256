using System;
using System.Collections.Generic;
using System.Net;
using TcgEngine;
using UnityEngine;
using UnityEngine.Events;
using WebSocketSharp;
using WebSocketSharp.Server;

namespace MyWebSocket
{
    [System.Serializable]
    public class WebSocketOpenEvent : UnityEvent<ulong, WebSocketPeer>
    {
    }

    [System.Serializable]
    public class WebSocketMessageEvent : UnityEvent<ulong, byte[]>
    {
    }

    [System.Serializable]
    public class WebSocketCloseEvent : UnityEvent<ulong>
    {
    }

    [System.Serializable]
    public class WebSocketErrorEvent : UnityEvent<ulong, Exception>
    {
    }

    public class WebSocketPeer : WebSocketBehavior
    {
        public ulong getId()
        {
            return (ulong)this.ID.GetHashCode();
        }

        protected override void OnMessage(MessageEventArgs e)
        {
            if (e.IsBinary)
            {
                TcgNetwork.Get()?.onMessage.Invoke(this.getId(), e.RawData);
            }
        }

        public void SendByte(byte[] buf)
        {
            this.Send(buf);
        }

        protected override void OnClose(CloseEventArgs e)
        {
            TcgNetwork.Get()?.onClose.Invoke(this.getId());
        }

        protected override void OnError(ErrorEventArgs e)
        {
            Debug.LogError(e.Message + ":" + getId());
        }

        protected override void OnOpen()
        {
            TcgNetwork.Get()?.onOpen.Invoke(this.getId(), this);
        }
    }


    public class MyWebSocketServer : MonoBehaviour
    {
        private HttpListener _httpListener;

        public WebSocketOpenEvent onOpen;
        public WebSocketMessageEvent onMessage;
        public WebSocketCloseEvent onClose;
        public WebSocketErrorEvent onError;

        protected Dictionary<ulong, WebSocketPeer> peers = new Dictionary<ulong, WebSocketPeer>();

        protected WebSocketServer wssv;

        public void Start()
        {
        }

        public void StartListen(ushort port)
        {
            wssv = new WebSocketServer("ws://0.0.0.0:" + port);
            wssv.AddWebSocketService<WebSocketPeer>("/");
            wssv.Start();
        }


        public void SendAsync(ulong id, byte[] buffer)
        {
            var peer = peers[id];
            peer.SendByte(buffer);
        }

        public void Update()
        {
        }
    }
}