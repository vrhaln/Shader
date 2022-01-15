using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace SDFFaceLightmap
{
    /// <summary>
    /// Reference: http://www.codersnotes.com/notes/signed-distance-fields/
    /// </summary>
    public struct Point
    {
        public int dx, dy;

        public int DistSq { get => dx * dx + dy * dy; }
    }
    
    public struct Grid
    {
        public Point[,] grid;
    };
    
    public class SDFFaceLightmapGenerator : Editor
    {
        private static int WIDTH = 0;
        private static int HEIGHT = 0;
        private static Point Inside = new Point {dx = 0, dy = 0};
        private static Point Empty = new Point {dx = 999, dy = 999}; // 数值不能太大，避免平方时超出数值范围

        private static Grid _grid1, _grid2;

        private static void ResetParams()
        {
            Resources.UnloadUnusedAssets();
            WIDTH = 0;
            HEIGHT = 0;
            _grid1 = new Grid();
            _grid2 = new Grid();
        }
        
        private static Point Get(ref Grid g, int x, int y)
        {
            // OPTIMIZATION: you can skip the edge check code if you make your grid 
            // have a 1-pixel gutter.
            if (x >= 0 && y >= 0 && x < WIDTH && y < HEIGHT)
                return g.grid[y, x];
            else
                return Empty;
        }
        
        private static void Put(ref Grid g, int x, int y, ref Point p)
        {
            g.grid[y, x] = p;
        }
        
        private static void Compare(ref Grid g, ref Point p, int x, int y, int offsetX, int offsetY)
        {
            Point other = Get(ref g, x + offsetX, y + offsetY);
            other.dx += offsetX;
            other.dy += offsetY;

            if (other.DistSq < p.DistSq)
                p = other;
        }
        
        private static float GenerateSDF(ref Grid g)
        {
            float maxValue = -1f;
            // 左上->右下，计算SDF
            for (int y = 0; y < HEIGHT; y++)
            {
                for (int x = 0; x < WIDTH; x++)
                {
                    Point p = Get(ref g, x, y);
                    Compare(ref g, ref p, x, y, -1,  0);
                    Compare(ref g, ref p, x, y,  0, -1);
                    Compare(ref g, ref p, x, y, -1, -1);
                    Compare(ref g, ref p, x, y,  1, -1);
                    Put(ref g, x, y, ref p);
                }

                for (int x = WIDTH - 1; x >= 0; x--)
                {
                    Point p = Get(ref g, x, y);
                    Compare(ref g, ref p, x, y, 1, 0);
                    Put(ref g, x, y, ref p);
                }
            }

            // 右下->左上，计算SDF
            for (int y = HEIGHT - 1; y >= 0; y--)
            {
                for (int x = WIDTH - 1; x >= 0; x--)
                {
                    Point p = Get(ref g, x, y);
                    Compare(ref g, ref p, x, y,  1,  0);
                    Compare(ref g, ref p, x, y,  0,  1);
                    Compare(ref g, ref p, x, y, -1,  1);
                    Compare(ref g, ref p, x, y,  1,  1);
                    Put(ref g, x, y, ref p); 
                }

                for (int x = 0; x < WIDTH; x++)
                {
                    Point p = Get(ref g, x, y);
                    Compare(ref g, ref p, x, y, -1, 0);
                    Put(ref g, x, y, ref p);
                    
                    if (maxValue < p.DistSq)
                    {
                        maxValue = p.DistSq;
                    }
                }
            }
            
            return Mathf.Sqrt(maxValue);
        }

        private static Color[] CalculateTextureSDF(Texture2D tex)
        {
            if (WIDTH == 0 || HEIGHT == 0)
            {
                WIDTH = tex.width;
                HEIGHT = tex.height;
                _grid1.grid = new Point[WIDTH, HEIGHT];
                _grid2.grid = new Point[WIDTH, HEIGHT];
            }

            for (int x = 0; x < WIDTH; x++)
            {
                for (int y = 0; y < HEIGHT; y++)
                {
                    Color col = tex.GetPixel(x, y);
                    if (col.r > 0.1f)
                    {
                        Put(ref _grid1, y, x, ref Inside);
                        Put(ref _grid2, y, x, ref Empty);
                    }
                    else
                    {
                        Put(ref _grid1, y, x, ref Empty);
                        Put(ref _grid2, y, x, ref Inside);
                    }
                }
            }
            
            var insideMax = GenerateSDF(ref _grid1);
            var outsideMax = GenerateSDF(ref _grid2);
            int maxBase = Mathf.Max(WIDTH, HEIGHT);

            Color[] sdf = new Color[WIDTH * HEIGHT];
            for (int y = 0; y < HEIGHT; y++)
            {
                for (int x = 0; x < WIDTH; x++)
                {
                    float dist1 = Mathf.Sqrt(Get(ref _grid1, y, x).DistSq);
                    float dist2 = Mathf.Sqrt(Get(ref _grid2, y, x).DistSq);
                    float dist = dist1 - dist2;
                    float c = 0.5f;

                    if (dist < 0)
                    {
                        c += dist / outsideMax * 0.5f;
                    }
                    else
                    {
                        c += dist / insideMax * 0.5f;
                    }

                    sdf[x + y * HEIGHT] = new Color(c, Mathf.Clamp01(insideMax / maxBase), Mathf.Clamp01(outsideMax / maxBase));
                }
            }

            return sdf;
        }

        private static void BlendSDF(int width, int height, Color[] sdf1, Color[] sdf2, int sampleTimes, Color[] result, int blendIndex)
        {
            for (int y = 0; y < height; y++)
            {
                for(int x = 0; x < width; x++)
                {
                    int index = x + y * width;
                    var dist1 = sdf1[index];
                    var dist2 = sdf2[index];
                    var c = SDFBlur(sampleTimes, dist1.r, dist2.r);
                    if (blendIndex == 0)
                    {
                        result[index] = new Color(c, c, c);
                    }
                    else
                    {
                        float blendRatio = (float)blendIndex / (blendIndex + 1);
                        var oldBlendVal = result[index];
                        var newBlendVal = oldBlendVal.r * blendRatio + c * (1 - blendRatio);
                        result[index] = new Color(newBlendVal, newBlendVal, newBlendVal);
                    }
                }
            }
        }

        private static float SDFBlur(int sampleTimes, float dist1, float dist2)
        {
            float res = 0f;
            if (dist1 < 0.4999f && dist2 < 0.4999f)
                return 1.0f;
            if (dist1 > 0.5f && dist2 > 0.5f)
                return 0f;

            for (int i = 0; i < sampleTimes; i++)
            {
                float lerpValue = (float)i / sampleTimes;
                res += Mathf.Lerp(dist1, dist2, lerpValue) < 0.499f ? 1 : 0;
            }
            return res / sampleTimes;
        }

        [MenuItem("Assets/SDFFaceLightmap/Generate Lightmap")]
        private static void Execute()
        {
            ResetParams();
            
            var selectedObj = Selection.activeObject;
            var selectedPath = AssetDatabase.GetAssetPath(selectedObj);
            List<string> texRelativePathList = new List<string>();
            if (!string.IsNullOrEmpty(selectedPath) && !Path.HasExtension(selectedPath))
            {
                DirectoryInfo dir = new DirectoryInfo(selectedPath);
                FileSystemInfo[] fileinfo = dir.GetFileSystemInfos();
                foreach (FileSystemInfo info in fileinfo)
                {
                    if (info.Extension == ".png" && int.TryParse(Path.GetFileNameWithoutExtension(info.Name), out var num))
                    {
                        string relativePath = info.FullName.Substring(info.FullName.IndexOf("Assets"));
                        texRelativePathList.Add(relativePath);
                    }
                }
            }
            
            texRelativePathList.Sort((a, b) =>
            {
                int indexA = int.Parse(Path.GetFileNameWithoutExtension(a));
                int indexB = int.Parse(Path.GetFileNameWithoutExtension(b));
                return indexA - indexB;
            });
            
            // 计算SDF
            List<Color[]> sdfList = new List<Color[]>(texRelativePathList.Count);
            List<Texture2D> texList = new List<Texture2D>();
            for (int i = 0; i < texRelativePathList.Count; i++)
            {
                string path = texRelativePathList[i];
                EditorUtility.DisplayProgressBar("SDF Face Lightmap Generator", $"Calculate Texture {Path.GetFileNameWithoutExtension(path)} SDF", (float)i / (texRelativePathList.Count + 1));
                
                var tex = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                if (tex == null)
                {
                    Debug.LogError("加载图片失败！Path:" + path);
                    EditorUtility.ClearProgressBar();
                    Resources.UnloadUnusedAssets();
                    return;
                }
                texList.Add(tex);
                
                var sdf = CalculateTextureSDF(tex);
                if (sdf != null)
                {
                    sdfList.Add(sdf);
                }
            }

            // 利用SDF生成中间的过渡，并进行叠加混合
            EditorUtility.DisplayProgressBar("SDF Face Lightmap Generator", "Blending SDF", (float)texRelativePathList.Count / (texRelativePathList.Count + 1));
            Color[] lightmapCols = new Color[WIDTH * HEIGHT];
            for (int i = 0; i < sdfList.Count - 1; i++)
            {
                var curSdfTex = sdfList[i];
                var nextSdfTex = sdfList[i + 1];
                BlendSDF(WIDTH, HEIGHT, curSdfTex, nextSdfTex, 50, lightmapCols, i);
            }

            Texture2D sdfTex = new Texture2D(WIDTH, HEIGHT, TextureFormat.RGB24, false);
            sdfTex.SetPixels(lightmapCols);
            sdfTex.Apply();
            using (FileStream fs = new FileStream(Path.GetFullPath(selectedPath) + "/SDFFaceLightmap.png", FileMode.Create))
            {
                byte[] bytes = sdfTex.EncodeToPNG();
                fs.Write(bytes, 0, bytes.Length);
            }
            
            EditorUtility.ClearProgressBar();
            AssetDatabase.Refresh();
            Resources.UnloadUnusedAssets();
        }
    }
}