// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CS0102/02_Texturing"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        //_Float("Float",Float) = 0.0
        //_Range("Range",Range(0.0,1.0)) = 0.0
        //_Vector("Vector",Vector) = (1,1,1,1)
        //_Color("Color",Color) = (0.5,0.5,0.5,0.5)
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("CullMode",float) = 2

            
    }
    SubShader
    {
        

        Pass
        {
            Cull [_CullMode]
            CGPROGRAM // Shader代码从这里开始
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;//第一套uv

            };
           
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;//通用储存器 插值器
                float2 pos_uv : TEXCOORD1;
            };

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                //float4 pos_world = mul(unity_ObjectToWorld,v.vertex);//模型空间转世界空间
                //float4 pos_view = mul(UNITY_MATRIX_V,pos_world);//世界空间转相机空间
                //float4 pos_clip = mul(UNITY_MATRIX_P,pos_view);//转到裁剪空间
                o.pos = UnityObjectToClipPos(v.vertex);
                //o.pos = pos_clip;
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                o.pos_uv = v.vertex.zy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex,i.pos_uv);
                return col;
            }
            ENDCG
        }
    }
}
