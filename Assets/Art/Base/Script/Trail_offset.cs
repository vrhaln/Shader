using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Trail_offset : MonoBehaviour
{
    //储蓄上一帧位置，和这一帧的位置计算距离，得到的距离乘以一个偏移量，赋值给材质的float
    Vector3 poslow;//旧位置
    Vector3 posnew;//新位置
    Material mat;//获取材质
    float dis;//存放算出来的距离值
    public float offset;//乘以偏移系数
    public Vector3 lowpos;//存储旧位置
    public float offsetSize;//

    void Start()
    {
        lowpos = transform.position;//初始化位置，开始先取一次，
        mat = gameObject.GetComponent<Renderer>().material;
    }
    private void Update()
    {
        poslow = lowpos;//旧位置拿取上一帧的位置
        OnLowPosSave();//执行存储方法,储蓄当前位置
        posnew = transform.position;//新位置,获取当前位置
        dis = Vector3.Distance(poslow, posnew);
        offsetSize += dis;//每次执行到这,均加上上一帧和这一帧的距离值,
        mat.SetFloat("_offset_U",offsetSize*offset);//把这个值作为材质的偏移值设置回去,乘以偏移系数,在外面手动校正偏移程度.
    }
    void OnLowPosSave()
    {
        lowpos = transform.position;
    }
}
