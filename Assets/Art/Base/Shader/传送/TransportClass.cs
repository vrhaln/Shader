using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransportClass : MonoBehaviour
{
    //按下鼠标
    //transport值从-3插值到5,WarpDir值为(0,0,70),SlashMax值为10
    //Position向溶解方向位移X距离
    //transport值从-5插值到3,WarpDir值为(0,0,-70),SlashMax值为-10

    public AnimationCurve amc;
    public float time;
    public Material mat;
    public float transportPoint = 0.5f;
    public float slashMax = 0.5f;
    public Vector3 direction = new Vector3(0, 0, 1);
    public float transportDistance = 1;
    public GameObject Effect;

    float amct;
    float t;
    bool isdown = false;
    bool doOnce;


    void Update()
    {
        mat.SetFloat("_Transport", 3);

        if (Input.GetMouseButtonDown(0))
        {
            Effect.SetActive(false);
            doOnce = true;
            isdown = true;
            t = 0;
        }
        if (isdown == true)
        {
            Effect.SetActive(true);
            t += Time.deltaTime / time;//t是一个0到1的值
            t = Mathf.Clamp(t, 0, 1);
            amct = amc.Evaluate(t);
            mat.SetFloat("_Transport", amct);
        }
        if(t < transportPoint)
        {
            mat.SetFloat("_SlashMax", slashMax);
            mat.SetVector("_WarpDir", direction);
        }
        if (t >= transportPoint)
        {
            if(doOnce == true)
            {
                transform.position += transportDistance * transform.forward;
                doOnce = false;
            }
            mat.SetFloat("_SlashMax", -slashMax);
            mat.SetVector("_WarpDir", -direction);
        }
        if(t>=1)
        {
            isdown = false;
        }
    }
}
