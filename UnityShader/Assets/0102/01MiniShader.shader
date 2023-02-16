Shader "CS0102/01MiniShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "bump" {}
        _Float("Float",Float) = 0.0
        _Range("Range",Range(0.0,1.0)) = 0.0
        _Vector("Vector",Vector) = (1,1,1,1)
        _Color("Color",Color) = (0.5,0.5,0.5,0.5)
        

            
    }
    SubShader
    {
        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;//��һ��uv

            };
           
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;//ͨ�ô����� ��ֵ��
            };

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                float4 pos_world = mul(unity_ObjectToWorld,v.vertex);//ģ�Ϳռ�ת����ռ�
                float4 pos_view = mul(UNITY_MATRIX_V,pos_world);//����ռ�ת����ռ�
                float4 pos_clip = mul(UNITY_MATRIX_P,pos_view);//ת���ü��ռ�
                o.pos = pos_clip;
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex,i.uv);
                return col;
            }
            ENDCG
        }
    }
}