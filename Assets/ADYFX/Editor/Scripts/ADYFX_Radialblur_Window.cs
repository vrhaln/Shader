using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEngine.Events;

public class ADYFX_Radialblur_Window : EditorWindow
{
    RenderTexture rt;//绘制到RT
    RenderTexture rt1;
    RenderTexture rt2;
    public Texture2D guibgtex;//ui背景图
    public Texture yuanTex;//原图
    public Texture yulanTex;//预览图
    public Shader fsblur;//放射模糊shader
    public Material addmat;//保存时绘制到RT用ADD以保证RGB不和alpha相乘
    public Material alphamat;//预览时 绘制到RT用Alpha以保证RGB被alpha相乘 显示正常预览图
    private Material addmatGUIPoint;
    Color[] colorall;//颜色数组
    public string tex2dName = "AFX_TexRadialBlur";//保存时的命名
    public string path = ">>还未选择保存路径";//保存路径
    public int serial = 0;//保存叠增序号
    public Vector2 resolution = new Vector2(512, 512);//保存的尺寸
    public float blurScale = 0.15f;//模糊程度
    public float blurw = 0.5f;//模糊轴心x
    public float blurh = 0.5f;//模糊轴心y
    public Vector4 blurboxRect = new Vector4(0,0,200,200);//调整中心点的方框
    public string btnbg0 = "";//按钮图待机
    public string btnbg1 = "";//按钮图悬停
    public string btnbg2 = "";//按钮图点击
    public Texture2D btnbgtex0 ;//按钮图待机
    public Texture2D btnbgtex1 ;//按钮图悬停
    public Texture2D btnbgtex2 ;//按钮图点击
    public Texture2D yuantexbtnkuang;//源文件处 边框贴图
    public Texture2D btnsavetex;//保存按钮贴图
    public Texture2D btnsavetex01;//保存按钮贴图
    public Texture2D zhunxintex;//准心贴图
    public Texture2D TexselectionTishi;//提示放入源图图
    public Texture2D NoneyulanTex;//无预览时的图
    public Texture2D txglowtex;//帮助特效流光
    public Texture2D txglowmasktex;//帮助特效遮罩
    public Texture2D shurukuangTex;//输入框底图
    public Color btnTextColor0 = new Color(0.9f,0.9f,0.9f,1);//文字待机颜色
    public Color btnTextColor1 = new Color(1f, 1f, 1f, 1);//文字悬停颜色
    public Color btnTextColor2 = new Color(0.6f, 0.6f, 0.6f, 1);//文字点击颜色
    public string https = "";//传送网址
    private float MaskRange = 0f;//模糊遮罩的大小
    private float MaskPower = 0.2f;//模糊遮罩的power
    public Shader btnhoverShader;//绘制按钮悬停特效的shader
    public Material btnhoverMat;
    public int btntextScale = 14;//按钮文字默认大小
    GUIStyle BtnStyle = new GUIStyle();//新建按钮样式
    GUIStyle saveBtnStyle = new GUIStyle();//新建保存按钮样式
    GUIStyle shurukuangstyle = new GUIStyle();
    GUIContent vector2gUIContent = new GUIContent();
    private Vector2 myMousePosition = new Vector2(0,0);//鼠标在窗口的位置
    private Vector2 myPointpos;
    private float pointXrange = 0;//调整放射中心的X 框右侧减左侧的值的结果 存储在此
    private float pointYrange = 0;
    private bool ispoint = false;//鼠标是在调整中心点
    private bool issavebtn = false;
    private bool isbangzhubtn = false;
    float rotateadd = 0;
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
   [MenuItem("ADYFX/贴图滤镜/※放射模糊", false, 101)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_Radialblur_Window window = EditorWindow.GetWindow<ADYFX_Radialblur_Window>();//定义窗口类
        window.minSize = new Vector2(1024, 650);//限制窗口最小值
        window.maxSize = new Vector2(1024, 650);//限制窗口最小值
        window.titleContent = new GUIContent("放射模糊");//标题内容
        window.position = new Rect(450, 250, 1024, 650);
        window.Show();//创建窗口
        ADYFX_Editor.SetColorSpaceValue();
        Debug.Log("当前色彩空间为" + PlayerSettings.colorSpace);
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
            guibgtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/OnGuiBG_GSBlur.png");
            shurukuangTex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/OnGuiShuRu_Tex.png");
            btnbgtex0 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/btndaiji.png");
            btnbgtex1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/btnXuanTing.png");
            btnbgtex2 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/btndaiji.png");
            zhunxintex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rectui_zhunxin.png");
            TexselectionTishi = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/TexselectionTishi.png");
            NoneyulanTex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/NoneyulanTex.png");
        txglowtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/A_TEX_00308.png");
        txglowmasktex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Glow_001.tga");
            btnsavetex01 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/UIsavetex01.png");
            fsblur = Shader.Find("ADYFX/Editer/TexRadialBlur");
            addmat = new Material(Shader.Find("ADYFX/Editer/Add"));
            alphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
            addmatGUIPoint = new Material(Shader.Find("ADYFX/Editer/TexRadialBlur_Point"));
            addmatGUIPoint.SetColor("_PointColor", new Color(1,0,0,0.5f));
        btnhoverShader = Shader.Find("ADYFX/Editor/GlowPanner");
        btnhoverMat = new Material(btnhoverShader);
        btnhoverMat.SetVector("_MainTiling", new Vector4(1, 1, 0, 0));
        btnhoverMat.SetTexture("_MainTex", txglowtex);
        btnhoverMat.SetTexture("_MaskTex", txglowmasktex);
        btnhoverMat.SetInt("_Polar", 1);
        btnhoverMat.SetColor("_MainColor", new Color(1, 0, 0, 1));
        btnhoverMat.SetVector("_MainPanner", new Vector4(0, -1, 1, 0));
        btnsavetex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/UIsavetex.png");
        //初始化各种坐标范围
        pointXrange = 393 - 23;
        pointYrange = 552 - 182;
        myPointpos = new Vector2(211,378);

        BtnStyle.alignment = TextAnchor.MiddleCenter;//文本锚点
        BtnStyle.fontSize = btntextScale;//文字大小
        BtnStyle.normal.textColor = btnTextColor0;//文字颜色
        BtnStyle.normal.background = btnbgtex0; //默认背景贴图
        BtnStyle.hover.background = btnbgtex1;//悬停 图
        BtnStyle.hover.textColor = btnTextColor1;//悬停 字
        BtnStyle.active.background = btnbgtex2;//点击 图
        BtnStyle.active.textColor = btnTextColor2;

        saveBtnStyle.alignment = TextAnchor.MiddleCenter;//文本锚点
        saveBtnStyle.fontSize = 35;//文字大小
        saveBtnStyle.normal.textColor = btnTextColor0;//文字颜色
        saveBtnStyle.normal.background = btnsavetex; //默认背景贴图
        saveBtnStyle.hover.background = btnsavetex01;//悬停 图
        saveBtnStyle.hover.textColor = btnTextColor1;//悬停 字
        saveBtnStyle.active.background = btnsavetex;//点击 图
        saveBtnStyle.active.textColor = btnTextColor2;

        shurukuangstyle.normal.background = shurukuangTex;
        shurukuangstyle.fixedWidth = 144f;
        shurukuangstyle.fixedHeight = 32f;
        shurukuangstyle.normal.textColor = new Color(1,1,1,1);
        shurukuangstyle.alignment = TextAnchor.MiddleCenter;//文本锚点
        shurukuangstyle.stretchWidth = true;
        shurukuangstyle.stretchHeight = true;
        GSBlur();
    }
    void SetPath1()//※-选择保存路径-※"
    {
        path = EditorUtility.OpenFolderPanel("", "", "");
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        if (fsblur == null) 
        {
            StartWindow();//初始化窗口 获取所需资源
        }
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法
        
        //if (istempSystemTex)
        //{
        //    this.GetTempTex();
        //}
        if (lowtexpath == ADYFX_Editor.GetPath(yuanTex))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && yuanTex != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuanTex)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(yuanTex));//应用设置 并刷新资源库
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
            if (yuanTex != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuanTex)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowtexpath = ADYFX_Editor.GetPath(yuanTex);//low路径记录为当前路径
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
        if (yuanTex)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuanTex)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
            AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
    private void Update()
    {
        Repaint();//重绘GUI方法放在update里刷新，满帧跑
    }
    private void OnGUI()
    {
        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}
        //if (Event.current.type == EventType.ExecuteCommand)//判断资源变动
        //{


        //}
        if (guibgtex!= null)//绘制背景图
        {
            EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1024, 650), guibgtex);
        }
        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置
        if (myMousePosition.x > 23 && myMousePosition.x < 393 && myMousePosition.y > 182 && myMousePosition.y < 552) 
        {//判断鼠标是否在调整中心点的区域内
            //Debug.Log("鼠标悬停在调整中心的框内："+myMousePosition);
            ispoint = true;
        }
        else 
        {
            ispoint = false;
        }
        if (Event.current.type == EventType.MouseDrag && ispoint == true)
        {
            //Debug.Log("鼠标悬停在调整中心的框内：" + "正在拖动");
            blurw = (myMousePosition.x - 23) / pointXrange;
            blurh = (myMousePosition.y - 182) / pointYrange;
            myPointpos = myMousePosition;
            GSBlur();
        }


        float temp1 = blurScale;//存储上一帧的滑条数值
        float temp2 = blurw;
        float temp3 = blurh;
        float temp4 = MaskRange;
        float temp5 = MaskPower;

        var options1 = new[] {  GUILayout.Width(230), GUILayout.Height(64) };//定义一个tex2d的宽高
        GUILayout.Space(82);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();
        //EditorGUILayout.PrefixLabel(" ");
        GUILayout.Space(25);//旧版的空格，2018.3以下
        yuanTex = EditorGUILayout.ObjectField(yuanTex, typeof(Texture), false, options1) as Texture;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(35);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();
        GUILayout.Space(406);//旧版的空格，2018.3以下
        tex2dName = EditorGUILayout.TextField("", tex2dName, shurukuangstyle);//用户输入框
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(90);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();
        GUILayout.Space(411);//旧版的空格，2018.3以下
        var optionsv2 = new[] { GUILayout.Width(135), GUILayout.Height(25) };//定义一个的宽高
        resolution = EditorGUILayout.Vector2Field(GUIContent.none, resolution, optionsv2);
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(63);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();
        GUILayout.Space(406);//旧版的空格，2018.3以下
                             //path = EditorGUILayout.TextField("", path, shurukuangstyle, optionsv2);//用户输入框
        var optionspath = new[] { GUILayout.Width(115), GUILayout.Height(25) };//定义一个的宽高
        EditorGUILayout.LabelField(path, optionspath);//文字显示路径，复用宽高V2的宽度现在
        var optionspath1 = new[] { GUILayout.Width(15), GUILayout.Height(25) };//定义一个的宽高
        GUILayout.Space(-5);//旧版的空格，2018.3以下
        EditorGUILayout.LabelField(".....", optionspath1);//文字显示路径，复用宽高V2的宽度现在
        EditorGUILayout.EndHorizontal();//结束水平布局
        if (GUI.Button(new Rect(275, 84, 100, 33), "选择外部图片", BtnStyle)) //写入名字
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("Radialblur_Temp");
            if (tempSystemTex != "")
            {
                yuanTex = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else 
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        if (GUI.Button(new Rect(410, 224, 140, 33), "设为原名+序号", BtnStyle)) //写入名字
        {
            if (yuanTex != null)
                tex2dName = yuanTex.name;
        }

        if (GUI.Button(new Rect(410, 320, 140, 33), "设为原图尺寸", BtnStyle)) //写入尺寸
        {
            if (yuanTex != null)
                    resolution = new Vector2(yuanTex.width, yuanTex.height);
        }

        if (GUI.Button(new Rect(410, 463, 140, 33), "选择新路径", BtnStyle)) //选择路径
        {
            SetPath1();
            Debug.Log("你的保存路径为：" + path);
        }

        if (GUI.Button(new Rect(410, 420, 140, 33), "设为原图路径", BtnStyle)) //设置原文件路径为路径
        {
            if (yuanTex != null)//按钮
            {
                path= ADYFX_Editor.GetFullPath(yuanTex);//获取源文件在系统中的完整路径
                Debug.Log("你的保存路径为：" + path);//按钮
            }//按钮
        }

        if (GUI.Button(new Rect(411, 509, 143, 143), "保存", saveBtnStyle)) //保存按钮
        {
            if (yuanTex != null)
                GSBlurSave();
        }

        if (yuanTex == null)
        { //提示放源图、预览窗显示none提示图
            EditorGUI.DrawPreviewTexture(new Rect(120, 100, 120, 30), TexselectionTishi, alphamat, ScaleMode.StretchToFill);
            EditorGUI.DrawPreviewTexture(new Rect(595, 165, 400, 400), NoneyulanTex, alphamat, ScaleMode.StretchToFill);
        }
        //遮罩范围圈 渲染
        EditorGUI.DrawPreviewTexture(new Rect(23, 182, 370, 370), zhunxintex, addmatGUIPoint, ScaleMode.StretchToFill);
        EditorGUI.DrawPreviewTexture(new Rect(myPointpos.x - 16, myPointpos.y - 16, 32, 32), zhunxintex, alphamat, ScaleMode.StretchToFill);

        //if (myMousePosition.x > 411 && myMousePosition.x < 554 && myMousePosition.y > 509 && myMousePosition.y < 652)
        //{//判断是否在保存按钮下，如果在 就显示悬停特效
        //    EditorGUI.DrawPreviewTexture(new Rect(411, 509, 143, 143), fxnoisetex0, addfx01mat, ScaleMode.StretchToFill);
        //    EditorGUI.DrawPreviewTexture(new Rect(340, 436, 285, 285), fxglowtex0, addfx02mat, ScaleMode.StretchToFill);
        //}
        //EditorGUI.DrawPreviewTexture(new Rect(880, -47, 180, 180), bangzhuglowtex, bangzhufxmat, ScaleMode.StretchToFill);
        if (myMousePosition.x > 925 && myMousePosition.x < 1020 && myMousePosition.y > 0 && myMousePosition.y < 64)
        {//判断是否在帮助按钮下，如果在 就显示悬停特效btnhoverMat
            EditorGUI.DrawPreviewTexture(new Rect(868, -51, 180, 180), txglowtex, btnhoverMat, ScaleMode.StretchToFill);
            GUI.Label(new Rect(myMousePosition.x-170, myMousePosition.y-5, 150,25),"点击获取更多工具和帮助");
            if (Event.current.type == EventType.MouseDown)
            {
                Application.OpenURL("https://space.bilibili.com/7234711");
            }
        }
        MaskRange = EditorGUI.Slider(new Rect(70, 593, 320, 20), MaskRange, -1.5f, 5);
        MaskPower = EditorGUI.Slider(new Rect(70, 619, 320, 20), MaskPower, 0, 20);
        blurScale = EditorGUI.Slider(new Rect(568, 615, 430, 20), blurScale, 0, 1);
        if (yuanTex != null) 
        {
            if (MaskPower != temp5|| MaskRange != temp4|| blurh != temp3|| blurw != temp2|| blurScale != temp1) 
            {
                    GSBlur();
            }
        }
        if (yuanTex != null&&yulanTex != null)//预览图 渲染
            EditorGUI.DrawPreviewTexture(new Rect(568, 157.8f, 432, 432), yulanTex,alphamat);//,alphamat, ScaleMode.StretchToFill
        GUI.Label(new Rect(433, 95, 150, 25), "Bilibili@ADY521");
        GUI.Label(new Rect(500, 625, 500, 25), "因每个人工程的色彩空间不同 预览图可能有色差 放心保存   保存时会自动校正色彩");
    }
    void GSBlur()
    {
        if (yuanTex != null)
        {
            rt = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, yuanTex, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(fsblur);
            mat1.SetFloat("_BlurScale", 1);
            mat1.SetFloat("_XPoint", blurw);
            mat1.SetFloat("_YPoint", 1-blurh);
            mat1.SetFloat("_MaskRange", MaskRange);
            mat1.SetFloat("_MaskPower", MaskPower);
            addmatGUIPoint.SetFloat("_MaskRange", MaskRange);
            addmatGUIPoint.SetFloat("_MaskPower", MaskPower);
            addmatGUIPoint.SetFloat("_XPoint", blurw);
            addmatGUIPoint.SetFloat("_YPoint", 1-blurh);
            mat1.SetFloat("_Count", Mathf.Clamp(blurScale * 1000, 1, 1000));
            Graphics.Blit(rt, rt1, mat1);
            Graphics.Blit(rt1, rt);
            GL.PopMatrix();//GL.保存矩阵
            Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
            texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            texture2D.Apply();
            yulanTex = texture2D;//预览
            RenderTexture.active = null;//RT置空
        }
    }
    void GSBlurSave()
    {
        if (yuanTex != null)
        {
            rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, yuanTex, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(fsblur);
            mat1.SetFloat("_BlurScale", 1);
            mat1.SetFloat("_XPoint", blurw);
            mat1.SetFloat("_YPoint", 1 - blurh);
            mat1.SetFloat("_Count", Mathf.Clamp(blurScale * 500, 1, 1000));
            Graphics.Blit(rt, rt1, mat1);
            Graphics.Blit(rt1, rt);
            GL.PopMatrix();//GL.保存矩阵

            Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
            texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            texture2D.Apply();
            colorall = new Color[(int)(texture2D.width * texture2D.height)];//初始化颜色数组长度为出图宽高
            colorall = texture2D.GetPixels();

            if (PlayerSettings.colorSpace == ColorSpace.Linear) //判断色彩空间，如果是线性空间则校正色彩
            {
                for (int j = 0; j < colorall.Length; j++)
                {
                    colorall[j].r = Mathf.Pow(colorall[j].r, 1 / 2.2f);
                    colorall[j].g = Mathf.Pow(colorall[j].g, 1 / 2.2f);
                    colorall[j].b = Mathf.Pow(colorall[j].b, 1 / 2.2f);
                    //colorall[j].a = Mathf.Pow(colorall[j].a, 1 / 2.2f);
                }
            }
 
            texture2D.SetPixels(colorall);//写入color[]到 像素数据 
            texture2D.Apply();
            ADYFX_Editor.SaveTex(texture2D,path,tex2dName,"_FS", serial, SaveGeshi.PNG,new Color(1,0.5f,0.5f,1),"已保存图像。 更多工具 B站@ ADY521");
            serial += 1;
            RenderTexture.active = null;//RT置空
        }
    }
}
