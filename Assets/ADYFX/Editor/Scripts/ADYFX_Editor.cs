using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
public enum SaveGeshi
{
    JPG = 0,
    PNG = 1,
    TGA = 2,
};

public enum RGBASele
{
    此图取R通道 = 0,
    此图取G通道 = 1,
    此图取B通道 = 2,
    此图取A通道 = 3,
};
public class ADYFX_Editor
{
    static public bool PathAssetsPanDuan(string path)
    {
        bool aa = false;
       string[] bb =  path.Split('/');
        for(int i = 0;i< bb.Length;i++)
        {
            if (bb[i] == "Assets")
            {
                aa = true;
            }
        }
        return aa;
    }

    static public void SetTexImport(string path ,bool noalpha)
    {
        //TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuanTex)) as TextureImporter;
        TextureImporter tex1 = TextureImporter.GetAtPath(path) as TextureImporter;
        tex1.isReadable = true;
        tex1.npotScale = TextureImporterNPOTScale.None;
        tex1.alphaSource = TextureImporterAlphaSource.FromInput;
        if (noalpha == false)
        {
            tex1.alphaIsTransparency = false;
        }
        else
        {
            tex1.alphaIsTransparency = true;
        }

        AssetDatabase.ImportAsset(path);//应用设置 并刷新资源库
    }

    static public void SetTexImport(string path) 
    {
        //TextureImporter tex1 = TextureImporter.GetAtPath(ADYFX_Editor.GetPath(yuanTex)) as TextureImporter;
        TextureImporter tex1 = TextureImporter.GetAtPath(path) as TextureImporter;
        tex1.isReadable = true;
        tex1.npotScale = TextureImporterNPOTScale.None;
        tex1.alphaSource = TextureImporterAlphaSource.FromInput;
        tex1.alphaIsTransparency = true;
        AssetDatabase.ImportAsset(path);//应用设置 并刷新资源库
    }

    static public string ImportSystemTex(string savename)
    {
        string re = "";
        string sourcePath = "";
        string pathsele = EditorUtility.OpenFilePanelWithFilters("选择Windows中的图片 （在【打开】按钮上方切换筛选格式） ", "", new string[] { "png", "png", "tga", "tga", "jpg", "jpg", "dds", "dds" });
        string[] split = pathsele.Split('/');//按反斜杠对字符串进行分割
        if (split.Length >= 2)
        {
            string fileName = split[split.Length - 1];
            for (int i = 0; i < split.Length; i++)
            {
                if (i != split.Length - 1)
                {
                    if (i <= split.Length - 2)
                    {
                        sourcePath += split[i] + @"\";
                    }
                    else
                    {
                        sourcePath += split[i];
                    }
                }
            }
            string sourceFile = Path.Combine(sourcePath, fileName);
            string[] fengename = fileName.Split('.');//按.对字符串进行分割
            if (fengename[1]=="dds")//如果选择了dds的图片 则改成png格式复制进unity  因为System.IO无法正确生成dds格式
            {
                fengename[1] = "png";
            }
            string targetPath = Path.Combine(ADYFX_Editor.GetAssetsToWinPath(@"Assets\ADYFX\Elements\Temp"), savename + "." + fengename[1]);
            string istargetpath = ADYFX_Editor.GetAssetsToWinPath(@"Assets\ADYFX\Elements\Temp");
            if (!Directory.Exists(istargetpath))//判断有没有temp文件夹 如果没有就创建
            {
                Directory.CreateDirectory(istargetpath);
            }
            // 复制文件，TRUE为如果目标目录已存在该文件，则覆盖；FALSE已存在该文件 则取消复制
            File.Copy(sourceFile, targetPath, true);
            AssetDatabase.Refresh();
            re = "Assets/ADYFX/Elements/Temp" + "/" + savename + "." + fengename[1];
            //AssetDatabase.RenameAsset();
            // 移动文件
            //File.Move(sourceFile, destFile);
            //Debug.Log("导入了临时图片  路径为："+ re);
        }
        return re;
    }

    static public void ImportSystemTex(string assetsPath ,string savename)
    {
        string sourcePath = "";
        string pathsele = EditorUtility.OpenFilePanelWithFilters("选择Windows中的图片 ", "", new string[] { "png", "png", "tga", "tga", "jpg", "jpg", "dds", "dds" });
        string[] split = pathsele.Split('/');//按反斜杠对字符串进行分割
        string fileName = split[split.Length - 1];
        for (int i = 0; i < split.Length; i++)
        {
            if (i != split.Length - 1)
            {
                if (i <= split.Length - 2)
                {
                    sourcePath += split[i] + @"\";
                }
                else
                {
                    sourcePath += split[i];
                }
            }
        }
        string[] apath = assetsPath.Split('/');
        string assetspathtemp = "";
        for (int j = 0;j< apath.Length;j++)
        {
            if (j < apath.Length - 1)
            {
                assetspathtemp += apath[j] + @"\";
            }
            else
            {
                assetspathtemp += apath[j];
            }

        }
        string sourceFile = Path.Combine(sourcePath, fileName);
        string[] fengename = fileName.Split('.');//按.对字符串进行分割
        string targetPath = Path.Combine(assetspathtemp, savename + "." + fengename[1]);
        string istargetpath = ADYFX_Editor.GetAssetsToWinPath(@"Assets\ADYFX\Elements\Temp");
        if (!Directory.Exists(istargetpath))//判断有没有temp文件夹 如果没有就创建
        {
            Directory.CreateDirectory(istargetpath);
        }
        // 复制文件，TRUE为如果目标目录已存在该文件，则覆盖；FALSE已存在该文件 则取消复制
        File.Copy(sourceFile, targetPath, true);
        AssetDatabase.Refresh();
        //AssetDatabase.RenameAsset();
        // 移动文件
        //File.Move(sourceFile, destFile);
    }


    static public void QuXiaoJujiao()
    {
        GUI.FocusControl(null);
    }



    static public bool Anjian(KeyCode keyCode ,int zhuangtai)
    {
        bool aa = false;
        if (zhuangtai == 0)
        {
            if (Event.current.keyCode == keyCode)//按住按键
            {
                aa = true;
            }
        }
        else if (zhuangtai == 1)
        {
            if (Event.current.type == EventType.KeyDown)//按下按键
            {
                if (Event.current.keyCode == keyCode)
                {
                    aa = true;
                }
            }
        }
        else
        {
            if (Event.current.type == EventType.KeyUp)//按键抬起
            {
                if (Event.current.keyCode == keyCode)
                {
                    aa = true;
                }
            }
        }
        return aa;
    } 


    static public void SetColorSpaceValue() 
    {
        if (PlayerSettings.colorSpace == ColorSpace.Linear) //判断色彩空间
        {
            Shader.SetGlobalFloat("_ColorSpaceValue", 1 / 2.2f);
        }
        else
        {
            Shader.SetGlobalFloat("_ColorSpaceValue", 1);
        }
    }



    [MenuItem("ADYFX/打开工程目录 _F12",false,3001)]
        static void OpenProjectPath()
    {
        string aa = Application.dataPath;
        string[] split = aa.Split('/');//按反斜杠对字符串进行分割
        string newpath = "";
        for (int i = 0;i<split.Length-1;i++) 
        {
            if (i != 0)
            {
                newpath = newpath + "/" + split[i];
            }
            else 
            {
                newpath = newpath + split[i];
            }
        }
        Application.OpenURL("file://" + newpath);
        Debug.Log("打开了assets路径"+ newpath);
    }

    public static void SeleAssetsObj(string path) 
    {
        Object obj = AssetDatabase.LoadMainAssetAtPath(path);
        Selection.activeObject = obj;
        //var assetObj = AssetDatabase.LoadAssetAtPath<GameObject>(FXpath);//在库中框选当前特效
        EditorGUIUtility.PingObject(obj);
    }

    public static void SetTex2DisAlpha(string path) 
    {
        TextureImporter tex1 = TextureImporter.GetAtPath(path) as TextureImporter;
        tex1.isReadable = true;//开启贴图资源的允许读写，准备进行alpha判断
        AssetDatabase.ImportAsset(path);//应用设置 并刷新资源库
        tex1.alphaSource = TextureImporterAlphaSource.FromInput;//设置为导入Alpha
        tex1.alphaIsTransparency = true;//设置为以png的透明像素为Alpha
        tex1.isReadable = false;
        AssetDatabase.ImportAsset(path);//应用设置 并刷新资源库
        //AssetDatabase.Refresh();//刷新资源库
    }

    public static Texture2D GetTexColor_Texture2D(Texture2D YuanTu) 
    {
        Texture2D aa = new Texture2D(YuanTu.width, YuanTu.height, TextureFormat.RGBA32, true);//新建图像的TextureFormat要用新建的 不要用原图的 否则可能不能正常获取YuanTu.GetPixels()
        TextureImporter ti = (TextureImporter)TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(YuanTu));
        ti.isReadable = true;
        //ti.npotScale = TextureImporterNPOTScale.None;//设置2次幂选项 关闭则不设置  开启则有3个选项 取最近、取大、取小
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(YuanTu));
        aa.SetPixels(YuanTu.GetPixels());
        ti.isReadable = false;
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(YuanTu));
        return aa;
    }

    public static Color[] GetTexColor_Color (Texture2D YuanTu)
        {
        Color[] cc = new Color[YuanTu.width* YuanTu.height];
        TextureImporter ti = (TextureImporter)TextureImporter.GetAtPath(AssetDatabase.GetAssetPath(YuanTu));
        ti.isReadable = true;
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(YuanTu));
        cc = YuanTu.GetPixels();
        ti.isReadable = false;
        AssetDatabase.ImportAsset(AssetDatabase.GetAssetPath(YuanTu));
        return cc;
        }

    public static Texture2D TextureScale(Texture2D YuanTu, float targetWidth, float targetHeight)
    {
        Texture2D result = new Texture2D((int)targetWidth, (int)targetHeight, YuanTu.format, false);
        for (int i = 0; i < result.height; ++i)
        {
            for (int j = 0; j < result.width; ++j)
            {
                Color newColor = YuanTu.GetPixelBilinear((float)j / (float)result.width, (float)i / (float)result.height);
                result.SetPixel(j, i, newColor);
            }
        }
        result.Apply();
        return result;
    }

    public static bool IsShuBiaoPos(Vector4 要判断的鼠标所在区间,Vector2 鼠标位置) 
    {
        bool aa = false;
        if (鼠标位置.x > 要判断的鼠标所在区间.x && 鼠标位置.x < 要判断的鼠标所在区间.y&& 鼠标位置.y > 要判断的鼠标所在区间.z&& 鼠标位置.y < 要判断的鼠标所在区间.w) 
        {
             aa = true;
        }
        return aa;
    }

    public static bool JianChaTexGeShi (string path,string geshi)
        {
        bool aa = false;
        string[] split = path.Split('.');//按反斜杠对字符串进行分割
        string[] cc = new string[split.Length];
        for (int i = 0; i < split.Length; i++)
        {
            cc[i] = split[i];
            //Debug.Log(cc[i]);
        }
        if (cc[cc.Length-1] == geshi) 
        {
            aa = true;
        }
        else 
        {
            aa = false;
        }

        return aa;
      }
    public static bool JianChaTexGeShi(string path, string[] geshi)
    {
        bool aa = false;
        string[] split = path.Split('.');//按反斜杠对字符串进行分割
        string[] cc = new string[split.Length];
        for (int i = 0; i < split.Length; i++)
        {
            cc[i] = split[i];
        }
        for (int j = 0; j < geshi.Length; j++) 
        {
            if (cc[cc.Length - 1] == geshi[j]) 
            {
                aa = true;
            }
        }
        return aa;
    }

    public static string ReturnTexGeShi(string path, string[] geshi)
    {
        string shuchu = "";
        string[] split = path.Split('.');//按反斜杠对字符串进行分割
        string[] cc = new string[split.Length];
        for (int i = 0; i < split.Length; i++)
        {
            cc[i] = split[i];
        }
        for (int j = 0; j < geshi.Length; j++)
        {
            if (cc[cc.Length - 1] == geshi[j])
            {
                shuchu = geshi[j];
                return shuchu;
            }
        }
        return shuchu;
    }

    public static string[] TexSaveGeShi() 
    {
        string[] aa = new string[6];
        aa[0] = "png";
        aa[1] = "PNG";
        aa[2] = "jpg";
        aa[3] = "JPG";
        aa[4] = "TGA";
        aa[5] = "tga";
        return aa;
    }

    public static string[] TexGeShis() 
    {
        string[] aa = new string[40];
        aa[0] = "bmp";
        aa[1] = "BMP";
        aa[2] = "jpg";
        aa[3] = "JPG";
        aa[4] = "psd";
        aa[5] = "PSD";
        aa[6] = "psb";
        aa[7] = "PSB";
        aa[8] = "jpeg";
        aa[9] = "JPEG";
        aa[10] = "jpe";
        aa[11] = "JPE";
        aa[12] = "png";
        aa[13] = "PNG";
        aa[14] = "TGA";
        aa[15] = "tga";
        aa[16] = "tif";
        aa[17] = "TIF";
        aa[18] = "gif";
        aa[19] = "GIF";
        aa[20] = "pcx";
        aa[21] = "PCX";
        aa[22] = "exif";
        aa[23] = "EXIF";
        aa[24] = "fpx";
        aa[25] = "FPX";
        aa[26] = "SVG";
        aa[27] = "svg";
        aa[28] = "webp";
        aa[29] = "WEBP";
        aa[30] = "WMF";
        aa[31] = "wmf";
        aa[32] = "iff";
        aa[33] = "IFF";
        aa[34] = "PXR";
        aa[35] = "pxr";
        aa[36] = "dds";
        aa[37] = "DDS";
        aa[38] = "exif";
        aa[39] = "EXIF";
        return aa;
    }

    public static string GetSystemPath()
    {
        string path = EditorUtility.OpenFolderPanel("", "", ""); ;
        return path;
    }

    public static Texture2D GetTex2D(string path)
    {
        Texture2D texture2D = (Texture2D)AssetDatabase.LoadAssetAtPath(path, typeof(Texture2D));
        return texture2D;
    }

    public static string GetPath(Object obj) 
    {
        string pathAssets = AssetDatabase.GetAssetPath(obj);//获取库中路径
        return pathAssets;
    }

    public static string GetFullPath( Object obj)//使用一个string承接此结果 获取原文件的绝对路径
    {
        string pathAssets = AssetDatabase.GetAssetPath(obj);//获取库中路径
        string path0 = AssetsToSystemPath();//获取系统绝对路径  并去除路径中/后的“Assets”字符
        string path1 = AssetsPath(pathAssets);//原本文件路径去除文件名 再和绝对路径相加 组成完整路径
        string path = path0 + path1;
        return path;
    }

    public static string GetFullPath(Object obj,bool fudaigeshi)//使用一个string承接此结果 获取原文件的绝对路径
    {
        string pathAssets = AssetDatabase.GetAssetPath(obj);//获取库中路径
        string path0 = AssetsToSystemPath();//获取系统绝对路径  并去除路径中/后的“Assets”字符
        //string path1 = AssetsPath(pathAssets);//原本文件路径去除文件名 再和绝对路径相加 组成完整路径
        string path = path0 + pathAssets;
        return path;
    }

    public static string SaveTex_returnPath(Texture2D tex, string path, string name1, string houzhui, int xuhao, SaveGeshi saveGeshi, Color debugColor, string debugstring)
    {
        string aaaa = "";
        byte[] bytes;
        string geshi;
        if (saveGeshi == SaveGeshi.PNG)
        {
            bytes = tex.EncodeToPNG();
            geshi = ".png";
        }
        else if (saveGeshi == SaveGeshi.JPG)
        {
            bytes = tex.EncodeToJPG();
            geshi = ".jpg";
        }
        else
        {
            bytes = tex.EncodeToTGA();
            geshi = ".tga";
        }
        string endname = name1 + houzhui + xuhao;
        File.WriteAllBytes(path + "/" + endname + geshi, bytes);
        AssetDatabase.Refresh();
        string color16jinzhi = ColorUtility.ToHtmlStringRGB(debugColor);
        aaaa = path + "/" + endname + geshi;
        Debug.Log(string.Format("<color=#" + color16jinzhi + ">{0}</color>", debugstring + "  本次输出新文件：" + endname + geshi));
        return aaaa;
    }


    public static void SaveTex(Texture2D tex, string path,string name1,string houzhui,int xuhao, SaveGeshi saveGeshi, Color debugColor,string debugstring)
    {
        string aaaa = "";
        byte[] bytes;
        string geshi;
        if(saveGeshi == SaveGeshi.PNG)
        {
            bytes = tex.EncodeToPNG();
            geshi = ".png";
        }
        else if (saveGeshi == SaveGeshi.JPG)
        {
            bytes = tex.EncodeToJPG();
            geshi = ".jpg";
        }
        else
        {
            bytes = tex.EncodeToTGA();
            geshi = ".tga";
        }
        string endname = name1 + houzhui + xuhao;
        File.WriteAllBytes(path + "/" + endname + geshi, bytes);
        AssetDatabase.Refresh();
        string color16jinzhi = ColorUtility.ToHtmlStringRGB(debugColor);
        aaaa = path + "/" + endname + geshi;
        Debug.Log(string.Format("<color=#"+color16jinzhi+">{0}</color>", debugstring + "  本次输出新文件：" + endname + geshi));
        return ;
    }
    public static void SaveTex(Texture2D tex, string path, string name1,  string saveGeshi, Color debugColor, string debugstring)
    {
        string aaaa = "";
        byte[] bytes;
        string geshi = saveGeshi;
        if (saveGeshi == "png")
        {
            bytes = tex.EncodeToPNG();
            geshi = ".png";
        }
        else if (saveGeshi == "jpg")
        {
            bytes = tex.EncodeToJPG();
            geshi = ".jpg";
        }
        else
        {
            bytes = tex.EncodeToTGA();
            geshi = ".tga";
        }
        string endname = name1;
        File.WriteAllBytes(path + "/" + endname + geshi, bytes);
        AssetDatabase.Refresh();
        string color16jinzhi = ColorUtility.ToHtmlStringRGB(debugColor);
        aaaa = path + "/" + endname + geshi;
        Debug.Log(string.Format("<color=#" + color16jinzhi + ">{0}</color>", debugstring + "  本次输出新文件：" + endname + geshi));
        return;
    }
    public static void SaveTex(Texture2D tex, string path, string name1, string houzhui, SaveGeshi saveGeshi, Color debugColor, string debugstring)
    {
        string aaaa = "";
        byte[] bytes;
        string geshi;
        if (saveGeshi == SaveGeshi.PNG)
        {
            bytes = tex.EncodeToPNG();
            geshi = ".png";
        }
        else if (saveGeshi == SaveGeshi.JPG)
        {
            bytes = tex.EncodeToJPG();
            geshi = ".jpg";
        }
        else
        {
            bytes = tex.EncodeToTGA();
            geshi = ".tga";
        }
        string endname = name1 + houzhui;
        File.WriteAllBytes(path + "/" + endname + geshi, bytes);
        AssetDatabase.Refresh();
        string color16jinzhi = ColorUtility.ToHtmlStringRGB(debugColor);
        aaaa = path + "/" + endname + geshi;
        Debug.Log(string.Format("<color=#" + color16jinzhi + ">{0}</color>", debugstring + "  本次输出新文件：" + endname + geshi));
        return;
    }
    public static void SaveTex(Texture2D tex, string path, string name1, string houzhui, int xuhao, SaveGeshi saveGeshi)
    {
        byte[] bytes;
        string geshi;
        if (saveGeshi == SaveGeshi.PNG)
        {
            bytes = tex.EncodeToPNG();
            geshi = ".png";
        }
        else if (saveGeshi == SaveGeshi.JPG)
        {
            bytes = tex.EncodeToJPG();
            geshi = ".jpg";
        }
        else
        {
            bytes = tex.EncodeToTGA();
            geshi = ".tga";
        }
        string endname = name1 + houzhui + xuhao;
        File.WriteAllBytes(path + "/" + endname + geshi, bytes);
        AssetDatabase.Refresh();
        return;
    }

    static public string AssetsToSystemPath()//获取系统绝对路径
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
        }
        newpath = newpath + "/";
        return newpath;
    }

    static string AssetsPath(string patht)//得到文件在资源库中的路径
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
        return newpath;
    }

   public  static string WinPathToAssetsPath(string path) 
    {
        bool isxiegang = false;
        bool isassets = false;
        string[] split = path.Split('/');//按反斜杠对字符串进行分割
        string newpath = "";
        for (int i = 0; i < split.Length; i++)
        {
            if (split[i] == "Assets") 
            {
                isassets = true;
            }
            if (isassets == true) 
            {
                if (isxiegang == false)
                {
                    newpath = newpath + split[i];
                    isxiegang = true;
                }
                else 
                {
                    newpath = newpath + "/" + split[i];
                }

            }
        }
        return newpath;
    }

    public static string GetAssetsToWinPath(string assetsPath)
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
                    newpath = newpath + @"\" + cc[i];
                }
                if (i == 0)
                {
                    newpath = newpath + cc[i];
                }
            }
        }
        newpath = newpath + @"\";
        return newpath+ assetsPath;
    }
}
