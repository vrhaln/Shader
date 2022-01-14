using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
//[ExecuteAlways]
public class ADYFX_PostGrey
{
    public bool isCamScreenCam = false;
    [MenuItem("ADYFX/特效辅助/※查看特效灰度范围【场景中可用】 %F12", false, 0)]
   static void SetGrey()
    {
        if (GameObject.Find("AFX_PostGrey"))
        {
            GameObject.DestroyImmediate(GameObject.Find("AFX_PostGrey"));
        }
        else
        {
            if (Shader.Find("AFX/Post/PostGrey"))
            {
                //GameObject go = new GameObject("cube1");
                if (GameObject.Find("AFX_PostGrey"))
                {
                    GameObject aa = GameObject.Find("AFX_PostGrey");
                    aa.transform.localScale = new Vector3(999, 999, 999);
                    aa.GetComponent<Renderer>().material = new Material(Shader.Find("AFX/Post/PostGrey"));
                    aa.GetComponent<Renderer>().sharedMaterial.SetFloat("_Fraction", 1);
                }
                else
                {
                    var objCube = GameObject.CreatePrimitive(PrimitiveType.Cube);//类型
                    objCube.name = "AFX_PostGrey";
                    objCube.transform.localScale = new Vector3(999, 999, 999);
                    objCube.GetComponent<Renderer>().material = new Material(Shader.Find("AFX/Post/PostGrey"));
                    objCube.GetComponent<Renderer>().sharedMaterial.SetFloat("_Fraction", 1);
                    if (objCube.GetComponent<Collider>()) 
                    {
                        GameObject.DestroyImmediate(objCube.GetComponent<Collider>());
                    }
                    objCube.hideFlags = HideFlags.HideInHierarchy;//物体不出现在场景列表中
                    //objCube.hideFlags = HideFlags.HideInInspector;//物体出现在场景列表中，但不可见组件
                }
                //Debug.Log(SceneView.lastActiveSceneView.camera.transform.position);
            }
            else
            {
                Debug.LogError("【ADYFX/特效辅助/查看特效灰度范围】所需着色器未找到");
            }
        }
    }
    //[MenuItem("ADYFX/特效辅助/查看特效灰度范围(取消查看) #&Z", false, 1)]
    //static void RemGrey()
    //{
    //    if (GameObject.Find("AFX_PostGrey(可以移动但不要修改名称)")) 
    //    {
    //        GameObject.DestroyImmediate(GameObject.Find("AFX_PostGrey(可以移动但不要修改名称)"));
    //    }
    //}
    [MenuItem("ADYFX/特效辅助/※主相机跟随场景视角（单次  相机Tag必须是MainCamera） &F1", false, 2)]
    static void SetMainCam()
    {

        //Camera.main.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
        //Camera.main.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
        int size = 0;
        foreach (AFX_MainCamFollowSceneCam obj in Object.FindObjectsOfType(typeof(AFX_MainCamFollowSceneCam)))//判断场景中有没有跟随脚本
        {
            size += 1;
        }
        if (size >= 1) //有则拿到所有相机 清除脚本
        {
            foreach (AFX_MainCamFollowSceneCam obj in Object.FindObjectsOfType(typeof(AFX_MainCamFollowSceneCam)))//拿到所有相机 清除脚本
            {
                GameObject.DestroyImmediate(obj.GetComponent<AFX_MainCamFollowSceneCam>());
            }
        }
        else  //没有则可以开始添加
        {
            if (size == 0)
            {
                List<Camera> cams = new List<Camera>();
                List<Camera> maincams = new List<Camera>();
                List<Camera> othercams = new List<Camera>();
                foreach (Camera obj in Object.FindObjectsOfType(typeof(Camera)))//拿到所有相机
                {
                    cams.Add(obj);
                }
                if (cams.Count < 1)
                {
                    Debug.LogError("场景中没有相机！");
                }
                else
                {
                    for (int i = 0; i < cams.Count; i++) //区分相机tag
                    {
                        if (cams[i].gameObject.tag == "MainCamera")
                        {
                            maincams.Add(cams[i]);
                        }
                        else
                        {
                            othercams.Add(cams[i]);
                        }
                    }
                    if (maincams.Count == 1) //有主相机时
                    {
                        GameObject aa = maincams[0].gameObject;
                            aa.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
                        aa.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
                        Debug.Log(string.Format("<color=#A6A6A6>{0}</color>", "为Tag是MainCamera的相机执行了同步场景视角"));
                    }
                    else if (maincams.Count > 1)  //有多个主相机时
                    {
                        GameObject aa = maincams[0].gameObject;
                            aa.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
                        aa.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
                        Debug.Log(string.Format("<color=#FF7878>{0}</color>", "找到了多个Tag为MainCamera的相机  自动为第一个找到的相机执行同步场景视角"));
                    }
                    else  //无主相机时
                    {
                        GameObject aa = othercams[0].gameObject;
                            aa.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
                        aa.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
                        Debug.Log(string.Format("<color=#FF4343>{0}</color>", "没有找到Tag为MainCamera的相机  默认为第一个遍历到的非MainCamera的Tag的相机执行同步场景视角"));
                    
                    }
                }
            }
        }
    }
    [MenuItem("ADYFX/特效辅助/※主相机跟随场景视角（实时  要取消再按一次即可,相机Tag必须是MainCamera） %F1", false, 3)]
    static void SetMainCam1()
    {
        int size = 0;
        foreach (AFX_MainCamFollowSceneCam obj in Object.FindObjectsOfType(typeof(AFX_MainCamFollowSceneCam)))//判断场景中有没有跟随脚本
        {
            size += 1;
        }
        if(size >= 1) //有则拿到所有相机 清除脚本
        {
            foreach (AFX_MainCamFollowSceneCam obj in Object.FindObjectsOfType(typeof(AFX_MainCamFollowSceneCam)))//拿到所有相机 清除脚本
            {
                GameObject.DestroyImmediate(obj.GetComponent<AFX_MainCamFollowSceneCam>());
            }
        }
        else  //没有则可以开始添加
        {
            if (size == 0) 
            {
                List<Camera> cams = new List<Camera>();
                List<Camera> maincams = new List<Camera>();
                List<Camera> othercams = new List<Camera>();
                foreach (Camera obj in Object.FindObjectsOfType(typeof(Camera)))//拿到所有相机
                {
                    cams.Add(obj);
                }
                if (cams.Count < 1)
                {
                    Debug.LogError("场景中没有相机！");
                }
                else
                {
                    for (int i = 0; i < cams.Count; i++) //区分相机tag
                    {
                        if (cams[i].gameObject.tag == "MainCamera")
                        {
                            maincams.Add(cams[i]);
                        }
                        else
                        {
                            othercams.Add(cams[i]);
                        }
                    }
                    if (maincams.Count == 1) //有主相机时
                    {
                        GameObject aa = maincams[0].gameObject;
                        bool cc = aa.GetComponent<AFX_MainCamFollowSceneCam>();
                        if (cc)
                        {
                            GameObject.DestroyImmediate(aa.GetComponent<AFX_MainCamFollowSceneCam>());
                        }
                        else
                        {
                            aa.AddComponent<AFX_MainCamFollowSceneCam>();
                            Debug.Log(string.Format("<color=#A6A6A6>{0}</color>", "你的场景中有多个相机，当前为Tag是MainCamera的相机执行了同步场景视角，这可能不是你想要的，如果这个相机不对，请把你要设置跟随的相机 Tag设为MainCamera 且场景中只有一个这种Tag的相机。"));
                        }
                    }
                    else if (maincams.Count > 1)  //有多个主相机时
                    {
                        GameObject aa = maincams[0].gameObject;
                        bool cc = aa.GetComponent<AFX_MainCamFollowSceneCam>();
                        if (cc)
                        {
                            GameObject.DestroyImmediate(aa.GetComponent<AFX_MainCamFollowSceneCam>());
                        }
                        else
                        {
                            aa.AddComponent<AFX_MainCamFollowSceneCam>();
                            Debug.Log(string.Format("<color=#FF7878>{0}</color>", "找到了多个Tag为MainCamera的相机  自动为第一个找到的相机执行同步场景视角"));
                        }
                    }
                    else  //无主相机时
                    {
                        GameObject aa = othercams[0].gameObject;
                        bool cc = aa.GetComponent<AFX_MainCamFollowSceneCam>();
                        if (cc)
                        {
                            GameObject.DestroyImmediate(aa.GetComponent<AFX_MainCamFollowSceneCam>());
                        }
                        else
                        {
                            aa.AddComponent<AFX_MainCamFollowSceneCam>();
                            Debug.Log(string.Format("<color=#FF4343>{0}</color>", "没有找到Tag为MainCamera的相机  默认为第一个遍历到的非MainCamera的Tag的相机执行同步场景视角"));
                        }
                    }
                }
            }
        }
    }
}