using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnima : MonoBehaviour
{
    public float speed;
    public float backspeed;
    public string AandD = "Horizontal";
    public string mouse = "mouse 0";

    Animator anima;

    void Update()
    {
        anima = GetComponent<Animator>();
        //bool类型的数据,判断真假
        //判断符号 <=小于等于,>=大于等于,==等于,||或,&&与
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.D))//条件为真执行下面花括号里的函数
        {
            //transform.position += transform.forward * speed;
            anima.SetBool("run", true);
        }

        else
        {
            anima.SetBool("run", false);
        }

        if (Input.GetKey(KeyCode.Mouse0))
        {
            anima.SetBool("attack", true);
            //transform.position -= transform.forward * backspeed;
        }

        else
        {
            anima.SetBool("attack", false);
            //transform.Rotate(0, Input.GetAxis(AandD), 0);

        }
    }
}
