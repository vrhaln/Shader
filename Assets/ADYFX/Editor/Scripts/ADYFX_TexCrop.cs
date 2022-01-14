using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
public class ADYFX_TexCrop : EditorWindow
{
    string lowtexpath = "";
    TextureImporterNPOTScale lowTextureImporterNPOTScale;
    bool isImporter = false;
    Vector2 lowpos;
    RenderTexture rt;
    string path = ">>还未选择路径";
    string name1 = "ADYFX_Tailor";
    Vector4 caijianquyu = new Vector4(0,0,0,0);
    Vector2 caiJianKuang0 = new Vector2(520,256);
    Vector2 caiJianKuang1 = new Vector2(1032, 256);
    Vector2 caiJianKuang2 = new Vector2(520,512 );
    Vector2 caiJianKuang3 = new Vector2(1032, 512);
    float uvscale = 1;
    Color[] colorall;
    bool iswinzhiding = true;
    bool iszuoshang = false;
    bool isyoushang = false;
    bool iszuoxia = false;
    bool isyouxia = false;
    bool istuozhaizhong = false;
    int suofangmoshi;
    Vector2 texbili = new Vector2(1,1);
    Rect yulanRect = new Rect(20,20,1600,900);
    //Vector4 caijiankuangRootRange = new Vector4(0,0,100,100);
    //Vector4 caijiankuang0Range = new Vector4(0, 0, 50, 50);
    //Vector4 caijiankuang1Range = new Vector4(0, 0, 50, 50);
    //Vector4 caijiankuang2Range = new Vector4(0, 0, 50, 50);
    //Vector4 caijiankuang3Range = new Vector4(0, 0, 50, 50);
    int serial;
    Material addmat;
    Material alphamat;
    Material yulanmat;
    Material wanggemat;
    float time;
    string yuantuname;
    public Texture2D bgtex;
    public Texture2D jiancaikuang0;
    public Texture2D jiancaikuang1;
    public Texture2D jiancaikuang2;
    public Texture2D jiancaikuang3;
    public Texture2D jiancaikuangline;
    private Texture2D touminggezi;
    private Vector2 resolution = new Vector2(256, 256);
    private Texture2D sourceTex0;
    private Vector2 myMousePosition = new Vector2(0, 0);//鼠标在窗口的位置
    [MenuItem("ADYFX/贴图工具/※剪裁贴图", false, 108)]
    static void RadialblurWindowcus()//菜单窗口
    {
        ADYFX_TexCrop window = EditorWindow.GetWindow<ADYFX_TexCrop>();//定义窗口类
        window.minSize = new Vector2(1800, 1000);//限制窗口最小值
        window.maxSize = new Vector2(1800, 1000);//限制窗口最小值
        window.titleContent = new GUIContent("剪裁贴图");//标题内容
        window.position = new Rect(20, 3, 1800, 1000);
        ADYFX_Editor.SetColorSpaceValue();
        window.Show();//创建窗口
    }
    private void OnGUI()
    {
        wantsMouseMove = true;
        wantsMouseEnterLeaveWindow = true;//开启这两项  鼠标进入、移出窗体  开启 才能接受判断
        if (bgtex) 
                EditorGUI.DrawPreviewTexture(new Rect(0, 0, 1800, 1000), bgtex);
        myMousePosition = Event.current.mousePosition;//获取鼠标在窗口中的位置
        GUILayout.Space(20);
        var options = new[] { GUILayout.Width(150), GUILayout.Height(70) };//定义一个tex2d的宽高
        EditorGUILayout.BeginHorizontal();//开始水平布局
        GUILayout.Space(1640);
        sourceTex0 = EditorGUILayout.ObjectField(sourceTex0, typeof(Texture), false, options) as Texture2D;//然后声明这个tex2d
        EditorGUILayout.EndHorizontal();
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
                    }
                }
            }
        }

        //if (Event.current.type == EventType.MouseDown)
        //{
        //    Debug.Log("鼠标按下" + Event.current.mousePosition);//鼠标按下
        //}
        if (Event.current.type == EventType.ExecuteCommand)//判断资源变动
        {
            uvscale = 1f;
            yulanmat.SetFloat("_UVScale", uvscale);
        }
        //重铺模式改变  当用户缩小贴图时 超界的像素 要么平铺 要么设为透明
        suofangmoshi = GUI.Toolbar(new Rect(1640, 145, 150, 20), suofangmoshi, new string[] { "继续重铺", "设为透明" });
        if (suofangmoshi == 0)
        {
            yulanmat.SetInt("_isJianCaiChaoJie", 0);
            EditorGUI.DrawPreviewTexture(yulanRect, touminggezi, wanggemat);
        }
        else
        {
            EditorGUI.DrawPreviewTexture(yulanRect, touminggezi, wanggemat);
            yulanmat.SetInt("_isJianCaiChaoJie", 1);
        }

        if (sourceTex0!=null)//判断资源变动  改变当前处理 文字
        {
            yuantuname = sourceTex0.name;
            if (ADYFX_Editor.Anjian(KeyCode.Space, 1)&&ADYFX_Editor.IsShuBiaoPos(new Vector4(0,1620,0,920),myMousePosition))
            {
                ADYFX_Editor.QuXiaoJujiao();//取消输入框的聚焦
            }
            if (ADYFX_Editor.Anjian(KeyCode.E, 0))//贴图缩放和偏移的快捷键控制部分
                {
                    uvscale -= 0.005f;
                    yulanmat.SetFloat("_UVScale", uvscale);
                }
                if (ADYFX_Editor.Anjian(KeyCode.Q, 0))
                {
                    uvscale += 0.005f;
                    yulanmat.SetFloat("_UVScale", uvscale);
                }
                if (ADYFX_Editor.Anjian(KeyCode.W, 0))
                {
                    yulanmat.SetFloat("_Yoffset", yulanmat.GetFloat("_Yoffset") - 1);
                }
                if (ADYFX_Editor.Anjian(KeyCode.S, 0))
                {
                    yulanmat.SetFloat("_Yoffset", yulanmat.GetFloat("_Yoffset") + 1);
                }
                if (ADYFX_Editor.Anjian(KeyCode.D, 0))
                {
                    yulanmat.SetFloat("_Xoffset", yulanmat.GetFloat("_Xoffset") - 1);
                }
                if (ADYFX_Editor.Anjian(KeyCode.A, 0))
                {
                    yulanmat.SetFloat("_Xoffset", yulanmat.GetFloat("_Xoffset") + 1);
                }

            if (sourceTex0.width == sourceTex0.height)//裁剪框渲染
            {
                yulanRect = new Rect(370, 20, 900, 900);
            }
            else if (sourceTex0.width > sourceTex0.height && ((float)sourceTex0.height / (float)sourceTex0.width) < 0.5625f)//宽屏显示预览
            {
                float aa = (float)sourceTex0.height / (float)sourceTex0.width;
                yulanRect = new Rect(20, 20 + (900 - (1600 * aa)) / 2, 1600, 1600 * aa);
            }
            else if (sourceTex0.width > sourceTex0.height && ((float)sourceTex0.height / (float)sourceTex0.width) >= 0.5625f)
            {
                float aa = (float)sourceTex0.width / (float)sourceTex0.height;
                yulanRect = new Rect(20 + ((1600 - (900 * aa)) / 2), 20, 900 * aa, 900);
            }
            else if (sourceTex0.width < sourceTex0.height)
            {
                float aa = (float)sourceTex0.width / (float)sourceTex0.height;
                yulanRect = new Rect(20 + ((1600 - (900 * aa)) / 2), 20, 900 * aa, 900);
            }
            EditorGUI.DrawPreviewTexture(yulanRect, sourceTex0, yulanmat);

            if (!istuozhaizhong)//判断是否在拖拽裁剪框  如果是 更改鼠标样式 并允许拖拽
            {
                if (ADYFX_Editor.IsShuBiaoPos(new Vector4(caiJianKuang0.x - 16, caiJianKuang0.x + 16, caiJianKuang0.y - 16, caiJianKuang0.y + 16), myMousePosition))
                {
                    EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1620, 920), MouseCursor.ResizeUpLeft);//鼠标呈左上 右下 拖拽外观
                    if (Event.current.type == EventType.MouseDown)
                    {
                        iszuoshang = true;
                        istuozhaizhong = true;
                    }
                }
                if (ADYFX_Editor.IsShuBiaoPos(new Vector4(caiJianKuang1.x - 16, caiJianKuang1.x + 16, caiJianKuang1.y - 16, caiJianKuang1.y + 16), myMousePosition))
                {
                    EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeUpRight);//鼠标呈右上 左下 拖拽外观
                    if (Event.current.type == EventType.MouseDown)
                    {
                        isyoushang = true;
                        istuozhaizhong = true;
                    }
                }
                if (ADYFX_Editor.IsShuBiaoPos(new Vector4(caiJianKuang2.x - 16, caiJianKuang2.x + 16, caiJianKuang2.y - 16, caiJianKuang2.y + 16), myMousePosition))
                {
                    EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeUpRight);//鼠标呈右上 左下 拖拽外观
                    if (Event.current.type == EventType.MouseDown)
                    {
                        iszuoxia = true;
                        istuozhaizhong = true;
                    }
                }
                if (ADYFX_Editor.IsShuBiaoPos(new Vector4(caiJianKuang3.x - 16, caiJianKuang3.x + 16, caiJianKuang3.y - 16, caiJianKuang3.y + 16), myMousePosition))
                {
                    EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1620, 920), MouseCursor.ResizeUpLeft);//鼠标呈左上 右下 拖拽外观
                    if (Event.current.type == EventType.MouseDown)
                    {
                        isyouxia = true;
                        istuozhaizhong = true;
                    }
                }
            }
            else
            {
                EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1620, 920), MouseCursor.MoveArrow);//鼠标呈移动外观
            }
            if (iszuoshang == true)//如果左上角拖拽中
            {
                caiJianKuang0 = myMousePosition;
                caiJianKuang0.x = Mathf.Clamp(caiJianKuang0.x, yulanRect.x, caiJianKuang3.x - 16);
                caiJianKuang0.y = Mathf.Clamp(caiJianKuang0.y, yulanRect.y, caiJianKuang3.y - 16);
                caiJianKuang1 = new Vector2(caiJianKuang3.x, caiJianKuang0.y);
                caiJianKuang2 = new Vector2(caiJianKuang0.x, caiJianKuang3.y);
            }
            if (isyoushang == true)//如果右上角拖拽中
            {
                caiJianKuang1 = myMousePosition;
                caiJianKuang1.x = Mathf.Clamp(caiJianKuang1.x, caiJianKuang0.x + 16, yulanRect.x + yulanRect.width - 16);
                caiJianKuang1.y = Mathf.Clamp(caiJianKuang1.y, yulanRect.y, caiJianKuang3.y - 16);
                caiJianKuang0 = new Vector2(caiJianKuang0.x, caiJianKuang1.y);
                caiJianKuang3 = new Vector2(caiJianKuang1.x, caiJianKuang3.y);
            }
            if (iszuoxia == true)//如果左下角拖拽中
            {
                caiJianKuang2 = myMousePosition;
                caiJianKuang2.x = Mathf.Clamp(caiJianKuang2.x, yulanRect.x, caiJianKuang3.x - 16);
                caiJianKuang2.y = Mathf.Clamp(caiJianKuang2.y, caiJianKuang0.y + 16, yulanRect.y + yulanRect.height - 16);
                caiJianKuang0 = new Vector2(caiJianKuang2.x, caiJianKuang0.y);
                caiJianKuang3 = new Vector2(caiJianKuang3.x, caiJianKuang2.y);
            }
            if (isyouxia == true)//如果右下角拖拽中
            {
                caiJianKuang3 = myMousePosition;
                caiJianKuang3.x = Mathf.Clamp(caiJianKuang3.x, caiJianKuang0.x + 16, yulanRect.x + yulanRect.width - 16);
                caiJianKuang3.y = Mathf.Clamp(caiJianKuang3.y, caiJianKuang0.y + 16, yulanRect.y + yulanRect.height - 16);
                caiJianKuang1 = new Vector2(caiJianKuang3.x, caiJianKuang1.y);
                caiJianKuang2 = new Vector2(caiJianKuang2.x, caiJianKuang3.y);
            }
            if (Event.current.type == EventType.MouseUp)//如果鼠标抬起  关闭所有拖拽操作
            {
                iszuoshang = false;
                isyoushang = false;
                iszuoxia = false;
                isyouxia = false;
                istuozhaizhong = false;
            }
            if (Event.current.type == EventType.MouseEnterWindow)//鼠标进窗体
            {
                if (iswinzhiding) 
                {
                    Focus();//获取焦点，使unity置顶(在其他窗口的前面)
                }
            }
            if (Event.current.type == EventType.MouseLeaveWindow)//鼠标出窗体  限制拖拽框的最大位置
            {
                if (iszuoshang == true)
                {
                    caiJianKuang0.x = Mathf.Clamp(caiJianKuang0.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                    caiJianKuang0.y = Mathf.Clamp(caiJianKuang0.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                }
                if (isyoushang == true)
                {
                    caiJianKuang1.x = Mathf.Clamp(caiJianKuang1.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                    caiJianKuang1.y = Mathf.Clamp(caiJianKuang1.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                }
                if (iszuoxia == true)
                {
                    caiJianKuang2.x = Mathf.Clamp(caiJianKuang2.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                    caiJianKuang2.y = Mathf.Clamp(caiJianKuang2.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                }
                if (isyouxia == true)
                {
                    caiJianKuang3.x = Mathf.Clamp(caiJianKuang3.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                    caiJianKuang3.y = Mathf.Clamp(caiJianKuang3.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                }
                iszuoshang = false;
                isyoushang = false;
                iszuoxia = false;
                isyouxia = false;
                istuozhaizhong = false;
            }
            //裁剪框 渲染
            GUI.Label(new Rect(caiJianKuang0.x, caiJianKuang0.y - 23, 300, 20), "裁剪区域 ··· 最终输出即是框内看到的部分");
            EditorGUI.DrawPreviewTexture(new Rect(caiJianKuang0.x, caiJianKuang0.y, (caiJianKuang3.x - caiJianKuang0.x) + 16, (caiJianKuang3.y - caiJianKuang0.y) + 16), jiancaikuangline, alphamat);
            EditorGUI.DrawPreviewTexture(new Rect(caiJianKuang0.x, caiJianKuang0.y, 16, 16), jiancaikuang0, addmat);
            EditorGUI.DrawPreviewTexture(new Rect(caiJianKuang1.x, caiJianKuang1.y, 16, 16), jiancaikuang1, addmat);
            EditorGUI.DrawPreviewTexture(new Rect(caiJianKuang2.x, caiJianKuang2.y, 16, 16), jiancaikuang2, addmat);
            EditorGUI.DrawPreviewTexture(new Rect(caiJianKuang3.x, caiJianKuang3.y, 16, 16), jiancaikuang3, addmat);
            GUI.Label(new Rect(caiJianKuang0.x, caiJianKuang0.y - 23, 300, 20), "裁剪区域 ··· 最终输出即是框内看到的部分");
            GUI.Label(new Rect(caiJianKuang0.x, caiJianKuang0.y - 40, 300, 20), uvscale.ToString());
        }
        else //如果没有放入图片
        {
            yuantuname = "（空）";
        }

        if (GUI.Button(new Rect(1640, 95, 150, 20), "选择外部图片")) //保存按钮
        {
            string tempSystemTex = ADYFX_Editor.ImportSystemTex("cfxl_Temp");
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
        GUI.Label(new Rect(1690, 0, 50, 20), "源图");
        if (sourceTex0)
        {
            GUI.Label(new Rect(5, 0, 1200, 20), "当前处理：" + yuantuname + "      " + sourceTex0.width + "*" + sourceTex0.height);
        }
        else
        {
            GUI.Label(new Rect(5, 0, 1200, 20), "当前处理：");
        }
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.MoveArrow);//鼠标呈移动外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.Link);//鼠标呈小手外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.Orbit);//鼠标呈眼睛外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.Pan);//鼠标呈张开的小手外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeHorizontal);//鼠标呈左右拖拽的外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeUpRight);//鼠标呈右上 左下 拖拽外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeUpLeft);//鼠标呈左上 右下 拖拽外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.ResizeVertical);//鼠标呈垂直拖拽的外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.RotateArrow);//鼠标呈旋转外观
        //EditorGUIUtility.AddCursorRect(new Rect(20, 20, 1600, 900), MouseCursor.SlideArrow);//鼠标呈滑条的外观

        resolution = EditorGUI.Vector2Field(new Rect(1640, 200, 150, 40), "出图宽高", resolution);
        caijianquyu = new Vector4(caiJianKuang0.x - yulanRect.x, yulanRect.y - caiJianKuang0.y, caiJianKuang3.x - caiJianKuang0.x + 16, caiJianKuang3.y - caiJianKuang1.y + 16);
        caijianquyu.x = caijianquyu.x / yulanRect.width;
        caijianquyu.y = -(caijianquyu.y / yulanRect.height);
        caijianquyu.z = caijianquyu.z / yulanRect.width;
        caijianquyu.w = caijianquyu.w / yulanRect.height;
        //caijianquyu = EditorGUI.Vector4Field(new Rect(920, 950, 500, 35), "裁剪区域", caijianquyu);
        GUI.Label(new Rect(930, 941, 1000, 30), "裁剪区域：  XPoint  " + caijianquyu.x + "  YPoint  " + caijianquyu.y + "   宽" + caijianquyu.z + "   高" + caijianquyu.w);
        if (GUI.Button(new Rect(1640, 245, 120, 25), "自动计算"))
        {
            if (sourceTex0)
            {
                float uu = (sourceTex0.width * uvscale) * caijianquyu.z;
                float vv = (sourceTex0.height * uvscale) * caijianquyu.w;
                uu = (int)uu;
                vv = (int)vv;
                resolution = new Vector2(uu, vv);
            }
        }

        GUI.Label(new Rect(1640, 270, 100, 20), "命名");
        name1 = GUI.TextField(new Rect(1640, 290, 150, 20), name1);


        if (GUI.Button(new Rect(1640, 315, 120, 25), "设为原图命名+序号"))
        {
            if (sourceTex0)
                name1 = sourceTex0.name + "_SplitSequence";
        }
        GUI.Label(new Rect(1640, 345, 70, 30), "当前路径");
        GUI.Label(new Rect(1640, 380, 400, 30), path);

        if (GUI.Button(new Rect(1640, 415, 120, 30), "选择路径"))
        {
            path = ADYFX_Editor.GetSystemPath();
        }
        if (GUI.Button(new Rect(1640, 447, 120, 30), "设为原图路径"))
        {
            path = ADYFX_Editor.GetFullPath(sourceTex0);
        }
        if (GUI.Button(new Rect(1640, 480, 120, 50), "保存"))
        {
            if (sourceTex0)
                Save();
        }
        GUI.Label(new Rect(930, 925, 100, 25), "图像缩放： ");
        GUI.Label(new Rect(1640, 165, 400, 20), "※重铺逻辑取决于贴图设置");
        uvscale = EditorGUI.Slider(new Rect(1000, 930, 500, 25), uvscale, 0, 10);
        GUI.Label(new Rect(1635, 120, 400, 20), "← 若图像缩小至小于原尺寸");
        GUI.Label(new Rect(20, 925, 1500, 20), "鼠标在图像区域内： 按住 Q 键   缩小图像          按住 E 键   放大图像            ！！当你正在操作某个输入框时 你应该在画布上按空格键以取消所有输入状态 才能使快捷键生效");
        GUI.Label(new Rect(20, 945, 400, 20), "鼠标在图像区域内： 按住方向键 W A S D 以移动图像 ");
        iswinzhiding = GUI.Toggle(new Rect(20, 965, 50, 20), iswinzhiding, "");
        GUI.Label(new Rect(40, 965, 1200, 20), "提高窗口优先级  （当放入原图后 Unity和本窗口优先级最高   鼠标进入窗口时 自动选中窗口并置顶Unity   你可以关闭这个勾以取消此功能 但你在按快捷键前 记得鼠标点击窗口任意位置以聚焦窗口）");
        GUI.Label(new Rect(1650, 980, 150, 30), "bilibili@ADY521");
    }
        void OnFocus()//当窗口获得焦点时调用一次
    {
        StartWindow();//初始化窗口 获取所需资源
    }
    void Update()
    {
        time += 1;
        if (time > 2)
            time = 0;
        if (time == 2)//每6次update执行一次重绘GUI  约每秒40帧 
        {
            Repaint();//重绘GUI方法放在update里刷新，满帧跑
        }
        if (sourceTex0) 
        {
            uvscale = Mathf.Max(uvscale,0);
            yulanmat.SetFloat("_UVScale", uvscale);
        }
    }
    void Save()
    {
        if (sourceTex0 != null)
        {
            //设置UV缩放  匹配上操作界面的裁剪框
            yulanmat.SetFloat("_UVScale_Save_X", caijianquyu.z);
            yulanmat.SetFloat("_UVScale_Save_Y", caijianquyu.w);
            yulanmat.SetFloat("_Xoffset_Save", caijianquyu.x);
            yulanmat.SetFloat("_Yoffset_Save", caijianquyu.y);
            yulanmat.SetInt("_isSave",1);
            rt = new RenderTexture((int)resolution.x, (int)resolution.y, 0, RenderTextureFormat.ARGBFloat);
                RenderTexture.active = rt;//RT运行
                GL.PushMatrix();//GL.获取矩阵
                GL.LoadPixelMatrix(0, rt.width, rt.height, 0);//GL.设置像素参数
                                                              //Graphics.DrawTexture(rect, yuantu, addmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
                Graphics.DrawTexture(new Rect(0, 0, rt.width, rt.height), sourceTex0, yulanmat);//渲染.绘制tex，参数传入矩形和要绘制进去的贴图
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
            yulanmat.SetFloat("_UVScale_Save_X",1 );
            yulanmat.SetFloat("_UVScale_Save_Y", 1);
            yulanmat.SetFloat("_Xoffset_Save", 0);
            yulanmat.SetFloat("_Yoffset_Save",0 );
            yulanmat.SetInt("_isSave", 0);
            //serial = 0;
        }
    }
    void StartWindow()
    {
        touminggezi = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/toumingquyuGezi.png");
        wanggemat = new Material(Shader.Find("ADYFX/Editer/PngWangGe"));
        //wanggemat.SetTexture("_MainTex", touminggezi);
        if (yulanmat == null)
        {
            yulanmat = new Material(Shader.Find("ADYFX/Editer/JianCai_YuLan"));
        }
        addmat = new Material(Shader.Find("ADYFX/Editer/Add"));
        alphamat = new Material(Shader.Find("ADYFX/Editer/Alpha"));
        bgtex = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/JianCaiBG.png");
        jiancaikuang0 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/caijian_jiao_0.png");
        jiancaikuang1 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/caijian_jiao_1.png");
        jiancaikuang2 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/caijian_jiao_3.png");
        jiancaikuang3 = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/caijian_jiao_2.png");
        jiancaikuangline = ADYFX_Editor.GetTex2D("Assets/ADYFX/Elements/Tex/BanTouMing40.png");
    }
    void OnInspectorUpdate()//window强制20帧刷新率，此函数内的为10帧刷新率
    {
        //Repaint();//unity的刷新Window方法
        if (sourceTex0)//每帧限制裁剪框范围 防止超界
        {
                caiJianKuang0.x = Mathf.Clamp(caiJianKuang0.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                caiJianKuang0.y = Mathf.Clamp(caiJianKuang0.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                caiJianKuang1.x = Mathf.Clamp(caiJianKuang1.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                caiJianKuang1.y = Mathf.Clamp(caiJianKuang1.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                caiJianKuang2.x = Mathf.Clamp(caiJianKuang2.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                caiJianKuang2.y = Mathf.Clamp(caiJianKuang2.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
                caiJianKuang3.x = Mathf.Clamp(caiJianKuang3.x, yulanRect.x, yulanRect.x + yulanRect.width - 16);
                caiJianKuang3.y = Mathf.Clamp(caiJianKuang3.y, yulanRect.y, yulanRect.y + yulanRect.height - 16);
        }
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
