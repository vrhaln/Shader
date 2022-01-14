using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
public class ADYFX_EditorHelp : EditorWindow
{
    [MenuItem("ADYFX/帮助", false, 5000)]
    static void GaussianBlurWindow()//菜单窗口
    {
        ADYFX_EditorHelp window = EditorWindow.GetWindow<ADYFX_EditorHelp>();//定义窗口类
        window.minSize = new Vector2(420, 350);//限制窗口最小值
        //window.maxSize = new Vector2(1600, 920);//限制窗口最小值
        window.position = new Rect(300, 200, 420, 400);
        window.titleContent = new GUIContent("ADY FX工具 使用帮助");//标题内容
        window.Show();//创建窗口
    }
    private void OnGUI()
    {
        if (GUI.Button(new Rect(20, 40, 150, 25), "查看图文教程"))
        {
            Application.OpenURL("https://space.bilibili.com/7234711/article");
        }
        if (GUI.Button(new Rect(20, 70, 150, 25), "查看视频教程"))
        {
            Application.OpenURL("https://space.bilibili.com/7234711/channel/seriesdetail?sid=613948");
        }
        if (GUI.Button(new Rect(20, 100, 150, 25), "常见问题解决&提交Bug"))
        {
            Application.OpenURL("https://space.bilibili.com/7234711/article");
        }
        if (GUI.Button(new Rect(20, 130, 150, 25), "检查更新"))
        {
            Application.OpenURL("https://space.bilibili.com/7234711/article");
        }
        if (GUI.Button(new Rect(20, 170, 150, 25), "更多特效教程"))
        {
            Application.OpenURL("https://space.bilibili.com/7234711");
        }
        if (GUI.Button(new Rect(20, 310, 150, 30), "一键加群"))
        {
            Application.OpenURL("https://jq.qq.com/?_wv=1027&k=DRzfUJ86");
        }
        GUI.Label(new Rect(20, 220, 200, 20), "当前版本 ver 0.1");
        GUI.Label(new Rect(20, 240, 200, 20), "发布时间 2021.12.17");
        GUI.Label(new Rect(250, 220, 200, 20), "");
        GUI.Label(new Rect(230, 5, 100, 20), "Bilibili@ADY521");
        GUI.Label(new Rect(0, 250, 500, 20), "·································································································································································································");
        GUI.Label(new Rect(20, 270, 500, 20), "上海【米哈游】 特效内推 加群 704939661 联系管理员 WaiCokl");
        GUI.Label(new Rect(20, 290, 500, 20), "上海&成都【波克城市】 内推 加群 704939661 联系群主ADY521");

    }
}
