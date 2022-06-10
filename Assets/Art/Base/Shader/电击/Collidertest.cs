using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Collidertest : MonoBehaviour
{
    public List<Material> matlist;
    public AnimationCurve amc;
    public float time;
    public GameObject inSideObj;
    public Animator Main;
    public GameObject inSideMesh;


    float amct;
    float amct2;

    float t;
    float t2;

    bool isHit;

    private void OnTriggerEnter(Collider other)
    {
        isHit = true;
        t = 0;
        t2 = 0;

    }

    private void Update()
    {

        if (isHit == true)
        {
            //曲线插值
            t += Time.deltaTime / time;
            t = Mathf.Clamp01(t);
            amct = amc.Evaluate(t);
            t2 = t + 0.1f;
            amct2 = amc.Evaluate(t2);



            //材质赋值
            for (int i = 0; i < matlist.Count; i++)
            {

                matlist[i].SetFloat("_MaskStr", amct);
                matlist[i].SetFloat("_EmissControl", amct2);


            }

            //当amct为0的时候,内部不显示.为1时打开

            inSideObj.SetActive(true);
            inSideMesh.SetActive(amct == 1);



            //获取Animator里的normalizeTime,把值赋予给inSideObj的normalizeTime.
            AnimatorStateInfo maininfo = Main.GetCurrentAnimatorStateInfo(0);
            float mainnormailizeTime = maininfo.normalizedTime;

            Animator inSideAnimator = inSideObj.GetComponent<Animator>();
            inSideAnimator.Play(0, 0, mainnormailizeTime);

            inSideAnimator.SetBool("isHit", true);
            Main.SetBool("isHit", true);

            //关闭
            if (t >= 1)
            {
                isHit = false;
                for (int i = 0; i < matlist.Count; i++)
                {

                    matlist[i].SetFloat("_EmissControl", 0);

                }
                inSideAnimator.SetBool("isHit", false);
                Main.SetBool("isHit", false);
                inSideObj.SetActive(false);



            }

        }

    }
}
