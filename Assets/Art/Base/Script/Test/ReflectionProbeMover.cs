using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReflectionProbeMover : MonoBehaviour
{
    public Transform cam;
    public float GroundHight;

    void Update()
    {
        transform.position = new Vector3(cam.position.x, -cam.position.y + GroundHight, cam.position.z);
    }
}
