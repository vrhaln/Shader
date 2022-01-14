using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ADYFX_FlattenTex :EditorWindow
{
    int time = 0;
    Color[] colorr;
    Color[] colorg;
    Color[] colorb;
    Color[] colora;
    Color[] colorall;
    float[] floatr;
    float[] floatg;
    float[] floatb;
    float[] floata;
    bool rmula = false;
    bool gmula = false;
    bool bmula = false;
    bool amula = false;
    public RGBASele rTongDao = RGBASele.此图取R通道;
    public RGBASele gTongDao = RGBASele.此图取R通道;
    public RGBASele bTongDao = RGBASele.此图取R通道;
    public RGBASele aTongDao = RGBASele.此图取R通道;
    public string path = ">>还未选择保存路径";
    public int serial = 1;
    public string tex2dName = "ADYFX_PinHe";
    public Texture2D toumingtex;
    //GUIStyle btnStyle01 = new GUIStyle();//新建按钮样式
    GUIStyle shurukuangstyle = new GUIStyle();
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    private Texture2D BGtexture01;
    public Texture2D helptex;
    public Material addmat;
    public Material alphamat;
    public Shader btnhoverShader;//绘制按钮悬停特效的shader
    public Material btnhoverMat;
    public Texture2D txglowtex;//帮助特效流光
    public Texture2D txglowmasktex;//帮助特效遮罩
    public Texture2D sourceTex0;
    public Texture2D sourceTex1;
    public Texture2D sourceTex2;
    public Texture2D sourceTex3;

    public Texture2D sourceTex4;
    RenderTexture rt;//绘制到RT
    RenderTexture rt1;
    RenderTexture rt2;
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
    public Vector2 resolution = new Vector2(512, 512);
    public Vector2 resolution1 = new Vector2(512, 512);
    bool isAlpha = false;
    bool isHeiBai = false;
    bool isQuSe = false;
    [MenuItem("ADYFX/贴图工具/※拼合贴图到通道", false, 102)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_FlattenTex window = EditorWindow.GetWindow<ADYFX_FlattenTex>();//定义窗口类
        window.minSize = new Vector2(1200, 650);//限制窗口最小值
        window.maxSize = new Vector2(1200, 650);//限制窗口最小值
        window.titleContent = new GUIContent("拼合贴图到通道");//标题内容
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
        if (isHeiBai)
        {
            isQuSe = true;
        }
        else 
        {
            isQuSe = false;
        }
        Sele01();
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
        GUI.Label(new Rect(550, 600, 300, 50), "Bilibili@ADY521");
    }
    private void Sele01()
    {
        if (BGtexture01 != null)//绘制背景图
        {
            EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1200, 650), BGtexture01);
        }
        if (Event.current.type == EventType.ExecuteCommand)//判断资源变动
        {
            Debug.Log("资源变动");
        }

        var options = new[] { GUILayout.Width(197), GUILayout.Height(117) };//定义一个tex2d的宽高
        GUILayout.Space(75);
        EditorGUILayout.BeginHorizontal();//开始水平布局
        GUILayout.Space(17);
        EditorGUILayout.BeginVertical();//开始垂直布局
        sourceTex0 = EditorGUILayout.ObjectField(sourceTex0, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        GUILayout.Space(30);
        sourceTex1 = EditorGUILayout.ObjectField(sourceTex1, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        GUILayout.Space(29);
        sourceTex2 = EditorGUILayout.ObjectField(sourceTex2, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        GUILayout.Space(25);
        sourceTex3 = EditorGUILayout.ObjectField(sourceTex3, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        EditorGUILayout.EndVertical();//结束垂直布局
        //temmp = EditorGUILayout.ObjectField(temmp, typeof(Texture), false, options) as Texture;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();//结束水平布局
        if (sourceTex0 != null)
        {
            flattenTex_YuLanMat.SetTexture("_Tex0", sourceTex0);
        }
        else
        {
            flattenTex_YuLanMat.SetTexture("_Tex0", null);
        }
        if (sourceTex1 != null)
        {
            flattenTex_YuLanMat.SetTexture("_Tex1", sourceTex1);
        }
        else
        {
            flattenTex_YuLanMat.SetTexture("_Tex1", null);
        }
        if (sourceTex2 != null)
        {
            flattenTex_YuLanMat.SetTexture("_Tex2", sourceTex2);
        }
        else
        {
            flattenTex_YuLanMat.SetTexture("_Tex2", null);
        }
        if (sourceTex3 != null)
        {
            flattenTex_YuLanMat.SetTexture("_Tex3", sourceTex3);
        }
        else
        {
            flattenTex_YuLanMat.SetTexture("_Tex3", null);
        }
        EditorGUI.DrawPreviewTexture(new Rect(313, 122, 514, 513), BGtexture01, flattenTex_YuLanMat);

        resolution = EditorGUI.Vector2Field(new Rect(890, 160, 250, 80), "", resolution);//输出图像尺寸
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1062, 1090, 194, 223), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1062, 194, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown&& sourceTex0!=null)
                resolution = new Vector2(sourceTex0.width, sourceTex0.height);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1095, 1124, 194, 225), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1095, 194, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex1 != null)
                resolution = new Vector2(sourceTex1.width, sourceTex1.height);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1129, 1157, 194, 225), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1129, 194, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex2 != null)
                resolution = new Vector2(sourceTex2.width, sourceTex2.height);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1160, 1191, 194, 225), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1160, 194, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex3 != null)
                resolution = new Vector2(sourceTex3.width, sourceTex3.height);
        }

        path = EditorGUI.TextField(new Rect(890, 259, 300, 20), "", path, shurukuangstyle);//路径选择模块
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1062, 1090, 305, 336), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1062, 305, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex0 != null)
                path = ADYFX_Editor.GetFullPath(sourceTex0);//获取源文件在系统中的完整路径
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1095, 1124, 305, 335), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1095, 305, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex1 != null)
                path = ADYFX_Editor.GetFullPath(sourceTex1);//获取源文件在系统中的完整路径
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1129, 1157, 305, 335), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1129, 305, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown&& sourceTex2!=null)
                path = ADYFX_Editor.GetFullPath(sourceTex2);//获取源文件在系统中的完整路径
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1160, 1191, 305, 335), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1160, 305, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex3 != null)
                path = ADYFX_Editor.GetFullPath(sourceTex3);//获取源文件在系统中的完整路径
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(881, 983, 304, 335), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(881, 304, 100, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown)
                path = ADYFX_Editor.GetSystemPath();
        }

        tex2dName = EditorGUI.TextField(new Rect(890, 355, 400, 20), "", tex2dName, shurukuangstyle);//名称选择模块
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1062, 1090, 401, 431), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1062, 401, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex0 != null)
            tex2dName = sourceTex0.name;
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1095, 1124, 401, 431), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1095, 401, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex1 != null)
            tex2dName = sourceTex1.name;
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1129, 1157, 401, 431), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1129, 401, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex2 != null)
            tex2dName = sourceTex2.name;
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1160, 1191, 401, 431), myMousePosition))//设置尺寸按钮 事件
        {
            EditorGUI.DrawPreviewTexture(new Rect(1160, 401, 30, 30), selsetex, addmat);
            if (Event.current.type == EventType.MouseDown && sourceTex3 != null)
            tex2dName = sourceTex3.name;
        }

        if (isAlpha) //alpha布尔值
        {
            EditorGUI.DrawPreviewTexture(new Rect(1095, 462, 13, 13), boxbooltex);//alpha布尔值
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(1090, 1200, 455, 490), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                isAlpha = !isAlpha;
            }
        }

        if (isHeiBai) //正常拼合、黑白输出
        {
            EditorGUI.DrawPreviewTexture(new Rect(963, 461, 18, 18), boxbooltex1, alphamat);
        }
        else 
        {
            EditorGUI.DrawPreviewTexture(new Rect(838, 461, 18, 18), boxbooltex1, alphamat);
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(831, 954, 455, 485), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown)
            {
                isHeiBai = false;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(955, 1080, 455, 485), myMousePosition))//设置尺寸按钮 事件
        {
            if (Event.current.type == EventType.MouseDown)
            {
                isHeiBai = true;
            }
        }
        //4个原图RGBA选择按钮
        EditorGUI.DrawPreviewTexture(new Rect(220, 75, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 105, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 135, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 165, 25, 25), rgbaSelseA, alphamat);
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 75, 105), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(1,0,0,0));
                rTongDao = RGBASele.此图取R通道;
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 105, 135), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                rTongDao = RGBASele.此图取G通道;
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 1, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 135, 165), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                rTongDao = RGBASele.此图取B通道;
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 0, 1, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 165, 195), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                rTongDao = RGBASele.此图取A通道;
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 0, 0, 1));
            }
        }
        if (rTongDao == RGBASele.此图取R通道) 
            EditorGUI.DrawPreviewTexture(new Rect(220, 75, 25, 25), bantoumbtn, alphamat);
        if (rTongDao == RGBASele.此图取G通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 105, 25, 25), bantoumbtn, alphamat);
        if (rTongDao == RGBASele.此图取B通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 135, 25, 25), bantoumbtn, alphamat);
        if (rTongDao == RGBASele.此图取A通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 165, 25, 25), bantoumbtn, alphamat);

        EditorGUI.DrawPreviewTexture(new Rect(220, 225, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 255, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 285, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 315, 25, 25), rgbaSelseA, alphamat);
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 225, 255), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                gTongDao = RGBASele.此图取R通道;
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(1, 0, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 255, 285), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                gTongDao = RGBASele.此图取G通道;
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 1, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 285, 315), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                gTongDao = RGBASele.此图取B通道;
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 0, 1, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 315, 345), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                gTongDao = RGBASele.此图取A通道;
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 0, 0, 1));
            }
        }
        if (gTongDao == RGBASele.此图取R通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 225, 25, 25), bantoumbtn, alphamat);
        if (gTongDao == RGBASele.此图取G通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 255, 25, 25), bantoumbtn, alphamat);
        if (gTongDao == RGBASele.此图取B通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 285, 25, 25), bantoumbtn, alphamat);
        if (gTongDao == RGBASele.此图取A通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 315, 25, 25), bantoumbtn, alphamat);

        EditorGUI.DrawPreviewTexture(new Rect(220, 373, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 403, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 433, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 463, 25, 25), rgbaSelseA, alphamat);
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 373, 403), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                bTongDao = RGBASele.此图取R通道;
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(1, 0, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 403, 433), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                bTongDao = RGBASele.此图取G通道;
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 1, 0,0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 433, 463), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                bTongDao = RGBASele.此图取B通道;
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 0, 1, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 463, 493), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                bTongDao = RGBASele.此图取A通道;
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 0, 0, 1));
            }
        }
        if (bTongDao == RGBASele.此图取R通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 373, 25, 25), bantoumbtn, alphamat);
        if (bTongDao == RGBASele.此图取G通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 403, 25, 25), bantoumbtn, alphamat);
        if (bTongDao == RGBASele.此图取B通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 433, 25, 25), bantoumbtn, alphamat);
        if (bTongDao == RGBASele.此图取A通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 463, 25, 25), bantoumbtn, alphamat);

        EditorGUI.DrawPreviewTexture(new Rect(220, 515, 25, 25), rgbaSelseR, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 545, 25, 25), rgbaSelseG, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 575, 25, 25), rgbaSelseB, alphamat);
        EditorGUI.DrawPreviewTexture(new Rect(220, 605, 25, 25), rgbaSelseA, alphamat);
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 515, 545), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown)
            {
                aTongDao = RGBASele.此图取R通道;
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(1, 0, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 545, 575), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown)
            {
                aTongDao = RGBASele.此图取G通道;
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 1, 0, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 575, 605), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown)
            {
                aTongDao = RGBASele.此图取B通道;
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 0, 1, 0));
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(220, 250, 605, 635), myMousePosition))
        {
            if (Event.current.type == EventType.MouseDown) 
            {
                aTongDao = RGBASele.此图取A通道;
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 0, 0, 1));
            }
        }
        if (aTongDao == RGBASele.此图取R通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 515, 25, 25), bantoumbtn, alphamat);
        if (aTongDao == RGBASele.此图取G通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 545, 25, 25), bantoumbtn, alphamat);
        if (aTongDao == RGBASele.此图取B通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 575, 25, 25), bantoumbtn, alphamat);
        if (aTongDao == RGBASele.此图取A通道)
            EditorGUI.DrawPreviewTexture(new Rect(220, 605, 25, 25), bantoumbtn, alphamat);

        rmula = GUI.Toggle(new Rect(250,140,60,25), rmula,"乘Alpha");
        gmula = GUI.Toggle(new Rect(250, 290, 60, 25), gmula, "乘Alpha");
        bmula = GUI.Toggle(new Rect(250, 441, 60, 25), bmula, "乘Alpha");
        amula = GUI.Toggle(new Rect(250, 580, 60, 25), amula, "乘Alpha");
        if (rmula)
        {
            flattenTex_YuLanMat.SetInt("_R_MulA", 1);
        }
        else 
        {
            flattenTex_YuLanMat.SetInt("_R_MulA", 0);
        }
        if (gmula)
        {
            flattenTex_YuLanMat.SetInt("_G_MulA", 1);
        }
        else
        {
            flattenTex_YuLanMat.SetInt("_G_MulA", 0);
        }
        if (bmula)
        {
            flattenTex_YuLanMat.SetInt("_B_MulA", 1);
        }
        else
        {
            flattenTex_YuLanMat.SetInt("_B_MulA", 0);
        }
        if (amula)
        {
            flattenTex_YuLanMat.SetInt("_A_MulA", 1);
        }
        else
        {
            flattenTex_YuLanMat.SetInt("_A_MulA", 0);
        }

        if (GUI.Button(new Rect(248, 165, 58, 25), "外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("PH_Temp0");
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
        if (GUI.Button(new Rect(248, 315, 58, 25), "外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("PH_Temp1");
            if (tempSystemTex != "")
            {
                sourceTex1 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        if (GUI.Button(new Rect(248, 465, 58, 25), "外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("PH_Temp2");
            if (tempSystemTex != "")
            {
                sourceTex2 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        if (GUI.Button(new Rect(248, 605, 58, 25), "外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("PH_Temp3");
            if (tempSystemTex != "")
            {
                sourceTex3 = ADYFX_Editor.GetTex2D(tempSystemTex);
                ADYFX_Editor.SetTexImport(tempSystemTex);
            }
            else
            {
                Debug.Log("没有正确的选择路径");
            }
        }
        if (ADYFX_Editor.IsShuBiaoPos(new Vector4(917, 1150, 510, 625), myMousePosition))//保存按钮
        {
            if (Event.current.type == EventType.MouseDown)
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
            SetYuLanTongDao();
        }
    }
    void SetYuLanTongDao()
    {
        if (flattenTex_YuLanMat != null)
        {
            if (rTongDao == RGBASele.此图取R通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(1, 0, 0, 0));
            }
            if (rTongDao == RGBASele.此图取G通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 1, 0, 0));
            }
            if (rTongDao == RGBASele.此图取B通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 0, 1, 0));
            }
            if (rTongDao == RGBASele.此图取A通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex0RGBA", new Vector4(0, 0, 0, 1));
            }

            if (gTongDao == RGBASele.此图取R通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(1, 0, 0, 0));
            }
            if (gTongDao == RGBASele.此图取G通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 1, 0, 0));
            }
            if (gTongDao == RGBASele.此图取B通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 0, 1, 0));
            }
            if (gTongDao == RGBASele.此图取A通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex1RGBA", new Vector4(0, 0, 0, 1));
            }

            if (bTongDao == RGBASele.此图取R通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(1, 0, 0, 0));
            }
            if (bTongDao == RGBASele.此图取G通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 1, 0, 0));
            }
            if (bTongDao == RGBASele.此图取B通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 0, 1, 0));
            }
            if (bTongDao == RGBASele.此图取A通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex2RGBA", new Vector4(0, 0, 0, 1));
            }

            if (aTongDao == RGBASele.此图取R通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(1, 0, 0, 0));
            }
            if (aTongDao == RGBASele.此图取G通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 1, 0, 0));
            }
            if (aTongDao == RGBASele.此图取B通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 0, 1, 0));
            }
            if (aTongDao == RGBASele.此图取A通道)
            {
                flattenTex_YuLanMat.SetVector("_Tex3RGBA", new Vector4(0, 0, 0, 1));
            }

        }
        if (isQuSe)
        {
            flattenTex_YuLanMat.SetFloat("_QuSe", 1);
        }
        else 
        {
            flattenTex_YuLanMat.SetFloat("_QuSe", 0);
        }
    }
    void StartWindow() //初始化窗口 获取所需资源
    {
        bantoumbtn = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/BanTouMing40.png");
        rgbaSelseR = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Rbtn.png");
        rgbaSelseG = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Gbtn.png");
        rgbaSelseB = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Bbtn.png");
        rgbaSelseA = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/Abtn.png");
        boxbooltex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/boxtex.png");
        boxbooltex1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/rotablur04.png");
        BGtexture01 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/PinHeBG01.png");
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
        FlattenImage();
        SaveGeshi gs = SaveGeshi.PNG;
        TextureFormat _texFormat;
        if (isAlpha)
        {
            if (sourceTex3)
            {
                _texFormat = TextureFormat.RGBA32;
            }
            else
            {
                _texFormat = TextureFormat.RGB24;
            }
        }
        else
        {
            _texFormat = TextureFormat.RGB24;
        }
        serial += 1;
        Texture2D texture2D = new Texture2D((int)resolution.x, (int)resolution.y, _texFormat, false);
        texture2D.SetPixels(colorall);//写入color[]到 像素数据 
        texture2D.Apply();
        string tempPath;
        if (sourceTex3 && isAlpha == true)
        {
            gs = SaveGeshi.TGA;
        }
        else
        {
            gs = SaveGeshi.PNG;
        }
        tempPath = ADYFX_Editor.SaveTex_returnPath(texture2D, path, tex2dName, "_PH_", serial, gs, new Color(1, 0.5f, 0.5f, 1), "已保存图像。 更多工具 B站@ ADY521");
        AssetDatabase.Refresh();//刷新资源库
        if (isAlpha && sourceTex3 != null)
        {//如果保存的是带透明通道的PNG，则把贴图设置里的alpha选项打开
            if (ADYFX_Editor.PathAssetsPanDuan(tempPath))
            {
                tempPath = ADYFX_Editor.WinPathToAssetsPath(tempPath);
                ADYFX_Editor.SetTex2DisAlpha(tempPath);
            }
        }
        if (!sourceTex3)
        {
            if (isAlpha)
                Debug.LogError("由于你没有放入A通道的图像却勾选了Alpha，自动为你修正保存内容为【无Alpha信息的PNG图像（24位）】");
        }
    }
    void FlattenImage()
    {
        colorr = new Color[(int)resolution.x * (int)resolution.y];
        colorg = new Color[(int)resolution.x * (int)resolution.y];
        colorb = new Color[(int)resolution.x * (int)resolution.y];
        colora = new Color[(int)resolution.x * (int)resolution.y];
        colorall = new Color[(int)resolution.x* (int)resolution.y];
        Vector4[] co = new Vector4[colorall.Length];
        Texture2D rrr = new Texture2D((int)resolution.x, (int)resolution.y,TextureFormat.RGBA32,false);
        Texture2D ggg = new Texture2D((int)resolution.x, (int)resolution.y, TextureFormat.RGBA32, false);
        Texture2D bbb = new Texture2D((int)resolution.x, (int)resolution.y, TextureFormat.RGBA32, false);
        Texture2D aaa = new Texture2D((int)resolution.x, (int)resolution.y, TextureFormat.RGBA32, false);
        //Setchicun();//设置图像尺寸
        //texAll = new Texture2D((int)resolution.x, (int)resolution.y);
        if (sourceTex0 != null)
        {
            rrr = ADYFX_Editor.GetTexColor_Texture2D(sourceTex0);
            rrr = ADYFX_Editor.TextureScale(rrr, resolution.x, resolution.y);
            colorr = rrr.GetPixels();
            int lan = rrr.GetPixels().Length;
            floatr = new float[rrr.GetPixels().Length];
            for ( int i = 0;i< lan;i++)
            {
                if (rTongDao == RGBASele.此图取R通道)
                {
                    if (rmula)
                    {
                        floatr[i] = colorr[i].r* colorr[i].a;
                    }
                    else 
                    {
                        floatr[i] = colorr[i].r;
                    }

                }
                if (rTongDao == RGBASele.此图取G通道)
                {
                    if (rmula)
                    {
                        floatr[i] = colorr[i].g * colorr[i].a;
                    }
                    else
                    {
                        floatr[i] = colorr[i].g;
                    }

                }
                if (rTongDao == RGBASele.此图取B通道)
                {
                    if (rmula)
                    {
                        floatr[i] = colorr[i].b * colorr[i].a;
                    }
                    else
                    {
                        floatr[i] = colorr[i].b;
                    }

                }
                if (rTongDao == RGBASele.此图取A通道)
                {
                    floatr[i] = colorr[i].a;
                }
            }
        }
        if (sourceTex1 != null)
        {
            ggg = ADYFX_Editor.GetTexColor_Texture2D(sourceTex1);
            ggg = ADYFX_Editor.TextureScale(ggg, resolution.x, resolution.y);
            colorg = ggg.GetPixels();
            int lan = ggg.GetPixels().Length;
            floatg = new float[ggg.GetPixels().Length];
            for (int i = 0; i < lan; i++)
            {
                if (gTongDao == RGBASele.此图取R通道)
                {
                    if (gmula)
                    {
                        floatg[i] = colorg[i].r * colorg[i].a;
                    }
                    else
                    {
                        floatg[i] = colorg[i].r;
                    }

                }
                if (gTongDao == RGBASele.此图取G通道)
                {
                    if (gmula)
                    {
                        floatg[i] = colorg[i].g* colorg[i].a;
                    }
                    else
                    {
                        floatg[i] = colorg[i].g;
                    }

                }
                if (gTongDao == RGBASele.此图取B通道)
                {
                    if (gmula)
                    {
                        floatg[i] = colorg[i].b * colorg[i].a;
                    }
                    else
                    {
                        floatg[i] = colorg[i].b;
                    }

                }
                if (gTongDao == RGBASele.此图取A通道)
                {
                    floatg[i] = colorg[i].a;
                }
            }
        }
        if (sourceTex2 != null)
        {
            bbb = ADYFX_Editor.GetTexColor_Texture2D(sourceTex2);
            bbb = ADYFX_Editor.TextureScale(bbb, resolution.x, resolution.y);
            colorb = bbb.GetPixels();
            int lan = bbb.GetPixels().Length;
            floatb = new float[bbb.GetPixels().Length];
            for (int i = 0; i < lan; i++)
            {
                if (bTongDao == RGBASele.此图取R通道)
                {
                    if (bmula)
                    {
                        floatb[i] = colorb[i].r * colorb[i].a;
                    }
                    else
                    {
                        floatb[i] = colorb[i].r;
                    }

                }
                if (bTongDao == RGBASele.此图取G通道)
                {
                    if (bmula)
                    {
                        floatb[i] = colorb[i].g * colorb[i].a;
                    }
                    else
                    {
                        floatb[i] = colorb[i].g;
                    }

                }
                if (bTongDao == RGBASele.此图取B通道)
                {
                    if (bmula)
                    {
                        floatb[i] = colorb[i].b * colorb[i].a;
                    }
                    else
                    {
                        floatb[i] = colorb[i].b;
                    }

                }
                if (bTongDao == RGBASele.此图取A通道)
                {
                    floatb[i] = colorb[i].a;
                }
            }
        }
        if (sourceTex3 != null)
        {
            aaa = ADYFX_Editor.GetTexColor_Texture2D(sourceTex3);
            aaa = ADYFX_Editor.TextureScale(aaa, resolution.x, resolution.y);
            colora = aaa.GetPixels();
            int lan = aaa.GetPixels().Length;
            floata = new float[aaa.GetPixels().Length];
            for (int i = 0; i < lan; i++)
            {
                if (aTongDao == RGBASele.此图取R通道)
                {
                    if (amula)
                    {
                        floata[i] = colora[i].r * colora[i].a;
                    }
                    else
                    {
                        floata[i] = colora[i].r;
                    }

                }
                if (aTongDao == RGBASele.此图取G通道)
                {
                    if (amula)
                    {
                        floata[i] = colora[i].g * colora[i].a;
                    }
                    else
                    {
                        floata[i] = colora[i].g;
                    }

                }
                if (aTongDao == RGBASele.此图取B通道)
                {
                    if (amula)
                    {
                        floata[i] = colora[i].b * colora[i].a;
                    }
                    else
                    {
                        floata[i] = colora[i].b;
                    }

                }
                if (aTongDao == RGBASele.此图取A通道)
                {
                    floata[i] = colora[i].a;
                }
            }
        }
        for (int j = 0; j < resolution.x * resolution.y; j++)
        {
            if (sourceTex0)
            {
                co[j].x = floatr[j];
            }
            else 
            {
                co[j].x = 0;
            }
            if (sourceTex1) 
            {
                co[j].y = floatg[j];
            }
            else
            {
                co[j].y = 0;
            }
            if (sourceTex2) 
            {
                co[j].z = floatb[j];
            }
            else
            {
                co[j].z = 0;
            }
            if (sourceTex3) 
            {
                co[j].w = floata[j];
            }
            else
            {
                co[j].w = 0;
            }
            colorall[j] = co[j];
        }

        //for (int i = 0; i < resolution.x * resolution.y; i++)
        //{
            
        //    for(int j = 0; j < resolution.x * resolution.y; j++)
        //    {
                
        //    }
        //    if (sourceTex0 != null)   //如果R图没挂上，颜色等于0
        //    {
        //        colorall[i].r = colorr[i].r;
        //        if (rTongDao == RGBASele.此图取R通道)
        //        {
        //            colorall[i].r = colorr[i].r;
        //        }
        //        if (rTongDao == RGBASele.此图取G通道)
        //        {
        //            colorall[i].r = colorr[i].g;
        //        }
        //        if (rTongDao == RGBASele.此图取B通道)
        //        {
        //            colorall[i].r = colorr[i].b;
        //        }
        //        if (rTongDao == RGBASele.此图取A通道)
        //        {
        //            colorall[i].r = colorr[i].a;
        //        }
        //        //R通道颜色取值
        //    }
        //    else
        //    {
        //        colorall[i].r = 0.0f;
        //    }

        //    if (sourceTex1 != null)
        //    {
        //        if (gTongDao == RGBASele.此图取R通道)
        //        {
        //            colorall[i].g = colorg[i].r;
        //        }
        //        if (gTongDao == RGBASele.此图取G通道)
        //        {
        //            colorall[i].g = colorg[i].g;
        //        }
        //        if (gTongDao == RGBASele.此图取B通道)
        //        {
        //            colorall[i].g = colorg[i].b;
        //        }
        //        if (gTongDao == RGBASele.此图取A通道)
        //        {
        //            colorall[i].g = colorg[i].a;
        //        }
        //        //G通道取值
        //    }
        //    else
        //    {
        //        colorall[i].g = 0.0f;
        //    }
        //    if (sourceTex2 != null)
        //    {
        //        if (bTongDao == RGBASele.此图取R通道)
        //        {
        //            colorall[i].b = colorb[i].r;
        //        }
        //        if (bTongDao == RGBASele.此图取G通道)
        //        {
        //            colorall[i].b = colorb[i].g;
        //        }
        //        if (bTongDao == RGBASele.此图取B通道)
        //        {
        //            colorall[i].b = colorb[i].b;
        //        }
        //        if (bTongDao == RGBASele.此图取A通道)
        //        {
        //            colorall[i].b = colorb[i].a;
        //        }
        //        //B通道取值
        //    }
        //    else
        //    {
        //        colorall[i].b = 0.0f;
        //    }
        //    if (sourceTex3 != null)
        //    {
        //        if (aTongDao == RGBASele.此图取R通道)
        //        {
        //            colorall[i].a = colora[i].r;
        //        }
        //        if (aTongDao == RGBASele.此图取G通道)
        //        {
        //            colorall[i].a = colora[i].g;
        //        }
        //        if (aTongDao == RGBASele.此图取B通道)
        //        {
        //            colorall[i].a = colora[i].b;
        //        }
        //        if (aTongDao == RGBASele.此图取A通道)
        //        {
        //            colorall[i].a = colora[i].a;
        //        }        //A通道取值
        //    }
        //    else
        //    {
        //        colorall[i].a = 0.0f;
        //    }

        //}
        if (isHeiBai == true)//如果要输出黑白图，取rgb的max
        {
            Color[] temp = colorall;
            List<float> tt = new List<float>();
            for (int j = 0; j < temp.Length; j++)
            {
                tt.Add(temp[j].r * 0.299f+ temp[j].g* 0.587f+temp[j].b* 0.114f);
                colorall[j].r = tt[j];
                colorall[j].g = tt[j];
                colorall[j].b = tt[j];
            }
        }
    }
    private void OnDestroy()
    {
        AssetDatabase.DeleteAsset("Assets/ADYFX/Elements/Temp");
    }
}
