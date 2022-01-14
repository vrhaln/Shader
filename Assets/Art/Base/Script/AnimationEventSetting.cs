using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[Serializable]
public struct EffectData
{
    public int id;
    public GameObject effect;
    public Vector3 pos;
    public Vector3 rotation;
    public Vector3 scale ;
}

public class AnimationEventSetting : MonoBehaviour
{
    public EffectData[] effectData;
    Dictionary<int ,EffectData> effectDict = new Dictionary<int, EffectData>();
    void Start()
    {
        for (int i = 0; i < effectData.Length;++i)
        {
            effectDict[effectData[i].id] = effectData[i];
        }
    }

    public void CreateEvent(int id)
    {
        GameObject exp = Instantiate(effectDict[id].effect, transform);
        exp.transform.localPosition = effectDict[id].pos;
        exp.transform.localEulerAngles = effectDict[id].rotation;
        exp.transform.localScale = effectDict[id].scale;
        Destroy(exp, 5);
    }
}
