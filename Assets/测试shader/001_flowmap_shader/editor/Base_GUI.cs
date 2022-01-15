using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Base_GUI : ShaderGUI
{
    MaterialProperty _Zwrite;
    MaterialProperty _dissolve_texture;
    MaterialProperty _normal_map;


    public override void OnGUI(
        MaterialEditor materialEditor,
        MaterialProperty[] properties
    )
    {
        EditorGUILayout.LabelField("皮皮虾牌Flowmapshader", EditorStyles.miniButton);

        EditorGUILayout.BeginVertical(EditorStyles.helpBox);

        _Zwrite = FindProperty("_Zwrite", properties);
        materialEditor.TextureProperty(_Zwrite, "基础遮罩");



        _normal_map = FindProperty("_normal_map", properties);
        materialEditor.ShaderProperty(_normal_map, "法线贴图");

        _dissolve_texture = FindProperty("_dissolve_texture", properties);

        materialEditor
            .TexturePropertySingleLine(new GUIContent("溶解贴图"),
            _dissolve_texture);

        EditorGUILayout
            .LabelField("默认使用custom1_zw控制噪波位移",
            EditorStyles.miniButton);

        EditorGUILayout.EndVertical();

        #region [分段]
             


        EditorGUILayout.LabelField("注释", EditorStyles.miniButton);

//画box
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);

        EditorGUILayout.EndVertical();

        #endregion
        
        materialEditor.RenderQueueField();

        #region [注意事项]
        EditorGUILayout.BeginVertical(EditorStyles.helpBox);
        EditorGUILayout
            .LabelField("警告！！！该shader完全未经过性能优化，请勿引入到项目中",
            EditorStyles.miniButton);
        EditorGUILayout
            .LabelField("主要目的是方便动画师或者特效师制作个人demo，请勿用于任何商业用途",
            EditorStyles.miniButton);
        EditorGUILayout
            .LabelField("个人知乎账号ID:shuang-miao-80 后续可能会有更新",
            EditorStyles.miniButton);
        EditorGUILayout
            .LabelField("技术谈论Q群:755239075", EditorStyles.miniButton);

        EditorGUILayout.EndVertical();


#endregion

    }
}
