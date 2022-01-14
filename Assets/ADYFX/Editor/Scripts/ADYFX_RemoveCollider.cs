using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ADYFX_RemoveCollider : ScriptableWizard
{
   [Header("仅移除 包含Mesh组件的物体的碰撞体，否则任何物体的碰撞体都移除")]
    public bool mesh = true;
    [Header("在库中多选特效预制体、或在场景中选择特效物体 再执行移除操作(自动包含子级)")]
    public string ADY521 = "YYDS";
    public string bilibiliSpace = "https://space.bilibili.com/7234711";
    private GameObject[] txgo = new GameObject[0];
    private List<MeshFilter> meshs = new List<MeshFilter>();
    private List<Transform> sons = new List<Transform>();
    [MenuItem("ADYFX/特效辅助/※特效移除碰撞体工具", false, 1000)]//在主菜单唤起对话框，注意添加在Hierarchy中不能唤起对话框
    static void duihuakaung()
    {
        ScriptableWizard.DisplayWizard<ADYFX_RemoveCollider>("特效师移除碰撞体工具", "关闭", "添加选中物体 并移除碰撞组件");//泛型输入脚本名字，弹出对应脚本内容的弹框，弹框中显示的内容是对应脚本中的public变量                                                                   //Debug.Log("弹对话框");
    }
    public void OnWizardUpdate()//监测所有变量的变化，当有变化时调用
    {
        //errorString = "11";//弹框显示警告信息
        ADY521 = "YYDS";
        bilibiliSpace = "https://space.bilibili.com/7234711";
    }
    void OnWizardOtherButton()//第二个按钮的点击事件
    {
        zhixing();
    }
    public void zhixing()
        {
            txgo = new GameObject[0];
            meshs = new List<MeshFilter>();
            sons = new List<Transform>();
            txgo = Selection.gameObjects;
        if(txgo.Length < 1) 
        {
            Debug.Log(string.Format("<color=#FF776C>{0}</color>", "你没有选中 或选择的物体中不包含任何预制体、gameobject！"));
        }
        else 
        {
            Debug.Log(string.Format("<color=#4CFFB3>{0}</color>", "已确认执行移除碰撞体操作！！这个过程可能需要一些时间。  更多工具B站@ADY521。"));
        }

        for (int i = 0; i < txgo.Length; i++)//添加选中预制体中的所有子级 包含自己
            {
                Transform[] linshipar = txgo[i].GetComponentsInChildren<Transform>(true);
                for (int a = 0; a < linshipar.Length; a++)
                {
                    sons.Add(linshipar[a]);
                }
            }
        if (mesh == true) //如果只移除包含网格的
        {
            for (int i = 0; i < sons.Count; i++)//遍历所有物体 寻找有网格的 把有网格的加入到一个数组
            {
                if (sons[i].GetComponent<MeshFilter>())
                {
                    if (sons[i].GetComponent<Collider>())
                    {
                        DestroyImmediate(sons[i].gameObject.GetComponent<Collider>(), true);
                    }
                }
            }
            for (int i = 0; i < sons.Count; i++)//保险起见 遍历两次 防止一game挂俩
            {
                if (sons[i].GetComponent<MeshFilter>())
                {
                    if (sons[i].GetComponent<Collider>())
                    {
                        DestroyImmediate(sons[i].gameObject.GetComponent<Collider>(), true);
                    }
                }
            }
        }
        else
        {
            for (int i = 0; i < sons.Count; i++)//遍历所有物体 寻找有网格的 把有网格的加入到一个数组
            {
                if (sons[i].GetComponent<Collider>())
                {
                    DestroyImmediate( sons[i].gameObject.GetComponent<Collider>(),true);
                }
            }
            for (int i = 0; i < sons.Count; i++)//保险起见 遍历两次 防止一game挂俩
            {
                if (sons[i].GetComponent<Collider>())
                {
                    DestroyImmediate(sons[i].gameObject.GetComponent<Collider>(), true);
                }
            }
        }

        AssetDatabase.Refresh();
    }
}
