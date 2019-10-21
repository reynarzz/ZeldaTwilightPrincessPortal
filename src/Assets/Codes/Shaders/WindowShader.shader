Shader "Custom/ZeldaLikeWindowStencil"
{
    Properties
    {
		_Color("Color", COLOR) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent-1" }
		Blend SrcAlpha OneMinusSrcAlpha
		
		ZWrite Off

		Stencil
		{
			Ref 0
			Comp Equal
			pass IncrWrap
		}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct output
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

			uniform sampler2D _MainTex;
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
				float4 col = tex2D(_MainTex, i.uv);
				return col * _Color;
            }
            ENDCG
        }
    }
}
