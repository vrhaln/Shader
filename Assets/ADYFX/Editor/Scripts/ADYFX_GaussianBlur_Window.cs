using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEngine.Events;


public class ADYFX_GaussianBlur_Window : EditorWindow
{
    public float colorSpaceValue = 1;//定义一个色彩空间的值 当色彩空间是gamma时设置1 是线性的时候需要校正 则是0.45
    RenderTexture rt;//绘制到RT
    RenderTexture rt1;
    RenderTexture rt2;

    public Texture2D 窗口背景图;//ui背景图
    public string 窗口背景图路径 = "Assets/ADYFX/Elements/Tex/GSBlurBG_01.png";

    public Texture 原图;//原图
    public Texture 预览图;//预览图
    public Shader gsblur;
    public Material addmat;//保存时绘制到RT用ADD以保证RGB不和alpha相乘
    public Material alphamat;//预览时 绘制到RT用Alpha以保证RGB被alpha相乘 显示正常预览图

    public Shader 帮助按钮特效shader;//帮助按钮shader
    public Material 帮助按钮特效材质;//帮助按钮 材质

    Color[] colorall;//颜色数组
    public string tex2dName = "AFX_TexRadialBlur";//保存时的命名
    public string path = ">>还未选择保存路径";//保存路径
    public int serial = 0;//保存叠增序号
    public Vector2 resolution = new Vector2(512, 512);//保存的尺寸
    public float blurScale = 0.15f;//模糊程度
    public float blurw = 0.5f;//模糊轴心x
    public float blurh = 0.5f;//模糊轴心y

    public Texture2D btn01tex0 ;//按钮图待机
    public string btn01tex0path = "Assets/ADYFX/Elements/Tex/gsblurbtn01_01.png";
    public Texture2D btn01tex1;//按钮图悬停
    public string btn01tex1path = "Assets/ADYFX/Elements/Tex/gsblurbtn01_02.png";
    private Material btn01mat;
    Material wanggemat;
    public Texture2D btn02tex0;//按钮图待机
    public string btn02tex0path = "Assets/ADYFX/Elements/Tex/gsblurbtn02_01.png";
    public Texture2D btn02tex1;//按钮图悬停
    public string btn02tex1path = "Assets/ADYFX/Elements/Tex/gsblurbtn02_02.png";

    public Texture2D btn03tex0;//按钮图待机
    public string btn03tex0path = "Assets/ADYFX/Elements/Tex/gsblurbtn03_01.png";
    public Texture2D btn03tex1;//按钮图悬停
    public string btn03tex1path = "Assets/ADYFX/Elements/Tex/gsblurbtn03_02.png";

    public Texture2D btn04tex0;//按钮图待机
    public string btn04tex0path = "Assets/ADYFX/Elements/Tex/gsblurbtn04_01.png";
    public Texture2D btn04tex1;//按钮图悬停
    public string btn04tex1path = "Assets/ADYFX/Elements/Tex/gsblurbtn04_02.png";

    public Texture2D btnsavetex0;//按钮图待机
    public string btnsavetex0path = "Assets/ADYFX/Elements/Tex/gsblurbtnsave_01.png";
    public Texture2D btnsavetex1;//按钮图悬停
    public string btnsavetex1path = "Assets/ADYFX/Elements/Tex/gsblurbtnsave_02.png";

    public Texture2D btnoenpathtex0;//按钮图待机
    public string btnoenpathtex0path = "Assets/ADYFX/Elements/Tex/gsblurbtnopen_01.png";
    public Texture2D btnoenpathtex1;//按钮图悬停
    public string btnoenpathtex1path = "Assets/ADYFX/Elements/Tex/gsblurbtnopen_02.png";

    public Texture2D 特效遮罩图0;//特效噪波图
    public Texture2D 特效发光图0;//特效噪波图

    public Texture2D 特效遮罩图1;//背景菱格mask
    public string https = "";//传送网址
    public int 按钮文字默认大小 = 14;//按钮文字默认大小

    GUIStyle btnStyle01 = new GUIStyle();//新建按钮样式
    GUIStyle btnStyle02 = new GUIStyle();//新建按钮样式
    GUIStyle btnStyle03 = new GUIStyle();//新建按钮样式
    GUIStyle btnStyle04 = new GUIStyle();//新建按钮样式
    GUIStyle btnStyle05 = new GUIStyle();//新建按钮样式
    GUIStyle btnStyle06 = new GUIStyle();//新建按钮样式
    GUIStyle shurukuangstyle = new GUIStyle();
    GUIContent vector2gUIContent = new GUIContent();
    float time;
    private Vector2 myMousePosition = new Vector2(0,0);//鼠标在窗口的位置
    Vector4 shangxia = new Vector4(1, 0, -1, 0);//赋此值给shader内的偏移量
    Vector4 zuoyou = new Vector4(0, 1, 0, -1);
    public float blurwh = 0.5f;
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    [MenuItem("ADYFX/贴图滤镜/※高斯模糊", false, 103)]
    static void GaussianBlur_Window()//菜单窗口
    {
        ADYFX_GaussianBlur_Window window = EditorWindow.GetWindow<ADYFX_GaussianBlur_Window>();//定义窗口类
        window.minSize = new Vector2(1200, 650);//限制窗口最小值
        window.maxSize = new Vector2(1200, 650);//限制窗口最小值
        window.titleContent = new GUIContent("高斯模糊");//标题内容
        window.position = new Rect(200, 60, 1200, 650);
        window.Show();//创建窗口
        ADYFX_Editor.SetColorSpaceValue();
        Debug.Log("当前色彩空间为"+ PlayerSettings.colorSpace);
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        if ( gsblur == null)//获取shader
        {
            窗口背景图 = ADYFX_Editor.GetTex2D(窗口背景图路径);
            btn01tex0 = ADYFX_Editor.GetTex2D(btn01tex0path);
            btn01tex1 = ADYFX_Editor.GetTex2D(btn01tex1path);
            wanggemat = new Material(Shader.Find("ADYFX/Editer/PngWangGe"));
            btn02tex0 = ADYFX_Editor.GetTex2D(btn02tex0path);
            btn02tex1 = ADYFX_Editor.GetTex2D(btn02tex1path);

            btn03tex0 = ADYFX_Editor.GetTex2D(btn03tex0path);
            btn03tex1 = ADYFX_Editor.GetTex2D(btn03tex1path);

            btn04tex0 = ADYFX_Editor.GetTex2D(btn04tex0path);
            btn04tex1 = ADYFX_Editor.GetTex2D(btn04tex1path);

            btnsavetex0 = ADYFX_Editor.GetTex2D(btnsavetex0path);
            btnsavetex1 = ADYFX_Editor.GetTex2D(btnsavetex1path);

            btnoenpathtex0 = ADYFX_Editor.GetTex2D(btnoenpathtex0path);
            btnoenpathtex1 = ADYFX_Editor.GetTex2D(btnoenpathtex1path);

            特效遮罩图1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/mask_y010.png");
            gsblur = Shader.Find("ADYFX/Editer/GaussianBlur");
            Shader addhuizhi = Shader.Find("ADYFX/Editer/Add");
            Shader alphahuizhi = Shader.Find("ADYFX/Editer/Alpha");
            addmat = new Material(addhuizhi);
            alphamat = new Material(alphahuizhi);
            btn01mat = new Material(Shader.Find("ADYFX/Editer/BtnAlpha"));//这个材质是用于DrawPreviewTexture使用alpha时的色彩校正power (x,1/2.2)
            特效遮罩图0 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/mask_yuan01.png");
            特效发光图0 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/editorNoise01.png");
            帮助按钮特效shader = Shader.Find("ADYFX/Editor/GlowPanner");
            帮助按钮特效材质 = new Material(帮助按钮特效shader);
            帮助按钮特效材质.SetTexture("_MaskSclae", 特效遮罩图0);
            帮助按钮特效材质.SetColor("_MainColor",new Color(0.7f,0.6f,0.6f,1));
            帮助按钮特效材质.SetFloat("_MainScale",1f);
        }

        btnStyle01.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle01.fontSize = 按钮文字默认大小;//文字大小
        btnStyle01.normal.textColor = new Color(0,0,0,0);//文字颜色
        btnStyle01.normal.background = btn01tex0; //默认背景贴图
        btnStyle01.hover.background = btn01tex1;//悬停 图
        btnStyle01.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle01.active.background = btn01tex0;//点击 图
        btnStyle01.active.textColor = new Color(0, 0, 0, 0); 

        btnStyle02.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle02.fontSize = 按钮文字默认大小;//文字大小
        btnStyle02.normal.textColor = new Color(0, 0, 0, 0);//文字颜色
        btnStyle02.normal.background = btn02tex0; //默认背景贴图
        btnStyle02.hover.background = btn02tex1;//悬停 图
        btnStyle02.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle02.active.background = btn02tex0;//点击 图
        btnStyle02.active.textColor = new Color(0, 0, 0, 0);

        btnStyle03.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle03.fontSize = 按钮文字默认大小;//文字大小
        btnStyle03.normal.textColor = new Color(0, 0, 0, 0);//文字颜色
        btnStyle03.normal.background = btn03tex0; //默认背景贴图
        btnStyle03.hover.background = btn03tex1;//悬停 图
        btnStyle03.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle03.active.background = btn03tex0;//点击 图
        btnStyle03.active.textColor = new Color(0, 0, 0, 0);

        btnStyle04.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle04.fontSize = 按钮文字默认大小;//文字大小
        btnStyle04.normal.textColor = new Color(0, 0, 0, 0);//文字颜色
        btnStyle04.normal.background = btn04tex0; //默认背景贴图
        btnStyle04.hover.background = btn04tex1;//悬停 图
        btnStyle04.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle04.active.background = btn04tex0;//点击 图
        btnStyle04.active.textColor = new Color(0, 0, 0, 0);

        btnStyle05.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle05.fontSize = 按钮文字默认大小;//文字大小
        btnStyle05.normal.textColor = new Color(0, 0, 0, 0);//文字颜色
        btnStyle05.normal.background = btnsavetex0; //默认背景贴图
        btnStyle05.hover.background = btnsavetex1;//悬停 图
        btnStyle05.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle05.active.background = btnsavetex0;//点击 图
        btnStyle05.active.textColor = new Color(0, 0, 0, 0);

        btnStyle06.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle06.fontSize = 按钮文字默认大小;//文字大小
        btnStyle06.normal.textColor = new Color(0, 0, 0, 0);//文字颜色
        btnStyle06.normal.background = btnoenpathtex0; //默认背景贴图
        btnStyle06.hover.background = btnoenpathtex1;//悬停 图
        btnStyle06.hover.textColor = new Color(0, 0, 0, 0); //悬停 字
        btnStyle06.active.background = btnoenpathtex0;//点击 图
        btnStyle06.active.textColor = new Color(0, 0, 0, 0);


        //shurukuangstyle.normal.background = shurukuangTex;
        shurukuangstyle.fixedWidth = 144f;
        shurukuangstyle.fixedHeight = 32f;
        shurukuangstyle.normal.textColor = new Color(1,1,1,1);
        shurukuangstyle.alignment = TextAnchor.MiddleCenter;//文本锚点
        shurukuangstyle.stretchWidth = true;
        shurukuangstyle.stretchHeight = true;
        //vector2gUIContent.image = shurukuangTex;
        //vector2gUIContent.text = "ces";
        GSBlur();
    }
    void SetPath1()//※-选择保存路径-※"
    {
        path = ADYFX_Editor.GetSystemPath();
    }
    void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法

        if (lowtexpath == ADYFX_Editor.GetPath(原图))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && 原图 != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(原图)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(原图));//应用设置 并刷新资源库
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
            if (原图 != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(原图)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowtexpath = ADYFX_Editor.GetPath(原图);//low路径记录为当前路径
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
        if (原图)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(原图)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
    private void Update()
    {
        time += 1;
        if (time > 8)
            time = 0;
        if (time == 8)//每6次update执行一次重绘GUI  约每秒40帧 
        {
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
            if (原图 != null)
                GSBlur();
        }

    }
    private void OnGUI()
    {
        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}

        if (窗口背景图!= null)//绘制背景图
        {
            EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1200, 650), 窗口背景图);
        }
        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置

        ///因为此处还有叠加输入框 所以UI悬停的图用EditorGUI.DrawPreviewTexture来做
        if (myMousePosition.x > 950 && myMousePosition.x < 1080 && myMousePosition.y > 230 && myMousePosition.y < 285)
        {
            EditorGUI.DrawPreviewTexture(new Rect(720, 225, 365, 65), btn01tex1, btn01mat);
                if (Event.current.type == EventType.MouseDown)
                {
                    if (原图 != null)
                        resolution = new Vector2(原图.width, 原图.height);
                }
        }
        else
        {
            EditorGUI.DrawPreviewTexture(new Rect(720, 225, 365, 65), btn01tex0,btn01mat);//, alphamat, ScaleMode.StretchToFill
        }

        if (myMousePosition.x > 950 && myMousePosition.x < 1080 && myMousePosition.y > 290 && myMousePosition.y < 350)
        {
            EditorGUI.DrawPreviewTexture(new Rect(720, 288, 365, 65), btn02tex1, btn01mat);
            if (Event.current.type == EventType.MouseDown)
            {
                if (原图 != null)
                    tex2dName = 原图.name;
            }
        }
        else
        {
            EditorGUI.DrawPreviewTexture(new Rect(720, 288, 365, 65), btn02tex0, btn01mat);//, alphamat, ScaleMode.StretchToFill
        }

        if (GUI.Button(new Rect(720, 351, 365, 65), "设为原图路径", btnStyle03)) //设置原文件路径为路径
        {
            if (原图 != null)//按钮
            {
                path = ADYFX_Editor.GetFullPath(原图);//获取源文件在系统中的完整路径
                Debug.Log("你的保存路径为：" + path);//按钮
            }//按钮
        }

        if (GUI.Button(new Rect(720, 414, 365, 65), "选择新路径", btnStyle04)) //选择路径
        {
            SetPath1();
            Debug.Log("你的保存路径为：" + path);
        }

        if (GUI.Button(new Rect(718, 480, 178, 48), "保存", btnStyle05)) //保存按钮
        {
            if (原图 != null)
                GSBlurSave();
        }

        if (GUI.Button(new Rect(905, 480, 178, 48), "保存", btnStyle06)) //保存按钮
        {
            if (原图 != null&& path != "" && path != ">>还未选择保存路径")
                Application.OpenURL("file://" + path);
        }

        if (GUI.Button(new Rect(740, 126, 100, 25), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("GaussianBlur_Temp");
            if (tempSystemTex != "")
            {
                原图 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }

        var options1 = new[] {  GUILayout.Width(84), GUILayout.Height(22) };//定义一个tex2d的宽高
        GUILayout.Space(127);//旧版的空格，2018.3以下
        EditorGUILayout.BeginHorizontal();//      源图选择········
        GUILayout.Space(854);//旧版的空格，2018.3以下
        原图 = EditorGUILayout.ObjectField(原图, typeof(Texture), false, options1) as Texture;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(110);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();//   宽高尺寸设置·······
        GUILayout.Space(800);//旧版的空格，2018.3以下
        var optionsv2 = new[] { GUILayout.Width(150), GUILayout.Height(25) };//定义一个的宽高
        resolution = EditorGUILayout.Vector2Field(GUIContent.none, resolution, optionsv2);
       //float的一个办法 public static float FloatField(string label, float value, GUIStyle style, params GUILayoutOption[] options);
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(26);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();//   名字输入框设置·······
        GUILayout.Space(780);//旧版的空格，2018.3以下
        tex2dName = EditorGUILayout.TextField("", tex2dName, shurukuangstyle);//用户输入框
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(44);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();//   路径显示 01·······
        GUILayout.Space(795);//旧版的空格，2018.3以下
        var optionspath = new[] { GUILayout.Width(200), GUILayout.Height(25) };//定义一个的宽高
        EditorGUILayout.LabelField(path, optionspath);//文字显示路径，复用宽高V2的宽度现在
        var optionspath1 = new[] { GUILayout.Width(15), GUILayout.Height(25) };//定义一个的宽高
        GUILayout.Space(-5);//旧版的空格，2018.3以下
        EditorGUILayout.LabelField(".....", optionspath1);//文字显示路径，复用宽高V2的宽度现在
        EditorGUILayout.EndHorizontal();//结束水平布局
        GUILayout.Space(37);//旧版的空格，2018.3以下

        EditorGUILayout.BeginHorizontal();//   路径显示 02·······
        GUILayout.Space(795);//旧版的空格，2018.3以下
        EditorGUILayout.LabelField(path, optionspath);//文字显示路径，复用宽高V2的宽度现在
        GUILayout.Space(-5);//旧版的空格，2018.3以下
        EditorGUILayout.LabelField(".....", optionspath1);//文字显示路径，复用宽高V2的宽度现在
        EditorGUILayout.EndHorizontal();//结束水平布局

        if (原图 != null && 预览图 != null)
        {
            //预览图 渲染
            EditorGUI.DrawPreviewTexture(new Rect(338.8f, 174.5f, 344, 344), 预览图, wanggemat);//,alphamat, ScaleMode.StretchToFill
            EditorGUI.DrawPreviewTexture(new Rect(338.8f, 174.5f, 344, 344), 预览图, alphamat);//,alphamat, ScaleMode.StretchToFill
        }
        GUI.Label(new Rect(343, 495, 80, 25), "方向");
        blurScale = EditorGUI.Slider(new Rect(804, 204, 275, 20), blurScale, 0, 1f);
        blurwh = EditorGUI.Slider(new Rect(383, 500, 300, 20), blurwh, 0, 1);

        if (myMousePosition.x > 970 && myMousePosition.x < 1200 && myMousePosition.y > 120 && myMousePosition.y < 150)
        {//判断是否在帮助按钮下，如果在 就显示悬停特效
            if (Event.current.type == EventType.MouseDown)
            {
                Application.OpenURL("https://space.bilibili.com/7234711");
            }
            EditorGUI.DrawPreviewTexture(new Rect(971, 123, 125, 31), 特效发光图0, 帮助按钮特效材质, ScaleMode.StretchToFill);
        }
        GUI.Label(new Rect(755, 625, 500, 25), "因每个人工程的色彩空间不同 预览图可能有色差 放心保存   保存时会自动校正色彩");
    }
    void GSBlur()
    {
        if (原图 != null)
        {
            rt = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, 原图, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(gsblur);
            mat1.SetFloat("_BlurSpread", blurScale * 0.01f);
            mat1.SetVector("_offset1", new Vector4(1, 0, 0, 0));
            mat1.SetVector("_offset2", new Vector4(0, 1, 0, 0));
            //Material mat2;
            //mat2 = new Material(gsblur);
            //mat2.SetFloat("_BlurSpread", blurScale*0.01f);
            //mat2.SetVector("_offset1", new Vector4(1,0, 0, 0));
            //mat2.SetVector("_offset2", new Vector4(0, 1, 0, 0));
            Graphics.Blit(rt, rt1);
            float cishu = Mathf.Lerp(30, 150, blurScale);
            for (int i = 0; i < cishu; i++)//高斯模糊循环
            {
                //Graphics.Blit(rt1, rt2, mat1);
                //Graphics.Blit(rt2, rt1, mat2);
                float x1 = 0;
                float x2 = 0;
                float y1 = 0;
                float y2 = 0;
                x1 = Mathf.Lerp(shangxia.x, 0, blurwh) * 2;
                x2 = Mathf.Lerp(shangxia.z, 0, blurwh) * 2;
                y1 = Mathf.Lerp(0, zuoyou.y, blurwh) * 2;
                y2 = Mathf.Lerp(0, zuoyou.w, blurwh) * 2;
                mat1.SetVector("_offset1", new Vector2(x1, shangxia.y));//设置shader中的左右偏移方向
                mat1.SetVector("_offset2", new Vector2(x2, shangxia.w));
                Graphics.Blit(rt1, rt2, mat1);
                mat1.SetVector("_offset1", new Vector2(zuoyou.x, y1));//设置shader中的上下偏移方向
                mat1.SetVector("_offset2", new Vector2(zuoyou.z, y2));
                Graphics.Blit(rt2, rt1, mat1);
            }
            Graphics.Blit(rt1, rt);
            GL.PopMatrix();//GL.保存矩阵
            Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
            texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            texture2D.Apply();
            预览图 = texture2D;//预览
            RenderTexture.active = null;//RT置空
        }
    }

    void GSBlurSave()
    {
        if (原图 != null)
        {
            rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, 原图, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(gsblur);
            mat1.SetFloat("_BlurSpread", blurScale * 0.01f);
            mat1.SetVector("_offset1", new Vector4(1, 0, 0, 0));
            mat1.SetVector("_offset2", new Vector4(0, 1, 0, 0));
            Graphics.Blit(rt, rt1);
            float cishu = Mathf.Lerp(30, 150, blurScale);
            for (int i = 0; i < cishu; i++)//高斯模糊循环
            {
                float x1 = Mathf.Lerp(shangxia.x, 0, blurwh) * 2;
                float x2 = Mathf.Lerp(shangxia.z, 0, blurwh) * 2;
                float y1 = Mathf.Lerp(0, zuoyou.y, blurwh) * 2;
                float y2 = Mathf.Lerp(0, zuoyou.w, blurwh) * 2;
                mat1.SetVector("_offset1", new Vector2(x1, shangxia.y));//设置shader中的左右偏移方向
                mat1.SetVector("_offset2", new Vector2(x2, shangxia.w));
                Graphics.Blit(rt1, rt2, mat1);
                mat1.SetVector("_offset1", new Vector2(zuoyou.x, y1));//设置shader中的上下偏移方向
                mat1.SetVector("_offset2", new Vector2(zuoyou.z, y2));
                Graphics.Blit(rt2, rt1, mat1);
            }
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
            ADYFX_Editor.SaveTex(texture2D, path, tex2dName, "_GS", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            serial += 1;
            RenderTexture.active = null;//RT置空
        }
    }
}
