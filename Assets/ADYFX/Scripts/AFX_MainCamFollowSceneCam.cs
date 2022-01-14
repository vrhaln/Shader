using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
[ExecuteInEditMode]
public class AFX_MainCamFollowSceneCam : MonoBehaviour
{
    public string mainCamFollowSceneCam = "当前相机正在跟随场景视角";
    private void OnRenderObject()
    { 
        mainCamFollowSceneCam = "相机正跟随场景视角 再按Ctrl+Alt+C取消";
        gameObject.transform.position = SceneView.lastActiveSceneView.camera.transform.position;
        gameObject.transform.rotation = SceneView.lastActiveSceneView.camera.transform.rotation;
    }
}
