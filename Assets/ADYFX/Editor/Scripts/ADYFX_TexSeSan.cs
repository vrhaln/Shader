using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class ADYFX_TexSeSan : EditorWindow
{
    RenderTexture rt;
    RenderTexture rt1;
    int time = 0;
    float v1;
    string path = ">>还未选择路径";
    float u1;
    string name1 = "ADYFX_SeSan";
    public string roffsetX = "_RoffsetX";
    public string roffsetY = "_RoffsetY";
    public string goffsetX = "_GoffsetX";
    public string goffsetY = "_GoffsetY";
    public string boffsetX = "_BoffsetX";
    public string boffsetY = "_BoffsetY";
    public Texture2D yuantu;
    float suofang;
    int serial;
    Material addmat;
    float fangda;
    float suoxiao;
    Color[] colorall;
    bool suofangfanxiang;
    private Vector2 resolution = new Vector2(256, 256);
    public Texture2D yulantu;
    private float rotate = 0f;
    private float scale = 0.02f;
    private int moshi = 0;
    private int pianyitongdao = 1;
    private float tongdaodir = 0;
    public Material mat;
    private bool fanxiang;
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    string[] shizhong = new string[] { "12点方向", "1点方向", "2点方向", "3点方向", "4点方向", "5点方向"};
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    [MenuItem("ADYFX/贴图工具/※贴图色散（RGB通道偏移）", false, 105)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_TexSeSan window = EditorWindow.GetWindow<ADYFX_TexSeSan>();//定义窗口类
        window.minSize = new Vector2(900, 700);//限制窗口最小值
        window.maxSize = new Vector2(1800, 1050);//限制窗口最小值
        window.titleContent = new GUIContent("贴图色散（RGB通道偏移）");//标题内容
        window.position = new Rect(300, 222, 900, 700);
        window.Show();//创建窗口
        ADYFX_Editor.SetColorSpaceValue();
        Debug.Log("当前色彩空间为" + PlayerSettings.colorSpace);
    }
    private void OnGUI()
    {
        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置
        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}

        GUI.Label(new Rect(10, 5, 100, 20), "源图");
        GUI.Label(new Rect(10, 115, 100, 20), "预览图");

        GUI.Label(new Rect(222, 110, 100, 20), "效果强度");
        GUI.Label(new Rect(370, 5, 100, 20), "色散模式");
        GUI.Label(new Rect(720, 5, 100, 20), "偏移的通道");
        var options1 = new[] { GUILayout.Width(128), GUILayout.Height(64) };//定义一个tex2d的宽高
        GUILayout.Space(30);//旧版的空格，2018.3以下
        EditorGUILayout.BeginHorizontal();//      源图选择········
        GUILayout.Space(25);//旧版的空格，2018.3以下
        yuantu = EditorGUILayout.ObjectField(yuantu, typeof(Texture2D), false, options1) as Texture2D;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局

        moshi = GUI.Toolbar(new Rect(250, 29, 300, 30), moshi,new string[] { "偏移模式","缩放模式"});
        pianyitongdao = GUI.Toolbar(new Rect(600, 29, 300, 30), pianyitongdao, new string[] { "RG偏移", "RB偏移", "GB偏移" });
        if (moshi == 0)
        {
            Moshi1();
        }
        else
        {
            Moshi2();
        }
        if (yuantu != null )//预览图 渲染
            EditorGUI.DrawPreviewTexture(new Rect(30, 150, 512, 512), yuantu, mat);//,alphamat, ScaleMode.StretchToFill

        resolution = EditorGUI.Vector2Field(new Rect(585, 250, 300, 40), "输入宽高", resolution);
        if (GUI.Button(new Rect(610, 290, 150, 30), "设为原图宽高"))
        {
            if (yuantu)
                resolution = new Vector2(yuantu.width,yuantu.height);
        }
        GUI.Label(new Rect(585, 320, 100, 20), "命名");
        name1 =  GUI.TextField(new Rect(613, 320, 270, 20), name1);
        if (GUI.Button(new Rect(612, 340, 150, 30), "设为原图命名+序号"))
        {
            if (yuantu)
                name1 = yuantu.name+"_SeSan";
        }
        GUI.Label(new Rect(600, 370,70, 30), "当前路径");
        GUI.Label(new Rect(600, 400, 300, 30), path);
        //GUI.TextField(new Rect(150, 414, 420, 22), name1);
        if (GUI.Button(new Rect(610, 510, 120, 30), "选择路径"))
        {
            path = ADYFX_Editor.GetSystemPath();
        }
        if (GUI.Button(new Rect(740, 510, 120, 30), "设为原图路径"))
        {
            path = ADYFX_Editor.GetFullPath(yuantu);
        }
        if (GUI.Button(new Rect(610,550,250,70),"保存")) 
        {
            if(yuantu)
            Save();
        }
        if (GUI.Button(new Rect(74, 97, 80, 20), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("sesan_Temp");
            if (tempSystemTex != "")
            {
                yuantu = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        if (mouseOverWindow == this)
        {//鼠标位于当前窗口
            if (Event.current.type == EventType.DragUpdated)
            {//拖入窗口未松开鼠标
                DragAndDrop.visualMode = DragAndDropVisualMode.Generic;//改变鼠标外观
            }
            else if (Event.current.type == EventType.DragExited)
            {//拖入窗口并松开鼠标
                Focus();//获取焦点，使unity置顶(在其他窗口的前面)
                        //Rect rect=EditorGUILayout.GetControlRect();
                        //rect.Contains(Event.current.mousePosition);//可以使用鼠标位置判断进入指定区域
                if (DragAndDrop.paths != null)
                {
                    bool bb = ADYFX_Editor.JianChaTexGeShi(DragAndDrop.paths[0], ADYFX_Editor.TexGeShis());
                    if (bb)
                    {
                        yuantu = ADYFX_Editor.GetTex2D(DragAndDrop.paths[0]);
                    }
                }
            }
        }

        GUI.Label(new Rect(240, 149, 100, 20), "Bilibili@ADY521");
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        mat = new Material(Shader.Find("ADYFX/Editer/SeSan_YuLan"));
        addmat = new Material(Shader.Find("ADYFX/Editer/Add"));
    }
     void Moshi1()
    {
            GUI.Label(new Rect(222, 110, 100, 20), "效果强度");
            scale = EditorGUI.Slider(new Rect(300, 110, 600, 18), scale, 0, 0.1f);
            //GUI.Label(new Rect(222, 80, 100, 20), "贴图旋转值");
            //rotate = EditorGUI.Slider(new Rect(300, 80, 600, 18), rotate, 0, 1f);
            GUI.Label(new Rect(700, 170, 100, 20), "色散方向");
            tongdaodir = EditorGUI.Slider(new Rect(590, 190, 300, 18), tongdaodir, 0, 1f);
            fanxiang = GUI.Toggle(new Rect(590, 220, 300, 18), fanxiang, "调换方向");
            u1 = Mathf.Lerp(1, 0, tongdaodir);
            v1 = Mathf.Lerp(0, 1, tongdaodir);
            if (pianyitongdao == 0)
            {
                mat.SetFloat("_Scale", scale);
                mat.SetTexture("_MainTex", yuantu);
                mat.SetFloat("_SclaeMod", 0);
                mat.SetInt("_SuoFang", 1);
                mat.SetFloat(boffsetX, 0);
                mat.SetFloat(boffsetY, 0);
                if (fanxiang)
                {
                    mat.SetFloat(roffsetX, -u1);
                    mat.SetFloat(roffsetY, -v1);
                    mat.SetFloat(goffsetX, u1);
                    mat.SetFloat(goffsetY, v1);
                }
                else
                {
                    mat.SetFloat(roffsetX, u1);
                    mat.SetFloat(roffsetY, v1);
                    mat.SetFloat(goffsetX, -u1);
                    mat.SetFloat(goffsetY, -v1);
                }
            }
            if (pianyitongdao == 1)
            {
                mat.SetFloat("_Scale", scale);
                mat.SetTexture("_MainTex", yuantu);
                mat.SetFloat("_SclaeMod", 0);
                mat.SetInt("_SuoFang", 1);
                mat.SetFloat(goffsetX, 0);
                mat.SetFloat(goffsetY, 0);
                if (fanxiang)
                {
                    mat.SetFloat(roffsetX, -u1);
                    mat.SetFloat(roffsetY, -v1);
                    mat.SetFloat(boffsetX, u1);
                    mat.SetFloat(boffsetY, v1);
                }
                else
                {
                    mat.SetFloat(roffsetX, u1);
                    mat.SetFloat(roffsetY, v1);
                    mat.SetFloat(boffsetX, -u1);
                    mat.SetFloat(boffsetY, -v1);
                }
            }
            if (pianyitongdao == 2)
            {
                mat.SetFloat("_Scale", scale);
                mat.SetTexture("_MainTex", yuantu);
                mat.SetFloat("_SclaeMod", 0);
                mat.SetInt("_SuoFang", 1);
                mat.SetFloat(roffsetX, 0);
                mat.SetFloat(roffsetY, 0);
                if (fanxiang)
                {
                    mat.SetFloat(goffsetX, -u1);
                    mat.SetFloat(goffsetY, -v1);
                    mat.SetFloat(boffsetX, u1);
                    mat.SetFloat(boffsetY, v1);
                }
                else
                {
                    mat.SetFloat(goffsetX, u1);
                    mat.SetFloat(goffsetY, v1);
                    mat.SetFloat(boffsetX, -u1);
                    mat.SetFloat(boffsetY, -v1);
                }
            }
    }
    public void Moshi2()
    {
        //rotate = EditorGUI.Slider(new Rect(300, 80, 600, 18), rotate, 0, 1f);
        suofang = EditorGUI.Slider(new Rect(300, 110, 600, 18), suofang, 0, 0.1f);
        suofangfanxiang = GUI.Toggle(new Rect(590, 220, 300, 18), suofangfanxiang, "调换方向");
        suoxiao = Mathf.Lerp(1, 2, suofang);
        fangda = Mathf.Lerp(1, 0, suofang);
        //GUI.Label(new Rect(222, 80, 100, 20), "贴图旋转值");
        GUI.Label(new Rect(222, 110, 100, 20), "效果强度");
        if (pianyitongdao == 0)
        {
            mat.SetFloat("_Scale", 0);
            mat.SetTexture("_MainTex", yuantu);
            mat.SetFloat("_SclaeMod", 1);

            mat.SetFloat(boffsetX, 0);
            mat.SetFloat(boffsetY, 0);
            mat.SetFloat(roffsetX, 0);
            mat.SetFloat(roffsetY, 0);
            mat.SetFloat(goffsetX, 0);
            mat.SetFloat(goffsetY, 0);
            if (suofangfanxiang)
            {
                mat.SetFloat("_SuoFang0", fangda);
                mat.SetFloat("_SuoFang1", suoxiao);
                mat.SetFloat("_SuoFang2", 1);
            }
            else
            {
                mat.SetFloat("_SuoFang0", suoxiao);
                mat.SetFloat("_SuoFang1", fangda);
                mat.SetFloat("_SuoFang2", 1);
            }
        }
        if (pianyitongdao == 1)
        {
            mat.SetFloat("_Scale", 0);
            mat.SetTexture("_MainTex", yuantu);
            mat.SetFloat("_SclaeMod", 1);

            mat.SetFloat(goffsetX, 0);
            mat.SetFloat(goffsetY, 0);
            mat.SetFloat(boffsetX, 0);
            mat.SetFloat(boffsetY, 0);
            mat.SetFloat(roffsetX, 0);
            mat.SetFloat(roffsetY, 0);
            mat.SetFloat(goffsetX, 0);
            mat.SetFloat(goffsetY, 0);
            if (suofangfanxiang)
            {
                mat.SetFloat("_SuoFang0", fangda);
                mat.SetFloat("_SuoFang1", 1);
                mat.SetFloat("_SuoFang2", suoxiao);
            }
            else
            {
                mat.SetFloat("_SuoFang0", suoxiao);
                mat.SetFloat("_SuoFang1", 1);
                mat.SetFloat("_SuoFang2", fangda);
            }
        }
        if (pianyitongdao == 2)
        {
            mat.SetFloat("_Scale", 0);
            mat.SetTexture("_MainTex", yuantu);
            mat.SetFloat("_SclaeMod", 1);
            mat.SetFloat("_SuoFang0", 1);
            mat.SetFloat("_SuoFang1", suoxiao);
            mat.SetFloat("_SuoFang2", fangda);
            mat.SetFloat(roffsetX, 0);
            mat.SetFloat(roffsetY, 0);
            mat.SetFloat(boffsetX, 0);
            mat.SetFloat(boffsetY, 0);
            mat.SetFloat(roffsetX, 0);
            mat.SetFloat(roffsetY, 0);
            mat.SetFloat(goffsetX, 0);
            mat.SetFloat(goffsetY, 0);
            if (suofangfanxiang)
            {
                mat.SetFloat("_SuoFang0", 1);
                mat.SetFloat("_SuoFang1", fangda);
                mat.SetFloat("_SuoFang2", suoxiao);
            }
            else
            {
                mat.SetFloat("_SuoFang0", 1);
                mat.SetFloat("_SuoFang1", suoxiao);
                mat.SetFloat("_SuoFang2", fangda);
            }
        }
        }

    void Save()
    {
        if (yuantu != null)
        {
            rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, yuantu, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Graphics.Blit(rt, rt1,mat);
            Graphics.Blit(rt1, rt);
            GL.PopMatrix();//GL.保存矩阵
            Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
            texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            texture2D.Apply();
            colorall = new Color[(int)(texture2D.width * texture2D.height)];//初始化颜色数组长度为出图宽高
            colorall = texture2D.GetPixels();
            //if (PlayerSettings.colorSpace == ColorSpace.Linear) //判断色彩空间，如果是线性空间则校正色彩
            //{
            //    for (int j = 0; j < colorall.Length; j++)
            //    {
            //        colorall[j].r = Mathf.Pow(colorall[j].r, 1 / 2.2f);
            //        colorall[j].g = Mathf.Pow(colorall[j].g, 1 / 2.2f);
            //        colorall[j].b = Mathf.Pow(colorall[j].b, 1 / 2.2f);
            //        //colorall[j].a = Mathf.Pow(colorall[j].a, 1 / 2.2f);
            //    }
            //}
            texture2D.SetPixels(colorall);//写入color[]到 像素数据 
            texture2D.Apply();
            ADYFX_Editor.SaveTex(texture2D, path, name1, "_", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            serial += 1;
            RenderTexture.active = null;//RT置空
        }
    }

    void Update()
    {
        //time += 1;
        //if (time > 4)
        //    time = 0;
        //if (time == 4)//每6次update执行一次重绘GUI  约每秒40帧
        //{
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
        //}
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法
        if (lowtexpath == ADYFX_Editor.GetPath(yuantu))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && yuantu != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuantu)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(yuantu));//应用设置 并刷新资源库
                isImporter = false;
            }
        }
        else
        {//资源变动时 记录当前图像设置 在下次换图的时候给它修改回去 
            if (lowtexpath != "")//上一个图像不是空的话 则改回旧图像原本的npotScale
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(lowtexpath) as TextureImporter;
                tex1.npotScale = lowTextureImporterNPOTScale;
                AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
            }
            //先记录新图像的导入设置  再开启isImporter 在下一针改变新贴图的npotScale为none以确保能获取正确的原图尺寸
            if (yuantu != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuantu)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowtexpath = ADYFX_Editor.GetPath(yuantu);//low路径记录为当前路径
                isImporter = true;
            }
            else 
            {
                lowtexpath = "";
            }
        }
    }
    private void OnDestroy()
    {//关闭当前窗口时  设置当前挂载的图像的导入设置为本身的设置
        if (yuantu)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuantu)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
}
