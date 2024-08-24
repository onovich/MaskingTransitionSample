Shader "Unlit/Shader_Sample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}  // 默认的 Sprite 纹理
        _SecondaryTex ("Overlay Texture", 2D) = "white" {}  // 自定义纹理
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            sampler2D _SecondaryTex;  // 自定义纹理采样器

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_SecondaryTex, i.uv);  // 使用自定义纹理
                return col;
            }
            ENDCG
        }
    }
}