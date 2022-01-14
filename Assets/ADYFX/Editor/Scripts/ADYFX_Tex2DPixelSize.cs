using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
    
public class ADYFX_Tex2DPixelSize : EditorWindow
{
    SaveGeshi geshi;
    string lingcunname = "";
    string path = "";
    public float time = 0f;
    int danxuanbtn = 1;
    public string name1;
    private Texture sourceTex0;
    private Vector2 resolution = new Vector2(256,256);
    private string bukebaocun = "这个格式不支持覆盖保存 请另存";
    private string baoc = "保存";
    private string save = "保存";
    bool tt = false;
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    [MenuItem("ADYFX/贴图工具/※修改贴图大小（单张）", false, 104)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_Tex2DPixelSize window = EditorWindow.GetWindow<ADYFX_Tex2DPixelSize>();//定义窗口类
        window.minSize = new Vector2(840, 500);//限制窗口最小值
        window.maxSize = new Vector2(840, 500);//限制窗口最小值
        window.titleContent = new GUIContent("改变贴图大小");//标题内容
        window.position = new Rect(200, 120, 840, 500);
        window.Show();//创建窗口
    }
    private void OnGUI()
    {
        //if (Event.current.type == EventType.ValidateCommand)
        //{
        //    Debug.LogError(EventType.ValidateCommand+"0");//有某种操作被触发（例如复制和粘贴）
        //}
        if (Event.current.type == EventType.ExecuteCommand)//判断资源变动
        {
            if (sourceTex0) 
            {
                lingcunname = sourceTex0.name + "_Size_1";
                path = ADYFX_Editor.GetFullPath(sourceTex0);//获取源文件在系统中的完整路径
                name1 = sourceTex0.name;
                //Debug.Log("加入");
            }
            if(sourceTex0 == null) 
            {
                lingcunname = "";
                path = "";
            }
        }
        GUILayout.Space(15);
        GUILayout.Label("                    选择一个贴图（或拖拽贴图到窗口任意区域以添加）");
        var options = new[] { GUILayout.Width(197), GUILayout.Height(117) };//定义一个tex2d的宽高
        GUILayout.Space(10);
        EditorGUILayout.BeginHorizontal();//开始水平布局
        GUILayout.Space(17);
        sourceTex0 = EditorGUILayout.ObjectField(sourceTex0, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
                                                                                                           //mesh = EditorGUILayout.ObjectField(mesh, typeof(Mesh), false, options) as Mesh;//然后声明这个tex2d
                                                                                                           //temmp = EditorGUILayout.ObjectField(temmp, typeof(Texture), false, options) as Texture;//然后声明这个tex2d
                                                                                                           //wh.x = GUILayout.HorizontalSlider(wh.x, 8, 8192);//纵向滑条
                                                                                                           //wh.y = GUILayout.HorizontalSlider(wh.y, 8, 8192);//纵向滑条
        resolution = EditorGUI.Vector2Field(new Rect(250, 85, 300, 40), "手动输入宽高", resolution);
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(15);
        GUILayout.Label("2的整次幂快速选择");
        GUILayout.Space(8);
        EditorGUILayout.BeginHorizontal();//开始水平布局
        if (GUILayout.Button("32*32", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(32,32);
        }
        if (GUILayout.Button("64*64", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(64, 64);
        }
        if (GUILayout.Button("128*128", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(128, 128);
        }
        if (GUILayout.Button("256*256", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(256, 256);
        }
        if (GUILayout.Button("512*512", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(512, 512);
        }
        if (GUILayout.Button("1024*1024", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(1024, 1024);
        }
        if (GUILayout.Button("2048*2048", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(2048, 2048);
        }
        if (GUILayout.Button("4096*4096", GUILayout.Width(100), GUILayout.Height(30)))//特别设置按钮宽高
        {
            resolution = new Vector2(4096, 4096);
        }
        GUILayout.EndHorizontal();

        GUILayout.Space(230);
        GUI.Label(new Rect(20, 467, 50, 20), "另存格式");
        GUI.Label(new Rect(230, 165, 700, 20), "※ 外部图片不能直接覆盖保存  且不会刷新保存路径  保存时请注意路径选择  防止覆盖上次处理的贴图！");
        danxuanbtn = GUI.Toolbar(new Rect(150, 467, 300, 20), danxuanbtn, new string[] { "jpg", "png", "tga" });
        //danxuanbtn = GUILayout.Toolbar(danxuanbtn, new string[] { "jpg", "png", "tga" });//可纵向布局的多选按钮
        GUI.Label(new Rect(580, 300, 400, 50),"※ 直接保存会覆盖原图  过程不可逆  请注意备份");
        GUI.Label(new Rect(20, 350, 200, 30), "保存时命名（原名）");
        GUI.Label(new Rect(150, 355, 420, 22), name1);
        GUI.Label(new Rect(20, 410, 200, 30), "另存为时命名");
        GUI.Label(new Rect(20, 435, 100, 30), "当前路径");
        lingcunname = GUI.TextField(new Rect(150, 414, 420, 22),lingcunname);
        //GUI.Label(new Rect(150, 400, 600, 30), lingcunname);
        GUI.Label(new Rect(150, 435, 600, 30), path);
        if (GUI.Button(new Rect(600, 350, 200, 50), save))
        {

            //Object obj = AssetDatabase.LoadMainAssetAtPath(ADYFX_Editor.GetPath(sourceTex0));
            //Selection.activeObject = obj;

            string nnn = "";
            if (sourceTex0)
                nnn = ADYFX_Editor.GetPath(sourceTex0);
            if (ADYFX_Editor.JianChaTexGeShi(nnn, "png"))
            {
                geshi = SaveGeshi.PNG;
            }
            else if (ADYFX_Editor.JianChaTexGeShi(nnn, "PNG"))
            {
                geshi = SaveGeshi.PNG;
            }
            else if (ADYFX_Editor.JianChaTexGeShi(nnn, "JPG"))
            {
                geshi = SaveGeshi.JPG;
            }
            else if (ADYFX_Editor.JianChaTexGeShi(nnn, "jpg"))
            {
                geshi = SaveGeshi.JPG;
            }
            else if (ADYFX_Editor.JianChaTexGeShi(nnn, "tga"))
            {
                geshi = SaveGeshi.TGA;
            }
            else
            {
                geshi = SaveGeshi.TGA;
            }
            Save();
        }
        if (GUI.Button(new Rect(600, 410, 80, 25), "原名加序号"))
        {
            lingcunname = sourceTex0.name + "_Size_1";
        }
        if (GUI.Button(new Rect(600, 435, 80, 25), "选择路径"))
        {
            path = ADYFX_Editor.GetSystemPath();
        }
        if (GUI.Button(new Rect(680, 410, 120, 50), "另存"))
        {
            if (danxuanbtn == 0)
            {
                geshi = SaveGeshi.JPG;
            }
            else if (danxuanbtn == 1)
            {
                geshi = SaveGeshi.PNG;
            }
            else
            {
                geshi = SaveGeshi.TGA;
            }
            Save1();
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
                        sourceTex0 = ADYFX_Editor.GetTex2D(DragAndDrop.paths[0]);
                        lingcunname =  sourceTex0.name+"_Size_1";
                        //path = ADYFX_Editor.GetPath(sourceTex0);
                        path = ADYFX_Editor.GetFullPath(sourceTex0);//获取源文件在系统中的完整路径
                        name1 = sourceTex0.name;

                        //可保存格式检查 以改变保存按钮的状态
                       tt = ADYFX_Editor.JianChaTexGeShi(DragAndDrop.paths[0], ADYFX_Editor.TexSaveGeShi());
                        if (tt)
                        {
                            save = baoc;
                        }
                        else 
                        {
                            save = bukebaocun;
                        }
                    }
                }
            }
        }
        if (GUI.Button(new Rect(135, 165, 80, 20), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("texsize_Temp");
            if (tempSystemTex != "")
            {
                sourceTex0 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        GUI.Label(new Rect(730, 475, 200, 30), "bilibili@ADY521");
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    void Update()
    {
        time += 1;
        if (time > 6)
            time = 0;
        if (time == 6)//每6次update执行一次重绘GUI  约每秒40帧 
        {
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
        }
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
    }
    void Save()
    {
        Color[] colorall = new Color[0];
        Texture2D t2;
        t2 = ADYFX_Editor.GetTexColor_Texture2D((Texture2D)sourceTex0);
        t2 = ADYFX_Editor.TextureScale((Texture2D)t2, resolution.x, resolution.y);
        colorall = t2.GetPixels();
        TextureFormat _texFormat;
        if (danxuanbtn == 0)
        {
            _texFormat = TextureFormat.RGB24;
        }
        else
        {
            _texFormat = TextureFormat.ARGB32;
        }
        Texture2D texture2D = new Texture2D((int)resolution.x, (int)resolution.y, _texFormat, false);
        texture2D.SetPixels(colorall);//写入color[]到 像素数据 
        texture2D.Apply();
        ADYFX_Editor.GetFullPath(sourceTex0);
        string tempgeshi;
        if (geshi == SaveGeshi.PNG)
        {
            tempgeshi = ".png";
        }
        else if (geshi == SaveGeshi.JPG)
        {
            tempgeshi = ".jpg";
        }
        else
        {
            tempgeshi = ".tga";
        }
        ADYFX_Editor.SaveTex(texture2D, path, name1, "", geshi, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
        sourceTex0 = null;
        AssetDatabase.Refresh();//刷新资源库
        //在库中选择生成的物体
        ADYFX_Editor.SeleAssetsObj(ADYFX_Editor.WinPathToAssetsPath(path + "/" + name1 + tempgeshi));
    }
    void Save1()
    {
        Color[] colorall = new Color[0];
        Texture2D t2;
        t2 = ADYFX_Editor.GetTexColor_Texture2D((Texture2D)sourceTex0);
        t2 = ADYFX_Editor.TextureScale((Texture2D)t2, resolution.x, resolution.y);
        colorall = t2.GetPixels();
        TextureFormat _texFormat;
        if (danxuanbtn == 0)
        {
            _texFormat = TextureFormat.RGB24;
        }
        else
        {
            _texFormat = TextureFormat.ARGB32;
        }
        Texture2D texture2D = new Texture2D((int)resolution.x, (int)resolution.y, _texFormat, false);
        texture2D.SetPixels(colorall);//写入color[]到 像素数据 
        texture2D.Apply();
        string tempgeshi;
        if (geshi == SaveGeshi.PNG)
        {
            tempgeshi = ".png";
        }
        else if (geshi == SaveGeshi.JPG)
        {
            tempgeshi = ".jpg";
        }
        else
        {
            tempgeshi = ".tga";
        }
        ADYFX_Editor.SaveTex(texture2D, path, lingcunname, "", geshi, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
        //sourceTex0 = null;
        AssetDatabase.Refresh();//刷新资源库
        //在库中选择生成的物体
        ADYFX_Editor.SeleAssetsObj(ADYFX_Editor.WinPathToAssetsPath(path + "/" + lingcunname + tempgeshi));
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法

        if (lowtexpath == ADYFX_Editor.GetPath(sourceTex0))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && sourceTex0 != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex0)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(sourceTex0));//应用设置 并刷新资源库
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
            if (sourceTex0 != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex0)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowtexpath = ADYFX_Editor.GetPath(sourceTex0);//low路径记录为当前路径
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
        if (sourceTex0)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex0)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
}
