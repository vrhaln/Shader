using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEngine.Events;
public class ADYFX_RotateBlur : EditorWindow
{
    RenderTexture rt;//绘制到RT
    RenderTexture rt1;
    RenderTexture rt2;
    public Shader btnhoverShader;//绘制按钮悬停特效的shader
    public Material btnhoverMat;
    public Texture2D txglowtex;//帮助特效流光
    public Texture2D txglowmasktex;//帮助特效遮罩
    public Texture2D tex;
    public Material addmat;
    public Material alphamat;
    public Shader RotateBlur;
    public Texture sourceTex;
    Color[] colorall;
    public Texture2D bgtex;
    public Texture2D helptex;
    public Texture2D noneyulantex;
    public Texture2D noneyuantutex;
    public Texture2D silidertex;
    public Texture2D silidertex1;
    public Texture2D toumingtex;
    Texture2D btnmain;
    public Material btnalphamat;
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    private bool ispoint = false;//鼠标是在调整中心点
    public float XPoint = 0.5f;
    public float YPoint = 0.5f;
    public float blurScale = 0.05f;//模糊程度
    public Material btnlinggemat;
    public Vector2 resolution = new Vector2(512, 512);
    public string path = ">>还未选择保存路径";
    public string texname = "AFX_RotateBlur001";

    public int serial = 1;
    public string tex2dName = "ADYFX_RotateBlur";

    GUIStyle btnStyle01 = new GUIStyle();//新建按钮样式
    GUIStyle shurukuangstyle = new GUIStyle();
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    [MenuItem("ADYFX/贴图滤镜/※旋转模糊", false, 102)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_RotateBlur window = EditorWindow.GetWindow<ADYFX_RotateBlur>();//定义窗口类
        window.minSize = new Vector2(1200, 650);//限制窗口最小值
        window.maxSize = new Vector2(1200, 650);//限制窗口最小值
        window.titleContent = new GUIContent("旋转模糊");//标题内容
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
        float temp1 = blurScale;
        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}
        if (bgtex != null)//绘制背景图
        {
            EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1200, 650), bgtex);
        }
        var options = new[] { GUILayout.Width(185), GUILayout.Height(105) };//定义一个tex2d的宽高
        GUILayout.Space(20);
        EditorGUILayout.BeginHorizontal();//开始水平布局
        GUILayout.Space(715);
        sourceTex = EditorGUILayout.ObjectField(sourceTex, typeof(Texture), false, options) as Texture;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局

        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置
        if (myMousePosition.x > 139 && myMousePosition.x < 535 && myMousePosition.y > 174 && myMousePosition.y < 570)
        {//判断鼠标是否在调整中心点的区域内
            if (Event.current.type == EventType.MouseDrag) 
            {
                XPoint = Mathf.Lerp(0, 1, (myMousePosition.x - 139) / (535-139));
                YPoint = Mathf.Lerp(1, 0, (myMousePosition.y - 174) / (570-174));
                if (sourceTex != null)
                {
                    GSBlur();
                }
            }
        }
        blurScale = EditorGUI.Slider(new Rect(615, 539, 448, 20), blurScale, 0, 1);
        EditorGUI.DrawPreviewTexture(new Rect(611.5f, 530, 460, 35), silidertex1, btnalphamat);//个性化slider
        float sl = Mathf.Lerp(607,997, blurScale);
        EditorGUI.DrawPreviewTexture(new Rect(sl, 536, 24, 24), silidertex, btnalphamat);
        if (sourceTex == null)//如果没有选择贴图 绘制提示图
        {
            EditorGUI.DrawPreviewTexture(new Rect(715, 20, 187, 107), noneyuantutex, btnalphamat);
        }
        if (blurScale != temp1)//如果slier的值大于上一帧的值 则刷新预览
        {
            if (sourceTex != null)
            {
                GSBlur();
            }
        }

        GUI.Label(new Rect(738, 200, 150, 30), "设为原图名称+序号");
        GUI.Label(new Rect(755, 280, 150, 30), "设为原图尺寸");
        GUI.Label(new Rect(753, 360, 150, 30), "设为原图路径");
        GUI.Label(new Rect(875, 360, 150, 30), "选择系统路径");
        GUI.Label(new Rect(240, 540, 300, 50), "在预览视窗拖拽即可调整模糊中心点");
        GUI.Label(new Rect(1025, 586, 150, 40), "保存", btnStyle01);

        resolution = EditorGUI.Vector2Field(new Rect(745, 261, 300, 80), "", resolution);
        tex2dName = EditorGUI.TextField(new Rect(740, 174, 400, 20),"", tex2dName, shurukuangstyle);
        EditorGUI.TextField(new Rect(740, 334, 300, 20), "", path, shurukuangstyle);

        if (tex != null)
            EditorGUI.DrawPreviewTexture(new Rect(139, 174, 396, 396), tex);
        if (myMousePosition.x > 738 && myMousePosition.x < 838 && myMousePosition.y > 208 && myMousePosition.y < 238)
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                if (sourceTex != null)//写入名字
                    tex2dName = sourceTex.name;
            }
            EditorGUI.DrawPreviewTexture(new Rect(738, 205, 100, 20), btnmain, btnlinggemat);
        }
        if (myMousePosition.x > 738 && myMousePosition.x < 838 && myMousePosition.y > 287 && myMousePosition.y < 317)
        {
            if (Event.current.type == EventType.MouseDown ) 
            {
                if (sourceTex != null)//写入尺寸
                    resolution = new Vector2(sourceTex.width, sourceTex.height);
            }
            EditorGUI.DrawPreviewTexture(new Rect(740, 286, 100, 20), btnmain, btnlinggemat);
        }
        if ( myMousePosition.x > 738 && myMousePosition.x < 838 && myMousePosition.y > 368 && myMousePosition.y < 398)
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                if (sourceTex != null)//设置原文件路径为路径
                {
                    path = ADYFX_Editor.GetFullPath(sourceTex);//获取源文件在系统中的完整路径
                    Debug.Log("你的保存路径为：" + path);
                }//按钮
            }
            EditorGUI.DrawPreviewTexture(new Rect(739, 366, 100, 20), btnmain, btnlinggemat);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(860,960,368,398), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown ) 
            {
                if (sourceTex != null)
                {
                    path = ADYFX_Editor.GetSystemPath();
                    Debug.Log("你的保存路径为：" + path);
                }//按钮
            }
            EditorGUI.DrawPreviewTexture(new Rect(858, 366, 100, 20), btnmain, btnlinggemat);
        }

        if (GUI.Button(new Rect(716, 128, 183, 25), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("RotateBlur_Temp");
            if (tempSystemTex != "")
            {
                sourceTex = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }


        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1014, 1188, 581, 639), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                if (sourceTex != null)
                {
                    GSBlurSave();
                }//按钮
            }
            EditorGUI.DrawPreviewTexture(new Rect(1013, 580, 178, 60), btnmain, btnlinggemat);
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
                        Debug.Log("操作通过，为你添加拖拽的图片到待处理文件");
                        sourceTex = ADYFX_Editor.GetTex2D(DragAndDrop.paths[0]);
                        GSBlur();
                    }
                }
            }
        }
        //if (Event.current.type == EventType.ContextClick)
        //{
        //    Debug.LogError(EventType.ContextClick);//右键点击
        //}
        EditorGUI.DrawPreviewTexture(new Rect(1126, 15, 38, 38), helptex,alphamat);
        if (myMousePosition.x > 1100 && myMousePosition.x < 1200 && myMousePosition.y > 0 && myMousePosition.y < 64)
        {//判断是否在帮助按钮下，如果在 就显示悬停特效btnhoverMat
            EditorGUI.DrawPreviewTexture(new Rect(1055, -56, 180, 180), txglowtex, btnhoverMat, ScaleMode.StretchToFill);
            GUI.Label(new Rect(myMousePosition.x - 170, myMousePosition.y - 5, 150, 25), "点击获取更多工具和帮助");
            if (Event.current.type == EventType.MouseDown)
            {
                Application.OpenURL("https://space.bilibili.com/7234711");
            }
        }
        GUI.Label(new Rect(550, 610, 300, 50), "Bilibili@ADY521");
        GUI.Label(new Rect(710, -3, 500, 20), "因每个人工程的色彩空间不同 预览图可能有色差 放心保存   保存时会自动校正色彩");
    }
    void GSBlur()
    {
        if (sourceTex != null)
        {
            rt = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
                                                            //Graphics.DrawTexture(rect, sourceTex, alphamat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Graphics.DrawTexture(rect, sourceTex, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(RotateBlur);
            mat1.SetFloat("_XPoint", XPoint);
            mat1.SetFloat("_YPoint", YPoint);
            mat1.SetFloat("_Count", blurScale*628);
            Graphics.Blit(rt, rt1, mat1);
            //Graphics.Blit(rt1, rt2, mat1);
            //Graphics.Blit(rt2, rt);
            GL.PopMatrix();//GL.保存矩阵
            Texture2D texture2D = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
            texture2D.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            texture2D.Apply();
            tex = texture2D;//预览
            RenderTexture.active = null;//RT置空
        }
    }
    void GSBlurSave()
    {
        if (sourceTex != null)
        {
            rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt1 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            rt2 = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
            RenderTexture.active = rt;//RT运行
            GL.PushMatrix();//GL.获取矩阵
            GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
            Rect rect = new Rect(0, 0, rt.width, rt.height);//定义一个矩形  位置 宽高
            Graphics.DrawTexture(rect, sourceTex, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
            Material mat1;
            mat1 = new Material(RotateBlur);
            mat1.SetFloat("_XPoint", XPoint);
            mat1.SetFloat("_YPoint", YPoint);
            mat1.SetFloat("_Count", blurScale * 628);
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
            ADYFX_Editor.SaveTex(texture2D, path, tex2dName, "_RB_", serial, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
            serial += 1;
            RenderTexture.active = null;//RT置空
        }
    }
    void Update()
    {
        Repaint();//重绘GUI方法放在update里刷新，满帧跑
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        bgtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur01.png");
        noneyulantex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur02.png");
        noneyuantutex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur03.png");
        silidertex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur04.png");
        silidertex1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur05.png");
        toumingtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/TouMing.png");
        btnalphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
        helptex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/wemhao_01.png");
        RotateBlur = Shader.Find("ADYFX/Editer/TexRotateBlur");
        alphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
        btnlinggemat = new Material(Shader.Find("ADYFX/Editor/ZSLG"));
        btnmain = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/mask_y010.png");
        btnlinggemat.SetTexture("_MainTex", btnmain);
        btnlinggemat.SetVector("_NoiseTiling",new Vector4(4,1f,0,0));
        btnlinggemat.SetFloat("_AngleTimeScale",1f);
        btnlinggemat.SetVector("_Panner",new Vector4(1,1,1,0));
        btnlinggemat.SetColor("_MainColor", new Color(0.7f, 0.7f, 0.7f, 1));

        txglowtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/A_TEX_00308.png");
        txglowmasktex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Glow_001.tga");
        btnhoverShader = Shader.Find("ADYFX/Editor/GlowPanner");
        btnhoverMat = new Material(btnhoverShader);
        btnhoverMat.SetVector("_MainTiling", new Vector4(1, 1, 0, 0));
        btnhoverMat.SetTexture("_MainTex", txglowtex);
        btnhoverMat.SetTexture("_MaskTex", txglowmasktex);
        btnhoverMat.SetInt("_Polar", 1);
        btnhoverMat.SetColor("_MainColor", new Color(1, 1, 1, 0.7f));
        btnhoverMat.SetVector("_MainPanner", new Vector4(0, -1, 1, 0));

        btnStyle01.alignment = TextAnchor.MiddleCenter;//文本锚点
        btnStyle01.fontSize = 35;//文字大小
        btnStyle01.normal.textColor = new Color(1, 1, 1, 1);//文字颜色
        //btnStyle01.normal.background = btn01tex0; //默认背景贴图
        //btnStyle01.hover.background = btn01tex1;//悬停 图
        btnStyle01.hover.textColor = new Color(1, 1, 1, 1); //悬停 字
        //btnStyle01.active.background = btn01tex0;//点击 图
        btnStyle01.active.textColor = new Color(1, 1, 1, 1);

        shurukuangstyle.normal.background = toumingtex;
        shurukuangstyle.fixedWidth = 144f;
        shurukuangstyle.fixedHeight = 32f;
        shurukuangstyle.normal.textColor = new Color(1, 1, 1, 1);
        shurukuangstyle.alignment = TextAnchor.MiddleLeft;//文本锚点
        shurukuangstyle.stretchWidth = true;
        shurukuangstyle.stretchHeight = true;
        shurukuangstyle.fontSize = 18;
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法

        if (lowtexpath == ADYFX_Editor.GetPath(sourceTex))
        {//资源未变动时 什么都不做 如果是导入新资源了 则修改它为npotScale.None
            if (isImporter && sourceTex != null)
            {
                TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex)) as TextureImporter;
                tex1.npotScale = TextureImporterNPOTScale.None;
                AssetDatabase.ImportAsset(ADYFX_Editor.GetPath(sourceTex));//应用设置 并刷新资源库
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
            if (sourceTex != null)
            {
                TextureImporter tex = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex)) as TextureImporter;//low获取当前的贴图导入设置
                lowTextureImporterNPOTScale = tex.npotScale;
                lowtexpath = ADYFX_Editor.GetPath(sourceTex);//low路径记录为当前路径
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
        if (sourceTex)
        {
            TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(sourceTex)) as TextureImporter;
            tex1.npotScale = lowTextureImporterNPOTScale;
            AssetDatabase.ImportAsset(lowtexpath);//应用设置 并刷新资源库
        }
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
}
