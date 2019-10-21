Shader "Custom/ZeldaLikeRing"
{
    Properties
    {
		_Color("Ring Color", COLOR) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
		_SecondTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Stencil
		{
			Ref 1
			Comp Equal
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#include "UnityCG.cginc"
            struct output
            {
				float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

			uniform sampler2D _MainTex;
			uniform sampler2D _SecondTex;
			uniform float4 _Color;

            output vert (float4 vertex : POSITION, float2 uv : TEXCOORD0)
            {
				output o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv;

                return o;
            }

            half4 frag (output i) : COLOR
            {
                // sample the texture
				float4 color = tex2D(_MainTex, i.uv) * tex2D(_SecondTex, i.uv) * _Color;
				fixed lumn = Luminance(color.rgb);

				if (color.r > 0.8 && color.g> 0.8 && color.b > 0.8)
				{
					color.a = 0;
				}
				color.rgb = lumn;

				return color;
            }
            ENDCG
        }
    }
}
