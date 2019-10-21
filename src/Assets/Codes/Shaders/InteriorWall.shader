Shader "Custom/PortalInteriorWall"
{
    Properties
    {
		_Color("Ring Color", COLOR) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
        LOD 100
		Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct output
            {
				float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
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
				return _Color;
            }
            ENDCG
        }
    }
}
