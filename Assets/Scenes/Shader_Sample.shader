Shader "Unlit/Shader_Sample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondaryTex ("Overlay Texture", 2D) = "white" {}
        [Space(20)][Header(Timer)]
        _T ("T", Range(0, 1)) = 0.0
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
            sampler2D _SecondaryTex;
            float _T;

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
                float fade = min(_T / 1.0, 1.0);  // 计算渐变系数，最大值为1
                float textureV = tex2D(_SecondaryTex, i.uv).r;
                fixed4 baseColor = tex2D(_MainTex, i.uv);  // 获取原图颜色

                if(fade>textureV)
                {
                    // baseColor = float4(1,1,1,1);
                    // return baseColor;
                    discard;  
                }
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}