using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Collidertest : MonoBehaviour
{
    public List<Material> matlist;
    private void Update()
    {
        for (int i = 0;i < matlist.Count;i++)
        {
            matlist[i].SetFloat("_EmissControl", 1);
        }

        //if(gg== true)
        //{
        //    mat.SetFloat()

        //}

        //private void OnTriggerEnter(Collider other)
        //{
        //    gg = true;
        //}


    }
}
