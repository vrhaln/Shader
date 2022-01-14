using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]

public class TransformInput : MonoBehaviour
{
    public Material mat;
    public Material mat2;
    public GameObject target;

    void Update()
    {
        Vector3 spherevector = target.transform.position;
        mat.SetVector("_Position", spherevector);

        if (mat2!=null)
        {
            mat2.SetVector("_Position", spherevector);
        }


    }

    private void OnDisable()
    {
        mat.SetVector("_Position", Vector3.zero);

        if (mat2 != null)
        {
            mat2.SetVector("_Position", Vector3.zero);
        }

    }

}
