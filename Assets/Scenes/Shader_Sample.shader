Shader "Unlit/Shader_Sample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DissolveTex ("Overlay Texture", 2D) = "white" {}
        [Space(20)][Header(Timer)]
        _T ("T", Range(0, 1)) = 0.0
        [Space(20)][Header(Smooth)]
        _SmoothFactor ("Smooth Factor", Range(0, 1)) = 0.02
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        // 设置透明混合模式
        Blend SrcAlpha OneMinusSrcAlpha 

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            sampler2D _DissolveTex;
            float _T;
            float _SmoothFactor;

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

            // inline fixed4 GetDissolvedColor(v2f i){
            //     float textureV = tex2D(_DissolveTex, i.uv).r;
            //     fixed4 baseColor = tex2D(_MainTex, i.uv);  // 获取原图颜色

            //     if(_T > textureV)
            //     {
            //         baseColor.a = 0.0;  // 透明度设置为0
            //     }

            //     return baseColor;
            // }

            inline fixed4 GetDissolvedColor(v2f i){
                float textureV = tex2D(_DissolveTex, i.uv).r;
                fixed4 baseColor = tex2D(_MainTex, i.uv);  // 获取原图颜色
                
                // 添加平滑过渡，抗锯齿
                float edgeBlend = smoothstep(_T - _SmoothFactor, _T + _SmoothFactor, textureV);
            
                baseColor.a *= edgeBlend;  // 通过平滑过渡控制透明度
            
                return baseColor;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = GetDissolvedColor(i);
                return c;
            }
            ENDCG
        }
    }
}