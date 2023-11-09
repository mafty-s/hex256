using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityWebSocket;


public class WebSocketMgr : Singleton<WebSocketMgr>
{
    private bool connected = false;
    private bool inited = false;

    private Dictionary<string, Action<string>> msgListenerDic = new Dictionary<string, Action<string>>();

    WebSocket webSocket;
    public string url = "wss://test.dvcc.com:443";

    public event Action OnOpen;
    public void Init(string _url)
    {
        inited = true;
        url = _url;
    }

    public void Connect()
    {
        //RemoveHandle();
        webSocket = new WebSocket(url);
        webSocket.OnClose += WebSocketClose;
        webSocket.OnOpen += WebSocketOpen;
        webSocket.OnError += WebSocketError;
        webSocket.OnMessage += WebSocketReceive;
        webSocket.ConnectAsync();
    }

    public void AddListener(string actionName, Action<string> callback)
    {
        if (msgListenerDic.ContainsKey(actionName))
        {
            msgListenerDic[actionName]+= callback;
        }
        else
        {
            Action<string> actions = callback;
            msgListenerDic.Add(actionName, actions);
        }
    }

    public void RemoveListener(string actionName, Action<string> callback)
    {
        if (msgListenerDic.ContainsKey(actionName))
        {
             msgListenerDic[actionName]-= callback;
            
        }
    }

    void RemoveHandle()
    {
        msgListenerDic.Clear();
        webSocket = null;
        webSocket.OnClose -= WebSocketClose;
        webSocket.OnOpen -= WebSocketOpen;
        webSocket.OnError -= WebSocketError;
        webSocket.OnMessage -= WebSocketReceive;
    }


    public void Send(string actionName, string msg, Action<string> callback)
    {
        if (webSocket == null) return;
        if (callback != null)
        {
            if (msgListenerDic.ContainsKey(actionName))
            {
                msgListenerDic[actionName] += callback;
            }
            else
            {
                Action<string> actions = callback;
                msgListenerDic.Add(actionName, actions);
            }
        }
        Debug.Log(msg);
        webSocket.SendAsync(msg); //string.Format("{0}/{1}", socketCode,
    }


 


    private void WebSocketReceive(object sender, MessageEventArgs e)
    {
        //heartTime = 0;
        receiveMsgTime = Time.realtimeSinceStartup;

        if (e.IsText)
        {
            Debug.Log(e.Data);
            
        }
        else if (e.IsBinary)
        {
            Debug.LogError(string.Format("���ܵ���Ϣ Bytes ({1}): {0}", e.Data, e.RawData.Length));
        }
    }

    private void WebSocketError(object sender, ErrorEventArgs e)
    {
        connected = false;
    }

    private void WebSocketOpen(object sender, OpenEventArgs e)
    {
        Debug.Log("Websocket Connected");
       
    }

    private void WebSocketClose(object sender, CloseEventArgs e)
    {
        connected = false;
        Debug.LogError(string.Format("网络已断开: StatusCode: {0}, Reason: {1}", e.StatusCode, e.Reason));
    }


    float heartTime = 0;
    float receiveMsgTime = 0;
    float reconnectCount = 0;

    private void Update()
    {
        if (!inited)
        {
            return;
        }

       
    }

  
}