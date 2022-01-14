using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class ADYFX_SplitSequence : EditorWindow
{
    string path = ">>还未选择路径";
    string name1 = "ADYFX_SeSan";
    Material caifenSavemat;
    RenderTexture rt;
    Texture2D gouxuan;
    RenderTexture rt1;
    int serial;
    bool ischuangjianwenjianjia = false;
    Material addmat;
    Material alphamat;
    Material qiePianYuLan;
    private int moshi = 0;
    public Texture2D yuantu;
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    int time = 0;
    public Material mat;
    private Vector2 resolution = new Vector2(256, 256);
    public Texture2D yulantu;
    private int xulieW = 4;
    private int xulieH = 4;
    Texture2D boxtex;
    int moshi2qutu;
    Material wanggemat;
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    Color[] colorall;
    [MenuItem("ADYFX/贴图工具/※拆分序列图", false, 106)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_SplitSequence window = EditorWindow.GetWindow<ADYFX_SplitSequence>();//定义窗口类
        window.minSize = new Vector2(1300, 1000);//限制窗口最小值
        window.maxSize = new Vector2(1920, 1000);//限制窗口最小值
        window.titleContent = new GUIContent("拆分序列图");//标题内容
        window.position = new Rect(300, 5, 1300, 1000);
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

        GUI.Label(new Rect(140, 55, 40, 20), "源图");
        GUI.Label(new Rect(50, 110, 100, 20), "预览图");
        var options1 = new[] { GUILayout.Width(128), GUILayout.Height(64) };//定义一个tex2d的宽高
        GUILayout.Space(35);//旧版的空格，2018.3以下
        EditorGUILayout.BeginHorizontal();//      源图选择········
        GUILayout.Space(5);//旧版的空格，2018.3以下
        yuantu = EditorGUILayout.ObjectField(yuantu, typeof(Texture2D), false, options1) as Texture2D;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局

        moshi = GUI.Toolbar(new Rect(5, 0, 400, 30), moshi, new string[] { "提取全部", "提取一张" });
        if (moshi == 0)
        {
            Moshi1();
        }
        if (moshi == 1)
        {
            Moshi2();
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
        if (GUI.Button(new Rect(140, 81, 80, 20), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("cfxl_Temp");
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
        ischuangjianwenjianjia =  GUI.Toggle(new Rect(890,520,300,25), ischuangjianwenjianjia, "在保存路径中创建子文件夹来存储");
        if (ischuangjianwenjianjia) 
        {
        
        }
        GUI.Label(new Rect(1000, 10, 100, 20), "Bilibili@ADY521");
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        wanggemat = new Material(Shader.Find("ADYFX/Editer/PngWangGe"));
        qiePianYuLan = new Material(Shader.Find("ADYFX/Editer/CaiFenXuLie_YuLan"));
        addmat = new Material(Shader.Find("ADYFX/Editer/Add"));
        alphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
        boxtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/boxtex_1.png");
        qiePianYuLan.SetTexture("_MainTex",boxtex);
        qiePianYuLan.SetColor("_MainColor",new Color(1,0,0,1));
        caifenSavemat = new Material(Shader.Find("ADYFX/Editer/CaiFenXuLie"));
        gouxuan = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/gouxuan.png");
    }

    void Moshi1()
    {
        if (yuantu != null) 
        {
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), yuantu, wanggemat);//,alphamat, ScaleMode.StretchToFill
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), yuantu, alphamat);//,alphamat, ScaleMode.StretchToFill
        }//预览图 渲染
        if (yuantu != null)//预览图 框 渲染
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), boxtex, qiePianYuLan);//,alphamat, ScaleMode.StretchToFill

        qiePianYuLan.SetVector("_Tiling", new Vector4(xulieW, xulieH, 0, 0));

        xulieW = EditorGUI.IntField(new Rect(890, 130, 200, 20), "序列 横向数量", Mathf.Clamp(xulieW, 1, 64));
        xulieH = EditorGUI.IntField(new Rect(890, 160, 200, 20), "序列 纵向数量", Mathf.Clamp(xulieH, 1, 64));

        resolution = EditorGUI.Vector2Field(new Rect(890, 200, 300, 40), "出图宽高", resolution);
        if (GUI.Button(new Rect(890, 245, 100, 25), "自动计算"))
        {
            if (yuantu)
                resolution = new Vector2(yuantu.width / xulieW, yuantu.height / xulieH);
        }

        GUI.Label(new Rect(890, 270, 100, 20), "命名");
        name1 = GUI.TextField(new Rect(890, 290, 500, 20), name1);


        if (GUI.Button(new Rect(890, 315, 150, 25), "设为原图命名+序号"))
        {
            if (yuantu)
                name1 = yuantu.name + "_SplitSequence";
        }
        GUI.Label(new Rect(890, 345, 70, 30), "当前路径");
        GUI.Label(new Rect(890, 380, 400, 30), path);

        if (GUI.Button(new Rect(890, 415, 120, 30), "选择路径"))
        {
            path = ADYFX_Editor.GetSystemPath();
        }
        if (GUI.Button(new Rect(1020, 415, 120, 30), "设为原图路径"))
        {
            path = ADYFX_Editor.GetFullPath(yuantu);
        }
        if (GUI.Button(new Rect(890, 450, 250, 70), "保存"))
        {
            if (yuantu)
                Save();
        }
    }
    void Moshi2()
    {
        float xpos = 850 / xulieW;
        float ypos = 850 / xulieH;
        List<Vector2> poss = new List<Vector2>();
        for (int i = 0; i < xulieH; i++)
        {
            for (int j = 0;j< xulieW; j++)
            {
                poss.Add(new Vector2(20 + xpos * j, 130 + ypos * i));
            }
        }
        string baocunpanduan;
        if (yuantu != null) 
        {
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), yuantu, wanggemat);//,alphamat, ScaleMode.StretchToFill
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), yuantu, alphamat);//,alphamat, ScaleMode.StretchToFill
        }//预览图 渲染
        if (yuantu != null)//预览图 框 渲染
            EditorGUI.DrawPreviewTexture(new Rect(20, 130, 850, 850), boxtex, qiePianYuLan);//,alphamat, ScaleMode.StretchToFill

        qiePianYuLan.SetVector("_Tiling", new Vector4(xulieW, xulieH, 0, 0));

        xulieW = EditorGUI.IntField(new Rect(890, 80, 200, 20), "序列 横向数量", Mathf.Clamp(xulieW, 1, 64));
        xulieH = EditorGUI.IntField(new Rect(890, 110, 200, 20), "序列 纵向数量", Mathf.Clamp(xulieH, 1, 64));
        GUI.Label(new Rect(890, 145, 50, 20), "取图序号");
        moshi2qutu = (int)EditorGUI.Slider(new Rect(950,145,300,20), moshi2qutu,0, (xulieW*xulieH)-1);

        resolution = EditorGUI.Vector2Field(new Rect(890, 200, 300, 40), "出图宽高", resolution);
        if (GUI.Button(new Rect(890, 245, 100, 25), "自动计算"))
        {
            if (yuantu)
                resolution = new Vector2(yuantu.width / xulieW, yuantu.height / xulieH);
        }

        GUI.Label(new Rect(890, 270, 100, 20), "命名");
        name1 = GUI.TextField(new Rect(890, 290, 500, 20), name1);


        if (GUI.Button(new Rect(890, 315, 150, 25), "设为原图命名+序号"))
        {
            if (yuantu)
                name1 = yuantu.name + "_Split";
        }
        GUI.Label(new Rect(890, 345, 70, 30), "当前路径");
        GUI.Label(new Rect(890, 380, 400, 30), path);

        if (GUI.Button(new Rect(890, 415, 120, 30), "选择路径"))
        {
            path = ADYFX_Editor.GetSystemPath();
        }
        if (GUI.Button(new Rect(1020, 415, 120, 30), "设为原图路径"))
        {
            path = ADYFX_Editor.GetFullPath(yuantu);
        }

        if (moshi2qutu >= xulieW * xulieH)
        {
            baocunpanduan = "取图序号超出！无法保存";
        }
        else
        {
            EditorGUI.DrawPreviewTexture(new Rect(poss[moshi2qutu].x, poss[moshi2qutu].y, 32, 32), gouxuan, alphamat);//,alphamat, ScaleMode.StretchToFill
            baocunpanduan = "保存";
        }
        if (GUI.Button(new Rect(890, 450, 250, 70), baocunpanduan))
        {
            if (moshi2qutu < xulieW * xulieH)
            {
                if (yuantu)
                    Save1();
            }
        }
    }
    void Save()
    {
        if (yuantu != null)
        {
            string temppath = path + "/" + name1;
            temppath = temppath.Replace('/', '\\');

            caifenSavemat.SetInt("_W", xulieW);
            caifenSavemat.SetInt("_H", xulieH);
            for (int i = 0;i <xulieW*xulieH;i++)
            {
                caifenSavemat.SetInt("_Count", i);
                rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
                RenderTexture.active = rt;//RT运行
                GL.PushMatrix();//GL.获取矩阵
                GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
               //Graphics.DrawTexture(rect, yuantu, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
                Graphics.DrawTexture(new Rect(0, 0, rt.width, rt.height), yuantu, caifenSavemat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
                GL.PopMatrix();//GL.保存矩阵
                Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
                texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
                texture2D.Apply();
                colorall = new Color[(int)(texture2D.width * texture2D.height)];//初始化颜色数组长度为出图宽高
                colorall = texture2D.GetPixels();
                texture2D.SetPixels(colorall);//写入color[]到 像素数据 
                texture2D.Apply();
                if (ischuangjianwenjianjia)
                {
                    if (!Directory.Exists(temppath))//判断有没有temp文件夹 如果没有就创建
                    {
                        Directory.CreateDirectory(temppath);
                    }
                    ADYFX_Editor.SaveTex(texture2D, temppath, name1, "_", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
                }
                else 
                {
                    ADYFX_Editor.SaveTex(texture2D, path, name1, "_", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
                }
                serial += 1;
                RenderTexture.active = null;//RT置空
            }
            serial = 0;
        }
    }
    void Save1()
    {
        if (yuantu != null)
        {
            caifenSavemat.SetInt("_W", xulieW);
            caifenSavemat.SetInt("_H", xulieH);
                caifenSavemat.SetInt("_Count", moshi2qutu);
                rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
                RenderTexture.active = rt;//RT运行
                GL.PushMatrix();//GL.获取矩阵
                GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
                                                              //Graphics.DrawTexture(rect, yuantu, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
                Graphics.DrawTexture(new Rect(0, 0, rt.width, rt.height), yuantu, caifenSavemat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
                GL.PopMatrix();//GL.保存矩阵
                Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
                texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
                texture2D.Apply();
                colorall = new Color[(int)(texture2D.width * texture2D.height)];//初始化颜色数组长度为出图宽高
                colorall = texture2D.GetPixels();
                texture2D.SetPixels(colorall);//写入color[]到 像素数据 
                texture2D.Apply();
                ADYFX_Editor.SaveTex(texture2D, path, name1, "_", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
                serial += 1;
                RenderTexture.active = null;//RT置空
        }
    }

    void Update()
    {
        time += 1;
        if (time > 4)
            time = 0;
        if (time == 4)//每6次update执行一次重绘GUI  约每秒40帧
        {
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
        }
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
