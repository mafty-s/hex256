using UnityEngine;
using System.Runtime.InteropServices;

public class ExampleScript : MonoBehaviour
{
#if !UNITY_EDITOR && UNITY_WEBGL
    [DllImport("__Internal")]
    private static extern void Foo();

    [DllImport("__Internal")]
    private static extern void Boo();

    void Awake()
    {
        Foo();
        Boo();
    }
#endif

    public void MyFunction(string args)
    {
        Debug.Log("MyFunction:" + args);
    }
}