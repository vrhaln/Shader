using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Electric : MonoBehaviour
{
    public Camera cam;
    public GameObject effect;
    public float effectCD;
    public GameObject Ring;


    float effectCDT;
    bool effectIsFire = false;

    void Update()
    {
        //鼠标位置获取(射线检测)
        Ray mouseray=cam.ScreenPointToRay(Input.mousePosition);
        Physics.Raycast(mouseray, out RaycastHit rayhit, 1500, LayerMask.GetMask("plane"));
        Vector3 mousePosition = rayhit.point;
        Ring.transform.position = mousePosition;



        if (effectIsFire == false)
        {
            if (Input.GetMouseButtonDown(0))
            {
                //记录CD,当按下鼠标时,CDT值为现在的时间+effectCD,就是CD结束的时间,比如在第五秒的时候按下,CDT=5+3=8,所以在第8秒时这个技能才能够再次释放
                effectCDT = effectCD + Time.time;
                //让特效位置移动到鼠标位置
                effect.transform.position = mousePosition;
                effect.SetActive(true);
                effectIsFire = true;
            }
        }


        if(Time.time >= effectCDT)//现在的时间大于等于终结时间,则代表CD结束
        {
            effect.SetActive(false);
            effectIsFire = false;
        }

    }
}
