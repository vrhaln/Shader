using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using UnityEditor.AnimatedValues;
using UnityEngine.Events;

public class ADYFX_UnMult : Editor
{
    [MenuItem("Assets/ADYFX_贴图工具箱/一键加黑底_新增", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool Heidibool()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键加黑底_新增",false,102)]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void Heidi()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        Debug.Log(colorall.Length);
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            colorall[i].r = Mathf.Lerp(0, colorall[i].r, colorall[i].a);
            colorall[i].g = Mathf.Lerp(0, colorall[i].g, colorall[i].a);
            colorall[i].b = Mathf.Lerp(0, colorall[i].b, colorall[i].a);
            colorall[i].a = 1;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1,"_HeiDi_",1,SaveGeshi.PNG,new Color(1,0.5f,0.5f,1), "已输出添加黑底的图 可以在贴图设置中取消“Alpha is Transparency”勾选以节省空间。更多工具 B站@ ADY521");
    }
    [MenuItem("Assets/ADYFX_贴图工具箱/一键加黑底_覆盖", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool Heidibool1()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键加黑底_覆盖", false, 101)]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void Heidi1()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        string fugaigeshi = "png";
        if (ADYFX_Editor.JianChaTexGeShi(path1, ADYFX_Editor.TexSaveGeShi()))
        {
            fugaigeshi = ADYFX_Editor.ReturnTexGeShi(path1, ADYFX_Editor.TexSaveGeShi());
        }
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            colorall[i].r = Mathf.Lerp(0, colorall[i].r, colorall[i].a);
            colorall[i].g = Mathf.Lerp(0, colorall[i].g, colorall[i].a);
            colorall[i].b = Mathf.Lerp(0, colorall[i].b, colorall[i].a);
            colorall[i].a = 1;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, fugaigeshi, new Color(1, 0.5f, 0.5f, 1), "已输出添加黑底的图 可以在贴图设置中取消“Alpha is Transparency”勾选以节省空间。更多工具 B站@ ADY521");
    }


    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法1_RGB求Max(特效图)", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool JiaHei()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法1_RGB求Max(特效图)")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void JiaHeidi()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        Debug.Log(colorall.Length);
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            float max1 = Mathf.Max(rgb.x, rgb.y, rgb.z);
            colorall[i].r = max1;
            colorall[i].g = max1;
            colorall[i].b = max1;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, "_HeiBai_A_", 1, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已生成。更多工具 B站@ ADY521");
    }


    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法2_RGB*0.33333(特效图)", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool HuiDuBool1()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法2_RGB*0.33333(特效图)")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void HuiDu1()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        Debug.Log(colorall.Length);
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            float max1 = rgb.x * 0.33333f + rgb.y * 0.33333f+rgb.z * 0.33333f;
            colorall[i].r = max1;
            colorall[i].g = max1;
            colorall[i].b = max1;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, "_HeiBai_B_", 1, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已生成。更多工具 B站@ ADY521");
    }


    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法3_灰度公式(通常图)", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool HuiDuBool()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键转灰度图/※方法3_灰度公式(通常图)")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void HuiDu()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        Debug.Log(colorall.Length);
        for (int i = 0; i < colorall.Length; i++)
        {
            float rr = colorall[i].r;
            float gg = colorall[i].g;
            float bb = colorall[i].b;
            float Gray = 0;
            Gray = rr * 0.299f + gg * 0.587f + bb * 0.114f;
            colorall[i].r = Gray;
            colorall[i].g = Gray;
            colorall[i].b = Gray;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, "_HeiBai_C_", 1, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已生成。更多工具 B站@ ADY521");
    }
    static string Jueduilujing1(string patht)//处理文件在资源库中的路径
    {
        string[] split = patht.Split('/');//按反斜杠对字符串进行分割
        string[] cc = new string[split.Length];
        string newpath = "";
        for (int i = 0; i < split.Length; i++)
        {
            cc[i] = split[i];
            if (i != split.Length - 1)
            {
                if (i != 0)
                {
                    newpath = newpath + "/" + cc[i];
                }
                if (i == 0)
                {
                    //newpath = "/" + cc[i];
                    newpath = "" + cc[i];
                }
            }
            //Debug.Log("其一："+cc[i]);
        }
        Debug.Log("路径：" + newpath);
        return newpath;
    }
    [MenuItem("Assets/ADYFX_贴图工具箱/一键抠黑_覆盖(仅适用黑白图)", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool ValidateSplitFbxAnimation()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键抠黑_覆盖(仅适用黑白图)", false, 100)]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void UnMult()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        string fugaigeshi = "png";
        if (ADYFX_Editor.JianChaTexGeShi(path1, ADYFX_Editor.TexSaveGeShi()))
        {
            fugaigeshi = ADYFX_Editor.ReturnTexGeShi(path1, ADYFX_Editor.TexSaveGeShi());
        }
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            float max2 = Mathf.Max(rgb.x, rgb.y, rgb.z);
            colorall[i].r = 1;
            colorall[i].g = 1;
            colorall[i].b = 1;
            colorall[i].a = max2;

        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        tex.alphaIsTransparency = true;
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, fugaigeshi, new Color(1, 0.5f, 0.5f, 1), "已扣黑。更多工具 B站@ ADY521");
    }
    [MenuItem("Assets/ADYFX_贴图工具箱/一键抠黑_新增(仅适用黑白图)", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool ValidateSplitFbxAnimation1()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键抠黑_新增(仅适用黑白图)", false, 100)]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void UnMult1()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        for (int i = 0; i < colorall.Length; i++)
        {
            Vector3 rgb = new Vector3(colorall[i].r, colorall[i].g, colorall[i].b);
            float max2 = Mathf.Max(rgb.x, rgb.y, rgb.z);
            colorall[i].r = 1;
            colorall[i].g = 1;
            colorall[i].b = 1;
            colorall[i].a = max2;

        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex_returnPath(texture2D, pathwin, name1, "_KouHei_", 1, SaveGeshi.PNG, new Color(1, 0.5f, 0.5f, 1), "已扣黑。更多工具 B站@ ADY521");
        //Debug.Log("shuchyu:"+ rentunstring);
        string cca = ADYFX_Editor.WinPathToAssetsPath(pathwin + "/" + (name1 + "_KouHei_" + "1") + ".png");
        TextureImporter tex1 = ModelImporter.GetAtPath(cca) as TextureImporter;
        tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
        AssetDatabase.ImportAsset(cca);//应用设置 并刷新资源库
        tex1.alphaIsTransparency = true;
        tex.isReadable = false;//开启贴图资源的允许读写，准备进行alpha判断
        AssetDatabase.ImportAsset(cca);//应用设置 并刷新资源库
        //AssetDatabase.Refresh();//刷新资源库
        ADYFX_Editor.SeleAssetsObj(ADYFX_Editor.WinPathToAssetsPath(pathwin + "/" + (name1+ "_KouHei_"+ "1") + ".png"));
    }


    [MenuItem("Assets/ADYFX_贴图工具箱/一键反相_覆盖", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool fanxiangpanduan()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/一键反相_覆盖", false, 102)]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void Fanxiang()
    {
        bool dx = false;
        Texture2D aa = Selection.objects[0] as Texture2D;
        string path1 = AssetDatabase.GetAssetPath(aa);//获取路径
        TextureImporter tex = ModelImporter.GetAtPath(path1) as TextureImporter;
        string pathwin = ADYFX_Editor.GetFullPath(aa);
        string fugaigeshi = "png";
        if (ADYFX_Editor.JianChaTexGeShi(path1, ADYFX_Editor.TexSaveGeShi()))
        {
            fugaigeshi = ADYFX_Editor.ReturnTexGeShi(path1, ADYFX_Editor.TexSaveGeShi());
        }
        if (tex.isReadable == false)
        {
            tex.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
            dx = true;
        }
        Color[] colorall = aa.GetPixels();
        for (int i = 0; i < colorall.Length; i++)
        {
            colorall[i].r = 1- colorall[i].r;
            colorall[i].g = 1- colorall[i].g;
            colorall[i].b = 1 - colorall[i].b;
            colorall[i].a = colorall[i].a;
        }
        string name1 = aa.name;
        Vector2 v2 = new Vector2(aa.width, aa.height);
        tex.alphaIsTransparency = true;
        if (dx)
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置并刷新资源库
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源库
        Texture2D texture2D = new Texture2D(aa.width, aa.height, TextureFormat.RGBAFloat, false);//, TextureFormat.RGBAFloat, false
        texture2D.SetPixels(colorall);
        texture2D.Apply();
        ADYFX_Editor.SaveTex(texture2D, pathwin, name1, fugaigeshi, new Color(1, 0.5f, 0.5f, 1), "已反相。更多工具 B站@ ADY521");
    }
}
