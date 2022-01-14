using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

public class ADYFX_Tex2DRotate : Editor
{
    static int isgeshi(string path) 
    {
        string[] split = path.Split('.');//按反斜杠对字符串进行分割
        int size = split.Length -1;
        int zhenjia = 0;//序号判断，如果是Jpg输出0，如果是png输出1，如果是tga输出2
        if (split[size] == "jpg" || split[size] == "JPG")
        {
            zhenjia = 0;
        }
        else if (split[size] == "png" || split[size] == "PNG")
        {
            zhenjia = 1;
        }
        else if (split[size] == "TGA" || split[size] == "tga")
        {
            zhenjia = 2;
        }
        else
        {
            zhenjia = 1;//如果没有合适格式则输出Png
        }
        return zhenjia;
    }
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/顺时针90度", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool Zjs()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/顺时针90度")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void Zhengjiushi()
    {
        Texture2D yuantu = Selection.objects[0] as Texture2D;//获取选择的图
        string path1 = AssetDatabase.GetAssetPath(yuantu);//获取路径
        TextureImporter tex = TextureImporter.GetAtPath(path1) as TextureImporter;//获取贴图设置
        bool dx = false;//允许读写 bool
        int geshi;//判断选择图片的格式
        geshi = isgeshi(path1);

        Debug.Log(path1);
        if (tex.isReadable == false)//如果贴图不允许读写，则开启允许读写
        {
            tex.isReadable = true;//开启贴图资源的允许读写
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新此贴图
            dx = true;//标记为开启，最终判断此bool值来还原回原本的 允许读写设置
        }
        Color[] endcolor = new Color[(int)(yuantu.height * yuantu.width)];//初始化颜色数组长度为出图宽高
        Texture2D rotateTex = new Texture2D(yuantu.height, yuantu.width, TextureFormat.RGBAFloat, false);//创建一个新tex2d
        int cishu = 0;//记录已循环的次数 set对应序号到颜色组
        for (int i = 0; i < yuantu.width; i++)//宽高循环 贴图旋转九十度
        {
            for (int j = 0; j < yuantu.height; j++)//每次宽度循环都 循环一次高度
            {
                endcolor[cishu] = yuantu.GetPixel((yuantu.width - i) - 1, j);
                //把原图本次宽度循环 的高度循环的颜色值 set到颜色数组
                cishu += 1;//每set一个 标记值加一
            }
        }
        rotateTex.SetPixels(endcolor);//写入color[]到 像素数据 
        rotateTex.Apply();//保存tex2d
        Save(endcolor, new Vector2(rotateTex.width, rotateTex.height), yuantu.name, path1, tex,geshi);//写入像素
        if (dx)//如果前面把贴图的导入设置打开了  则关闭 如果没打开过 则不执行
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
    }

    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/逆时针90度", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool fujs()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/逆时针90度")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void Fujiushi()
    {
        Texture2D yuantu = Selection.objects[0] as Texture2D;//获取选择的图
        string path1 = AssetDatabase.GetAssetPath(yuantu);//获取路径
        TextureImporter tex = TextureImporter.GetAtPath(path1) as TextureImporter;//获取贴图设置
        bool dx = false;//允许读写 bool
        int geshi;//判断选择图片的格式
        geshi = isgeshi(path1);

        Debug.Log(path1);
        if (tex.isReadable == false)//如果贴图不允许读写，则开启允许读写
        {
            tex.isReadable = true;//开启贴图资源的允许读写
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新此贴图
            dx = true;//标记为开启，最终判断此bool值来还原回原本的 允许读写设置
        }
        Color[] endcolor = new Color[(int)(yuantu.height * yuantu.width)];//初始化颜色数组长度为出图宽高
        Texture2D rotateTex = new Texture2D(yuantu.height, yuantu.width, TextureFormat.RGBAFloat, false);//创建一个新tex2d
        int cishu = 0;//记录已循环的次数 set对应序号到颜色组
        for (int i = 0; i < yuantu.width; i++)//宽高循环 贴图旋转九十度
        {
            for (int j = 0; j < yuantu.height; j++)//每次宽度循环都 循环一次高度
            {
                endcolor[cishu] = yuantu.GetPixel(i, (yuantu.height - j) - 1);
                //把原图本次宽度循环 的高度循环的颜色值 set到颜色数组
                cishu += 1;//每set一个 标记值加一
            }
        }
        rotateTex.SetPixels(endcolor);//写入color[]到 像素数据 
        rotateTex.Apply();//保存tex2d
        Save(endcolor, new Vector2(rotateTex.width, rotateTex.height), yuantu.name, path1, tex, geshi);//写入像素
        if (dx)//如果前面把贴图的导入设置打开了  则关闭 如果没打开过 则不执行
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
    }

    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/180度", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool yibaiba()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/180度")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void YiBaiBashi()
    {
        Texture2D yuantu = Selection.objects[0] as Texture2D;//获取选择的图
        string path1 = AssetDatabase.GetAssetPath(yuantu);//获取路径
        TextureImporter tex = TextureImporter.GetAtPath(path1) as TextureImporter;//获取贴图设置
        bool dx = false;//允许读写 bool
        int geshi;//判断选择图片的格式
        geshi = isgeshi(path1);

        Debug.Log(path1);
        if (tex.isReadable == false)//如果贴图不允许读写，则开启允许读写
        {
            tex.isReadable = true;//开启贴图资源的允许读写
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新此贴图
            dx = true;//标记为开启，最终判断此bool值来还原回原本的 允许读写设置
        }
        Color[] endcolor = new Color[(int)(yuantu.height * yuantu.width)];//初始化颜色数组长度为出图宽高
        Color[] lowcolor = new Color[(int)(yuantu.height * yuantu.width)];//初始化颜色数组长度为出图宽高
        lowcolor = yuantu.GetPixels();
        int maxcishu = yuantu.height * yuantu.width;
        maxcishu -= 1;
        Texture2D rotateTex = new Texture2D(yuantu.width, yuantu.height, TextureFormat.RGBAFloat, false);//创建一个新tex2d
        int cishu = 0;//记录已循环的次数 set对应序号到颜色组
        for (int i = 0; i < yuantu.width; i++)//宽高循环 贴图旋转九十度
        {
            for (int j = 0; j < yuantu.height; j++)//每次宽度循环都 循环一次高度
            {
                endcolor[cishu] = lowcolor[maxcishu];
                //把原图本次宽度循环 的高度循环的颜色值 set到颜色数组
                cishu += 1;//每set一个 标记值加一
                maxcishu -= 1;
            }
        }
        rotateTex.SetPixels(endcolor);//写入color[]到 像素数据 
        rotateTex.Apply();//保存tex2d
        Save(endcolor, new Vector2(rotateTex.width, rotateTex.height), yuantu.name, path1, tex, geshi);//写入像素
        if (dx)//如果前面把贴图的导入设置打开了  则关闭 如果没打开过 则不执行
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
    }

    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/横向翻转", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool shuipingfan()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/横向翻转")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void ShuiPing()
    {
        Texture2D yuantu = Selection.objects[0] as Texture2D;//获取选择的图
        string path1 = AssetDatabase.GetAssetPath(yuantu);//获取路径
        TextureImporter tex = TextureImporter.GetAtPath(path1) as TextureImporter;//获取贴图设置
        bool dx = false;//允许读写 bool
        int geshi;//判断选择图片的格式
        geshi = isgeshi(path1);

        Debug.Log(path1);
        if (tex.isReadable == false)//如果贴图不允许读写，则开启允许读写
        {
            tex.isReadable = true;//开启贴图资源的允许读写
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新此贴图
            dx = true;//标记为开启，最终判断此bool值来还原回原本的 允许读写设置
        }
        Color[] endcolor = new Color[(int)(yuantu.width * yuantu.height)];//初始化颜色数组长度为出图宽高
        Texture2D rotateTex = new Texture2D(yuantu.width, yuantu.height, TextureFormat.RGBAFloat, false);//创建一个新tex2d
        int cishu = 0;//记录已循环的次数 set对应序号到颜色组
        for (int j = 0; j < yuantu.height; j++)//每次宽度循环都 循环一次高度
        {
            for (int i = 0; i < yuantu.width; i++)//宽高循环 贴图旋转九十度
            {
                endcolor[cishu] = yuantu.GetPixel((yuantu.width-i)-1, j);
                cishu += 1;//每set一个 标记值加一
            }
        }
        rotateTex.SetPixels(endcolor);//写入color[]到 像素数据 
        rotateTex.Apply();//保存tex2d
        Save(endcolor, new Vector2(rotateTex.width, rotateTex.height), yuantu.name, path1, tex, geshi);//写入像素
        if (dx)//如果前面把贴图的导入设置打开了  则关闭 如果没打开过 则不执行
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
    }

    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/垂直翻转", true)]//在上方写一个同名同路径的bool判断方法，以决定右键菜单的可用
    private static bool su()
    {
        if (Selection.objects[0] as Texture2D || Selection.objects.Length > 1)
            return true;//验证，返回true菜单可用，返回false菜单灰色不可用
        else return false;
    }
    //资源库 窗口右键菜单
    [MenuItem("Assets/ADYFX_贴图工具箱/※贴图旋转/垂直翻转")]//第三个值如果在10左右，且在gameobgect下，就可以放到右键菜单里了
    static void ZhongXiang()
    {
        Texture2D yuantu = Selection.objects[0] as Texture2D;//获取选择的图
        string path1 = AssetDatabase.GetAssetPath(yuantu);//获取路径
        TextureImporter tex = TextureImporter.GetAtPath(path1) as TextureImporter;//获取贴图设置
        bool dx = false;//允许读写 bool
        int geshi;//判断选择图片的格式
        geshi = isgeshi(path1);

        Debug.Log(path1);
        if (tex.isReadable == false)//如果贴图不允许读写，则开启允许读写
        {
            tex.isReadable = true;//开启贴图资源的允许读写
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新此贴图
            dx = true;//标记为开启，最终判断此bool值来还原回原本的 允许读写设置
        }
        Color[] endcolor = new Color[(int)(yuantu.width * yuantu.height)];//初始化颜色数组长度为出图宽高
        Texture2D rotateTex = new Texture2D(yuantu.width, yuantu.height, TextureFormat.RGBAFloat, false);//创建一个新tex2d
        int cishu = 0;//记录已循环的次数 set对应序号到颜色组
        for (int j = 0; j < yuantu.height; j++)//每次宽度循环都 循环一次高度
        {
            for (int i = 0; i < yuantu.width; i++)//宽高循环 贴图旋转九十度
            {
                endcolor[cishu] = yuantu.GetPixel(i, yuantu.height-j-1);
                cishu += 1;//每set一个 标记值加一
            }
        }
        rotateTex.SetPixels(endcolor);//写入color[]到 像素数据 
        rotateTex.Apply();//保存tex2d
        Save(endcolor, new Vector2(rotateTex.width, rotateTex.height), yuantu.name, path1, tex, geshi);//写入像素
        if (dx)//如果前面把贴图的导入设置打开了  则关闭 如果没打开过 则不执行
        {
            tex.isReadable = false;
            AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
        }
        AssetDatabase.ImportAsset(path1);//应用设置 并刷新资源
    }

    static void Save(Color[] colors, Vector2 kuangao, string name1, string path1, TextureImporter ttt ,int geshi)//写入像素数据并保存到指定绝对路径
    {
        TextureFormat texformat;//贴图设置
        if (geshi == 0)
        {
            texformat = TextureFormat.RGB24;//贴图设置32位 有A通道
        }
        else if (geshi == 1)
        {
            texformat = TextureFormat.RGBAFloat;//贴图设置32位 有A通道
        }
        else if (geshi == 2)
        {
            texformat = TextureFormat.RGBAFloat;//贴图设置32位 有A通道
        }
        else
        {
            texformat = TextureFormat.RGBAFloat;//贴图设置32位 有A通道
        }
        //texformat = TextureFormat.RGBAFloat;//贴图设置32位 有A通道
        Texture2D tex = new Texture2D((int)kuangao.x, (int)kuangao.y, texformat, false);//生命一个tex并设置宽高和图像有无A
        tex.SetPixels(colors);//写入color[]到 像素数据 
        tex.Apply();//应用写入
        byte[] bytes;//生命一个字节文件
        string houzhui ;
        if (geshi == 0) 
        {
            bytes = tex.EncodeToJPG(100);
            houzhui = ".jpg";
        }
        else if (geshi == 1) 
        {
            bytes = tex.EncodeToPNG();//tex的内容写入到字节文件 png格式
            houzhui = ".png";
        }
        else if (geshi == 2)
        {
            bytes = tex.EncodeToTGA();
            houzhui = ".tga";
        }
        else 
        {
            bytes = tex.EncodeToPNG();
            houzhui = ".png";
        }
        string temp1 = Jueduilujing();//获取系统绝对路径  并去除Assets
        string temp2 = Jueduilujing1(path1);//原本文件路径去除文件名 再和绝对路径相加 组成完整路径
        File.WriteAllBytes((temp1 + temp2) + "/" + name1 + houzhui, bytes);//保存
        AssetDatabase.Refresh();//刷新资源库
        //Debug.Log("获取新物体：" + (temp1 + temp2) + "/" + name1 + houzhui);
        Debug.Log(string.Format("<color=#4CFFB3>{0}</color>", "保存成功！！  更多工具B站@ADY521。" + "  本次输出新文件：" + name1 + houzhui));
        AssetDatabase.Refresh();//刷新资源库
    }
    static string Jueduilujing()//获取绝对路径
    {
        string patht = Application.dataPath;
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
                    newpath = newpath + cc[i];
                }
            }
            //Debug.Log("其一："+cc[i]);
        }
        //Debug.Log("路径："+ newpath);
        newpath = newpath + "/";
        return newpath;
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
        //Debug.Log("路径：" + newpath);
        return newpath;
    }
}
