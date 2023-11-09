using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using WebSocketServer;

namespace TcgEngine
{
    public class TcgWebSocketServer : WebSocketServer.WebSocketServer
    {

        override public void OnOpen(WebSocketConnection connection)
        {
            // Here, (string)connection.id gives you a unique ID to identify the client.
            Debug.Log("TcgWebSocketServer OnOpen:" + connection.id);
        }

        override public void OnMessage(WebSocketMessage message)
        {
            // (WebSocketConnection)message.connection gives you the connection that send the message.
            // (string)message.id gives you a unique ID for the message.
            // (string)message.data gives you the message content.
            Debug.Log(message.connection.id);
            Debug.Log(message.id);
            Debug.Log(message.data);

            // message.connection.Send("Yes!" + message.data);
        }

        override public void OnClose(WebSocketConnection connection)
        {
            // Here is the same as OnOpen
            Debug.Log(connection.id);
        }

        public void onConnectionOpened(WebSocketConnection connection)
        {
            Debug.Log("Connection opened: " + connection.id);
        }

        public void onMessageReceived(WebSocketMessage message)
        {
            Debug.Log("Received new message: " + message.data);
            // message.connection.Send("Yes!" + message.data);
        }

        public void onConnectionClosed(WebSocketConnection connection)
        {
            Debug.Log("Connection closed: " + connection.id);
        }
    }
}