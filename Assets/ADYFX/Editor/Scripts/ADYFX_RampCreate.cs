using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEditor.AnimatedValues;
using UnityEngine.Events;
//public enum Rampsource
//{
//    粒子系统ColorLifeTime = 0,
//    粒子系统Trail_ColorOverTrail = 1,
//    TrailRender = 2,
//    LineRender = 3,
//    使用新建渐变Gradient = 4,
//};
public class AFX_RampCreate : EditorWindow
{
    Color[] colorall;
    //public List<Color> colorall = new List<Color>();
    bool isAlpha;
    public string tex2dName = "ADYFX_Ramp";
    public Texture tex;
    public Gradient gradient = new Gradient();
    public ParticleSystem  particle ;
    public TrailRenderer trail;
    public LineRenderer line;
    //public Rampsource texrChannel = Rampsource.使用新建渐变Gradient;
    public string path = ">>还未选择保存路径";
    public string texname = "ADYFX_Ramp1";
    private int valueRampsource = 4;
    public int serial = 1;
    public Vector2 resolution = new Vector2(256, 8);
    public float[] gaodus;
    [MenuItem("ADYFX/贴图工具/※渐变图生成工具")]
    static void RampCreateWindow ()//菜单窗口
    {
        AFX_RampCreate window = EditorWindow.GetWindow<AFX_RampCreate>();//定义窗口类
        window.minSize = new Vector2(350, 600);//限制窗口最小值
        window.titleContent = new GUIContent("渐变图生成工具");//标题内容
        window.Show();//创建窗口
    }
    void SetPath1()//※-选择保存路径-※"
    {
        path = EditorUtility.OpenFolderPanel("", "", "");
    }
    //void TexrChannelSet(Rampsource texrChannel)//保存枚举选择
    //{
    //    switch (texrChannel)
    //    {
    //        case Rampsource.粒子系统ColorLifeTime:
    //            Debug.Log("选择使用粒子系统ColorLifeTime");
    //            valueRampsource = 0;
    //            break;
    //        case Rampsource.粒子系统Trail_ColorOverTrail:
    //            Debug.Log("选择使用粒子系统Trail_ColorOverTrail");
    //            valueRampsource = 1;
    //            break;
    //        case Rampsource.LineRender:
    //            Debug.Log("选择使用LineRender");
    //            valueRampsource = 3;
    //            break;
    //        case Rampsource.TrailRender:
    //            Debug.Log("选择使用TrailRender");
    //            valueRampsource = 2;
    //            break;
    //        case Rampsource.使用新建渐变Gradient:
    //            Debug.Log("选择使用新建渐变Gradient");
    //            valueRampsource = 4;
    //            break;
    //        default:
    //            Debug.LogError("Unrecognized Option");
    //            break;
    //    }
    //}
    private void OnGUI()
    {
        //EditorGUILayout.LabelField("选择从何处获取渐变Gradient");
        //texrChannel = (Rampsource)EditorGUILayout.EnumPopup("当前选择>>>", texrChannel);
        //if (GUILayout.Button("确认选择"))
        //{
        //    TexrChannelSet(texrChannel);
        //}
        EditorGUILayout.Space();//空格

        EditorGUILayout.LabelField("调一个渐变");//文字
        gradient = EditorGUILayout.GradientField("Gradient", gradient);//渐变条

        EditorGUILayout.BeginHorizontal();//开始一个水平布局，与EndHorizontal();之间插入一个模块，比如左边是一个文字，在文字右边加个Vector2
        EditorGUILayout.PrefixLabel("设置输出分辨率");
        resolution = EditorGUILayout.Vector2Field(GUIContent.none, resolution);
        EditorGUILayout.EndHorizontal();//结束水平布局
        if (GUILayout.Button("设为  256*8"))//按钮
            resolution = new Vector2(256, 8);
        if (GUILayout.Button("设为  512*8"))
            resolution = new Vector2(512, 8);
        EditorGUILayout.Space();
        isAlpha = EditorGUILayout.ToggleLeft("<<导出包含Alpha通道的贴图", isAlpha);//开关

        GUIStyle style = new GUIStyle("textfield");//用户输入框
        tex2dName = EditorGUILayout.TextField("输出文件命名：", tex2dName, style);//用户输入框

        EditorGUILayout.Space();
        //resolution = Handles.GetMainGameViewSize();
        EditorGUILayout.LabelField("当前保存路径为：");//文字
        EditorGUILayout.LabelField(path);//文字
        bool ispath = GUILayout.Button("--选择保存路径--");//按钮
        if (ispath)//按钮
        {
            SetPath1();
            Debug.Log("你的保存路径为："+ path);//按钮
        }//按钮

        bool shengcheng = GUILayout.Button("--生成渐变图--");//按钮
        if (shengcheng)
        {
            OutRampTex();//按钮
        }
        GUILayout.Space(20);
        EditorGUILayout.LabelField("---------------------------------------------------------");//文字
        if (GUILayout.Button("打开导出文件夹"))
        {
            Application.OpenURL("file://" + path);
        }
        GUILayout.Space(20);
        if (GUILayout.Button("查看使用教程（视频）"))
            Application.OpenURL("https://www.bilibili.com/video/BV1oi4y1u72z");
    }
    void OutRampTex()//输出
    {
        colorall = new Color[(int)(resolution.x* resolution.y)];//初始化颜色数组长度为出图宽高
        if (isAlpha == false)//如果选择不要a通道
        {
            gaodus = new float[(int)resolution.y];//获取图像高度，用一个数组装每排的起头序号
            gaodus[0] = 0;
            float gao = 0;//临时float 存储当前循环次数的记录，以此决定使用color【】的数组序号
            for (int g = 0; g < resolution.y; g++)//循环 写入高度记录的数组 
            {
                if (g == 0)
                {
                }
                else
                {
                    gao += resolution.x;//每次加宽度
                    gaodus[g] = gao;//这样高度的每个序号都是存储图像最左侧的像素编号 
                }
            }
            for (int a = 0; a < resolution.y; a++)//循环高度 次 
            {
                for (int c = 0; c < resolution.x; c++)//每次循环 循环一次宽度 写入横向渐变到当前排的每个像素 
                {
                    float temp = c / resolution.x;//当前循环的次数除以总次数 得到时间
                    colorall[(int)gaodus[a] + c] = gradient.Evaluate(temp);//时间作为渐变条的time 以获取正确的颜色
                }
            }
        }
        else
        {
            gaodus = new float[(int)resolution.y];
            gaodus[0] = 0;
            float gao = 0;
            for (int g = 0; g < resolution.y; g++)
            {
                if (g == 0)
                {
                }
                else
                {
                    gao += resolution.x;
                    gaodus[g] = gao;
                }
            }
            for (int a = 0; a < resolution.y; a++)
            {
                for (int c = 0; c < resolution.x; c++)
                {
                    float temp = c / resolution.x;
                    colorall[(int)gaodus[a] + c] = gradient.Evaluate(temp);
                    colorall[(int)gaodus[a] + c].a = gradient.Evaluate(temp).a;
                }
            }
        }
        Save(colorall);//调用保存方法，输入值填写 已经写好的color[]
        Debug.Log("Ramp图已生成,"+"名称："+ tex2dName+",保存路径："+ path);
    }
    void Save(Color[] colors)//写入像素数据并保存到指定绝对路径
    {
        TextureFormat _texFormat;//贴图设置
        if (isAlpha)
        {
            _texFormat = TextureFormat.ARGB32;//贴图设置32位 有A通道
        }
        else
        {
            _texFormat = TextureFormat.RGB24;//贴图设置24位 无A通道
        }
        Texture2D tex = new Texture2D((int)resolution.x, (int)resolution.y, _texFormat, false);//生命一个tex并设置宽高和图像有无A
        tex.SetPixels(colors);//写入color[]到 像素数据 
        tex.Apply();//应用写入
        byte[] bytes;//生命一个字节文件
        bytes = tex.EncodeToPNG();//tex的内容写入到字节文件 png格式
        //bytes = tex.EncodeToJPG();
        string sname = tex2dName + "_" + serial;//文件命名等于用户输入+下划线+每次增加的序号
        serial += 1;
            File.WriteAllBytes(path + "/" + sname + ".png", bytes);//保存
        AssetDatabase.Refresh();//刷新资源库
    }
}
