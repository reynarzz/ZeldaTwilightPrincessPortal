//MIT License
//
//Copyright (c) 2019 Reynardo (Reynarz) Perez
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
Shader "Custom/PortalRing"
{
    Properties
    {
		_Color("Ring Color", COLOR) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
		_SecondTex("Texture", 2D) = "white" {}
		[Toggle]_grayScale("GrayScale", int) = 0
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

		Cull Off
        
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
			uniform int _grayScale;

            output vert (float4 vertex : POSITION, float2 uv : TEXCOORD0)
            {
				output o;

                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv;

                return o;
            }

            half4 frag (output i) : COLOR
            {
            	float4 mainTex = tex2D(_MainTex, i.uv);
            	float4 secondTex = tex2D(_SecondTex, i.uv);

				float4 color = mainTex * secondTex * _Color;

				//helper unity function (inside of UnityCG.cginc) for grayscale
				fixed lumn = Luminance(color.rgb);

				//just eliminate the white pixels of the example texture
				if (color.r > 0.8 && color.g > 0.8 && color.b > 0.8)
				{
					color.a = 0;
				}

				if(_grayScale == 1)
				{
					//set the grayscale
					color.rgb = lumn;
				}

				return color;
            }
            ENDCG
        }
    }
}
