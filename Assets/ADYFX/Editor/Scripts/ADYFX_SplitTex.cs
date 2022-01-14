using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ADYFX_SplitTex : EditorWindow
{
    public Material caiFenMat0;
    public Material caiFenMat1;
    public Material caiFenMat2;
    public Material caiFenMat3;
    int time = 0;
    public Texture temmp;
    Color[] colorall1;
    bool istiquR = true;
    bool istiquG = true;
    bool istiquB = false;
    bool istiquA = false;
    public string path = ">>还未选择保存路径";
    public int serial = 1;
    public string tex2dName = "ADYFX_ChaiFen";
    public Texture2D toumingtex;
    //GUIStyle btnStyle01 = new GUIStyle();//新建按钮样式
    GUIStyle shurukuangstyle = new GUIStyle();
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    private Texture2D BGtexture02;
    public Texture2D helptex;
    public Material addmat;
    public Material alphamat;
    public Shader btnhoverShader;//绘制按钮悬停特效的shader
    public Material btnhoverMat;
    public Texture2D txglowtex;//帮助特效流光
    public Texture2D txglowmasktex;//帮助特效遮罩
    bool iswaibu = false;
    public Texture2D sourceTex4;

    public Texture sele01YuLan;
    private Material flattenTex_YuLanMat;
    private Texture selsetex;
    private Texture boxbooltex;
    private Texture boxbooltex1;
    private Texture rgbaSelseR;
    private Texture rgbaSelseG;
    private Texture rgbaSelseB;
    private Texture rgbaSelseA;
    private Texture bantoumbtn;
    private bool isMulAlpha = false;
    public Vector2 resolution1 = new Vector2(512, 512);
    bool isAlpha = false;
    bool isHeiBai = false;
    bool isAlpha1 = false;
    bool isrgba = false;
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool lowTextureImporterIsalpha = false;
    bool isImporter = false;
    [MenuItem("ADYFX/贴图工具/※拆分通道存为贴图", false, 103)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_SplitTex window = EditorWindow.GetWindow<ADYFX_SplitTex>();//定义窗口类
        window.minSize = new Vector2(1200, 650);//限制窗口最小值
        window.maxSize = new Vector2(1200, 650);//限制窗口最小值
        window.titleContent = new GUIContent("拆分通道存为贴图");//标题内容
        window.position = new Rect(200, 60, 1200, 650);
        window.Show();//创建窗口
        ADYFX_Editor.SetColorSpaceValue();
        Debug.Log("当前色彩空间为" + PlayerSettings.colorSpace);
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    private void OnGUI()
    {
        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置
        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}
        Sele02();
        EditorGUI.DrawPreviewTexture(new Rect(1126, 15, 38, 38), helptex, alphamat);
        if (myMousePosition.x > 1100 && myMousePosition.x < 1200 && myMousePosition.y > 0 && myMousePosition.y < 64)
        {//判断是否在帮助按钮下，如果在 就显示悬停特效btnhoverMat
            EditorGUI.DrawPreviewTexture(new Rect(1055, -56, 180, 180), txglowtex, btnhoverMat, ScaleMode.StretchToFill);
            GUI.Label(new Rect(myMousePosition.x - 170, myMousePosition.y - 5, 150, 25), "点击获取更多工具和帮助");
            if (Event.current.type == EventType.MouseDown)
            {
                Application.OpenURL("https://space.bilibili.com/7234711");
            }
        }
        if (GUI.Button(new Rect(210, 605, 100, 25), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("CFTD_Temp");
            if (tempSystemTex != "")
            {
                sourceTex4 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex,false);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        GUI.Label(new Rect(550, 600, 300, 50), "Bilibili@ADY521");
    }
    private void Sele02()
    {
        if (BGtexture02 != null)//绘制背景图
        {
            EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1200, 650), BGtexture02);
        }
        var options = new[] { GUILayout.Width(284), GUILayout.Height(452) };//定义一个tex2d的宽高
        GUILayout.Space(148);
        EditorGUILayout.BeginHorizontal();//开始水平布局
        GUILayout.Space(22);
        sourceTex4 = EditorGUILayout.ObjectField(sourceTex4, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局
        isMulAlpha =  GUI.Toggle(new Rect(955,127,222,25), isMulAlpha, "R、G、B通道先乘A通道再提取");
        if (isMulAlpha)
        {
            caiFenMat0.SetFloat("_isMulAlpha", 1);
            caiFenMat1.SetFloat("_isMulAlpha", 1);
            caiFenMat2.SetFloat("_isMulAlpha", 1);
        }
        else 
        {
            caiFenMat0.SetFloat("_isMulAlpha", 0);
            caiFenMat1.SetFloat("_isMulAlpha", 0);
            caiFenMat2.SetFloat("_isMulAlpha", 0);
        }
        if (sourceTex4 != null)
        {
            EditorGUI.DrawPreviewTexture(new Rect(345, 148, 215, 215), sourceTex4, caiFenMat0);
            EditorGUI.DrawPreviewTexture(new Rect(586, 149, 215, 215), sourceTex4, caiFenMat1);
            EditorGUI.DrawPreviewTexture(new Rect(345, 384, 215, 215), sourceTex4, caiFenMat2);
            EditorGUI.DrawPreviewTexture(new Rect(586, 384, 215, 215), sourceTex4, caiFenMat3);
        }
        EditorGUI.DrawPreviewTexture(new Rect(345, 148, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(586, 149, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(345, 384, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(586, 384, 25, 25), rgbaSelseA, alphamat);

        resolution1 = EditorGUI.Vector2Field(new Rect(890, 160, 250, 80), "", resolution1);//输出图像尺寸
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(881, 980, 194, 223), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(881, 194, 100, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex4 != null)
                resolution1 = new Vector2(sourceTex4.width, sourceTex4.height);
        }

        path = EditorGUI.TextField(new Rect(890, 259, 300, 20), "", path, shurukuangstyle);//路径选择模块
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(991, 1090, 305, 336), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(991, 304, 100, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex4 != null)
                path = ADYFX_Editor.GetFullPath(sourceTex4);//获取源文件在系统中的完整路径
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(881, 983, 304, 335), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(881, 304, 100, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown)
                path = ADYFX_Editor.GetSystemPath();
        }

        tex2dName = EditorGUI.TextField(new Rect(890, 355, 400, 20), "", tex2dName, shurukuangstyle);//名称选择模块
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(881, 983, 401, 431), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(881, 401, 100, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex4 != null)
                tex2dName = sourceTex4.name;
        }

        if (isAlpha1) //alpha布尔值
        {
            EditorGUI.DrawPreviewTexture(new Rect(1104, 406, 15, 15), boxbooltex);//alpha布尔值
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1099, 1200, 401, 440), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown)
            {
                isAlpha1 = !isAlpha1;
            }
        }

        if (isrgba) //后缀设置
        {
            EditorGUI.DrawPreviewTexture(new Rect(890, 456, 15, 15), boxbooltex1, alphamat);
        }
        else
        {
            EditorGUI.DrawPreviewTexture(new Rect(997, 456, 15, 15), boxbooltex1, alphamat);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(888, 978, 449, 476), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown)
            {
                isrgba = true;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(995, 1071, 449, 476), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown)
            {
                isrgba = false;
            }
        }
        //提取的通道选择模块
        EditorGUI.DrawPreviewTexture(new Rect(955, 102, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(985, 102, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(1015, 102, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(1045, 102, 25, 25), rgbaSelseA, alphamat);
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(955, 980, 102, 132), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown)
            {
                istiquR = !istiquR;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(985, 1010, 102, 132), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown)
            {
                istiquG = !istiquG;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1015, 1040, 102, 132), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown)
            {
                istiquB = !istiquB;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1045, 1070, 102, 132), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown)
            {
                istiquA = !istiquA;
            }
        }
        if (istiquR)
            EditorGUI.DrawPreviewTexture(new Rect(955, 102, 25, 25), bantoumbtn, alphamat);
        if (istiquG)
            EditorGUI.DrawPreviewTexture(new Rect(985, 102, 25, 25), bantoumbtn, alphamat);
        if (istiquB)
            EditorGUI.DrawPreviewTexture(new Rect(1015, 102, 25, 25), bantoumbtn, alphamat);
        if (istiquA)
            EditorGUI.DrawPreviewTexture(new Rect(1045, 102, 25, 25), bantoumbtn, alphamat);


        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(917, 1150, 510, 625), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown&& sourceTex4!=null)
            {
                Save();
            }
        }
    }
    void Update()
    {
        time += 1;
        if (time > 6)
            time = 0;
        if(time == 6)//每6次update执行一次重绘GUI  约每秒40帧
        {
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
        }
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        caiFenMat0 = new Material(Shader.Find("ADYFX/Editer/FlattenTex_YuLan1"));
        caiFenMat1 = new Material(Shader.Find("ADYFX/Editer/FlattenTex_YuLan1"));
        caiFenMat2 = new Material(Shader.Find("ADYFX/Editer/FlattenTex_YuLan1"));
        caiFenMat3 = new Material(Shader.Find("ADYFX/Editer/FlattenTex_YuLan1"));
        caiFenMat0.SetVector("_TongDaoXuanZe",new Vector4(1,0,0,0));
        caiFenMat1.SetVector("_TongDaoXuanZe", new Vector4(0, 1, 0, 0));
        caiFenMat2.SetVector("_TongDaoXuanZe", new Vector4(0, 0, 1, 0));
        caiFenMat3.SetVector("_TongDaoXuanZe", new Vector4(0, 0, 0, 1));

        bantoumbtn = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/BanTouMing40.png");
        rgbaSelseR = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Rbtn.png");
        rgbaSelseG = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Gbtn.png");
        rgbaSelseB = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Bbtn.png");
        rgbaSelseA = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Abtn.png");
        boxbooltex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/boxtex.png");
        boxbooltex1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur04.png");
        BGtexture02 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/PinHeBG02.png");
        helptex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/wemhao_01.png");
        txglowtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/A_TEX_00308.png");
        txglowmasktex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Glow_001.tga");
        selsetex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/PinHeSeletex.png");
        btnhoverShader = Shader.Find("ADYFX/Editor/GlowPanner");
        btnhoverMat = new Material(btnhoverShader);
        btnhoverMat.SetVector("_MainTiling", new Vector4(1, 1, 0, 0));
        btnhoverMat.SetTexture("_MainTex", txglowtex);
        btnhoverMat.SetTexture("_MaskTex", txglowmasktex);
        btnhoverMat.SetInt("_Polar", 1);
        btnhoverMat.SetColor("_MainColor", new Color(1, 1, 1, 0.7f));
        btnhoverMat.SetVector("_MainPanner", new Vector4(0, -1, 1, 0));
        alphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
        addmat = new Material(Shader.Find("ADYFX/Editer/Add"));
        flattenTex_YuLanMat = new Material(Shader.Find("ADYFX/Editer/FlattenTex_YuLan"));
        toumingtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/TouMing.png");
        shurukuangstyle.normal.background = toumingtex;
        shurukuangstyle.fixedWidth = 144f;
        shurukuangstyle.fixedHeight = 32f;
        shurukuangstyle.normal.textColor = new Color(1, 1, 1, 1);
        shurukuangstyle.alignment = TextAnchor.MiddleLeft;//文本锚点
        shurukuangstyle.stretchWidth = true;
        shurukuangstyle.stretchHeight = true;
        shurukuangstyle.fontSize = 18;
    }

    void Save()
    {
        Color[] tempcolor0 = new Color[(int)resolution1.x * (int)resolution1.y];
        Color[] tempcolor1 = new Color[(int)resolution1.x * (int)resolution1.y];
        Color[] tempcolor2 = new Color[(int)resolution1.x * (int)resolution1.y];
        Color[] tempcolor3 = new Color[(int)resolution1.x * (int)resolution1.y];
        colorall1 = new Color[(int)resolution1.x * (int)resolution1.y];
        TextureFormat _texFormat;
        if (isAlpha1)
        {
            _texFormat = TextureFormat.ARGB32;
        }
        else
        {
            _texFormat = TextureFormat.RGB24;
        }
        Texture2D hh = new Texture2D((int)resolution1.x, (int)resolution1.y, TextureFormat.RGBA32, false);
        hh = ADYFX_Editor.GetTexColor_Texture2D(sourceTex4);
        hh.Apply();
        if (hh.width!= resolution1.x && hh.height != resolution1.y) 
        {
            hh = ADYFX_Editor.TextureScale(hh, (int)resolution1.x, (int)resolution1.y);
            hh.Apply();
        }
        colorall1 = hh.GetPixels();
        if (isMulAlpha)
        {
            for (int i = 0; i < (int)resolution1.x * (int)resolution1.y; i++)
            {
                tempcolor0[i].r = colorall1[i].r* colorall1[i].a;
                tempcolor0[i].g = colorall1[i].r * colorall1[i].a;
                tempcolor0[i].b = colorall1[i].r * colorall1[i].a;
                tempcolor0[i].a = colorall1[i].r * colorall1[i].a;

                tempcolor1[i].r = colorall1[i].g * colorall1[i].a;
                tempcolor1[i].g = colorall1[i].g * colorall1[i].a;
                tempcolor1[i].b = colorall1[i].g * colorall1[i].a;
                tempcolor1[i].a = colorall1[i].g * colorall1[i].a;

                tempcolor2[i].r = colorall1[i].b * colorall1[i].a;
                tempcolor2[i].g = colorall1[i].b * colorall1[i].a;
                tempcolor2[i].b = colorall1[i].b * colorall1[i].a;
                tempcolor2[i].a = colorall1[i].b * colorall1[i].a;

                tempcolor3[i].r = colorall1[i].a ;
                tempcolor3[i].g = colorall1[i].a ;
                tempcolor3[i].b = colorall1[i].a ;
                tempcolor3[i].a = colorall1[i].a;
            }
        }
        else 
        {
            for (int i = 0; i < (int)resolution1.x * (int)resolution1.y; i++)
            {
                tempcolor0[i].r = colorall1[i].r;
                tempcolor0[i].g = colorall1[i].r;
                tempcolor0[i].b = colorall1[i].r;
                tempcolor0[i].a = colorall1[i].r;

                tempcolor1[i].r = colorall1[i].g;
                tempcolor1[i].g = colorall1[i].g;
                tempcolor1[i].b = colorall1[i].g;
                tempcolor1[i].a = colorall1[i].g;

                tempcolor2[i].r = colorall1[i].b;
                tempcolor2[i].g = colorall1[i].b;
                tempcolor2[i].b = colorall1[i].b;
                tempcolor2[i].a = colorall1[i].b;

                tempcolor3[i].r = colorall1[i].a;
                tempcolor3[i].g = colorall1[i].a;
                tempcolor3[i].b = colorall1[i].a;
                tempcolor3[i].a = colorall1[i].a;
            }
        }

        Texture2D t00 = new Texture2D((int)resolution1.x, (int)resolution1.y, _texFormat, false);
        Texture2D t01 = new Texture2D((int)resolution1.x, (int)resolution1.y, _texFormat, false);
        Texture2D t02 = new Texture2D((int)resolution1.x, (int)resolution1.y, _texFormat, false);
        Texture2D t03 = new Texture2D((int)resolution1.x, (int)resolution1.y, _texFormat, false);
        t00.SetPixels(tempcolor0);
        t01.SetPixels(tempcolor1);
        t02.SetPixels(tempcolor2);
        t03.SetPixels(tempcolor3);
        string tempPath;
        if (istiquR)
        {
            t00.Apply();
            if (isrgba)
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t00, path, tex2dName, "_R_", 0, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            else 
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t00, path, tex2dName, "_CF_", 0, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            AssetDatabase.Refresh();//刷新资源库
            if (isAlpha1 && sourceTex4 != null&&iswaibu == false)
            {//如果保存的是带透明通道的PNG，则把贴图设置里的alpha选项打开
                tempPath = ADYFX_Editor.WinPathToAssetsPath(tempPath);
                //if (ADYFX_Editor.GetPath(sourceTex4) == ADYFX_Editor.AssetsToSystemPath() + "/" + "Assets/ADYFX/Elements/Temp")
                    ADYFX_Editor.SetTex2DisAlpha(tempPath);
            }
        }
        if (istiquG)
        {
            t01.Apply();
            if (isrgba)
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t01, path, tex2dName, "_G_", 0, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            else
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t01, path, tex2dName, "_CF_", 1, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            AssetDatabase.Refresh();//刷新资源库
            if (isAlpha1 && sourceTex4 != null && iswaibu == false)
            {//如果保存的是带透明通道的PNG，则把贴图设置里的alpha选项打开
                tempPath = ADYFX_Editor.WinPathToAssetsPath(tempPath);
                ADYFX_Editor.SetTex2DisAlpha(tempPath);
            }
        }
        if (istiquB)
        {
            t02.Apply();
            if (isrgba)
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t02, path, tex2dName, "_B_", 0, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            else
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t02, path, tex2dName, "_CF_", 2, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            AssetDatabase.Refresh();//刷新资源库
            if (isAlpha1 && sourceTex4 != null && iswaibu == false)
            {//如果保存的是带透明通道的PNG，则把贴图设置里的alpha选项打开
                tempPath = ADYFX_Editor.WinPathToAssetsPath(tempPath);
                ADYFX_Editor.SetTex2DisAlpha(tempPath);
            }
        }
        if (istiquA)
        {
            t03.Apply();
            if (isrgba)
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t03, path, tex2dName, "_A_", 0, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            else
            {
                tempPath = ADYFX_Editor.SaveTex_returnPath(t03, path, tex2dName, "_CF_", 3, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            }
            AssetDatabase.Refresh();//刷新资源库
            if (isAlpha1 && sourceTex4 != null && iswaibu == false)
            {//如果保存的是带透明通道的PNG，则把贴图设置里的alpha选项打开
                tempPath = ADYFX_Editor.WinPathToAssetsPath(tempPath);
                ADYFX_Editor.SetTex2DisAlpha(tempPath);

            }
        }
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法
        //根据当前原图是否在临时目录内 判断是否是外部图像，以进行保存时 开启alpha选项的判断
        if (sourceTex4 != null)
        {
        if ( ADYFX_Editor.GetPath(sourceTex4) ==  "Assets/ADYFX/Elements/Temp/"+ sourceTex4.name+".png"|| ADYFX_Editor.GetPath(sourceTex4) == "Assets/ADYFX/Elements/Temp/" + sourceTex4.name + ".tga"|| ADYFX_Editor.GetPath(sourceTex4) == "Assets/ADYFX/Elements/Temp/" + sourceTex4.name + ".jpg")
        {
            iswaibu = true;
        }
        else 
        {
            iswaibu = false;
        }
        }
            if (lowtexpath == ADYFX_Editor.GetPath(sourceTex4))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && sourceTex4 != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex4)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                tex1.alphaIsTransparency = false;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(sourceTex4));//应用设置 并刷新资源库
                isImporter = false;
            }
        }
        else
        {//资源变动时 记录当前图像设置 在下次换图的时候给它修改回去 
            if (lowtexpath != "")//上一个图像不是空的话 则改回旧图像原本的npotScale
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(lowtexpath) as TextureImporter;
                tex1.npotScale = lowTextureImporterNPOTScale;
                tex1.alphaIsTransparency = lowTextureImporterIsalpha;
                AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
            }
            //先记录新图像的导入设置  再开启isImporter 在下一针改变新贴图的npotScale为none以确保能获取正确的原图尺寸
            if (sourceTex4 != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex4)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowTextureImporterIsalpha = tex.alphaIsTransparency;
                lowtexpath = ADYFX_Editor.GetPath(sourceTex4);//low路径记录为当前路径
                isImporter = true;
            }
            else
            {
                lowtexpath = "";
            }
        }

        //正在处理外部图像判断.....................
    }
    private void OnDestroy()
    {//关闭当前窗口时  设置当前挂载的图像的导入设置为本身的设置
        if (sourceTex4)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex4)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
}
