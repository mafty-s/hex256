using UnityEngine;
using System.Collections;
using System;

public class Singleton<T> : IDisposable where T : class, new()
{
    private static T instance;

    public static T Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new T();
            }
            return instance;
        }
    }
    public virtual void Init() { }
    public virtual void Dispose()
    {
        
    }
}