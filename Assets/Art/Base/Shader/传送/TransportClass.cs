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
    //public GameObject targetB;
    public Camera cam;
    public float rotateSpeed = 0.2f;
    public float speed = 1;
    public Transform cameradir;


    bool doOnce;
    float amct;
    float t;
    bool isdown = false;


    void Update()
    {
        //当在传送过程中,位移,方向,旋转都被禁止
        //if(isdown == false )//不在传送过程中,才执行
        {

            //位移
            transform.position += Input.GetAxis("Horizontal") * cameradir.right * speed;
            transform.position += Input.GetAxis("Vertical") * cameradir.forward * speed;

        //方向
        //1.获取摄像机，使用摄像机的ScreenPointToRay方法来创造一个Ray射线
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);

        //2.使用Raycast使Ray射线发生碰撞,并在碰撞方法中Out一个命中信息hitinfo
        //  Physics.raycast(线,命中信息输出,线碰撞长度,层Mask)
        Physics.Raycast(ray, out RaycastHit infohit, 1500, LayerMask.GetMask("Plane"));

        //3.命中信息中,获取到的点(point,就是命中的position)
        Vector3 hitposition = infohit.point;

        //4.使用碰撞点作为向量计算B点
        Vector3 target = Vector3.Normalize(hitposition - this.transform.position);//物体朝向鼠标的方向
        transform.forward = Vector3.Lerp(transform.forward, target, rotateSpeed);

        }


        //传送
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
