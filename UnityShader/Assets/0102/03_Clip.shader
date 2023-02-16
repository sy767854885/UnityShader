// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CS0102/03_Clip"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Cutout("Cutout",Range(-0.1,1.1)) = 0.0
        _Speed("Speed",Vector) = (1,1,0,0)
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
            CGPROGRAM // Shader��������￪ʼ
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
                float2 pos_uv : TEXCOORD1;
            };

           
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Cutout;
            float4 _Speed;
            //����shader
            v2f vert(appdata v)
            {
                v2f o;
                float4 pos_world = mul(unity_ObjectToWorld,v.vertex);//ģ�Ϳռ�ת����ռ�
                float4 pos_view = mul(UNITY_MATRIX_V,pos_world);//����ռ�ת����ռ�
                float4 pos_clip = mul(UNITY_MATRIX_P,pos_view);//ת���ü��ռ�
                //o.pos = UnityObjectToClipPos(v.vertex);
                o.pos = pos_clip;
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                o.pos_uv = pos_world.xz * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }
            //ƬԪshader
            float4 frag(v2f i) : SV_Target
            {
                half gradient = tex2D(_MainTex,i.uv + _Time.y * _Speed.xy).r;
                clip(gradient - _Cutout);
                return gradient.xxxx;
                //return float4(i.uv,0.0,0.0);
            }
            ENDCG //Shader������������
        }
    }
}
