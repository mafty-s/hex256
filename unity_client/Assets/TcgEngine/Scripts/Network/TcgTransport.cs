using System.Collections;
using System.Collections.Generic;
using Netcode.Transports.WebSocket;
using UnityEngine;

namespace TcgEngine
{
    //Just a wrapper of UnityTransport to make it easier to replace with WebSocketTransport if planning to build for WebGL

    public class TcgTransport : WebSocketTransport
    {
        private const string listen_all = "0.0.0.0";

        public void SetServer(ushort port)
        {
            this.ConnectAddress = listen_all;
            this.Port = port;
        }

        public void SetClient(string address, ushort port)
        {
            this.ConnectAddress = address;
            this.Port = port;
        }

        public string GetAddress() { return ConnectAddress; }
        public ushort GetPort() {  return Port; }
    }
}
