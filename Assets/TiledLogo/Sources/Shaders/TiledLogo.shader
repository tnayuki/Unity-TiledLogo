Shader "Custom/TiledLogo" {
	Properties {
		_MainTex ("Texture 1", 2D) = "white" {}
		_MainTex2 ("Texture 2", 2D) = "white" {}
		_BackgroundColor1 ("Background color 1", Color) = (1, 1, 1, 1)
		_BackgroundColor2 ("Background color 2", Color) = (0, 0.439, 0.764, 1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _MainTex2;
		half3 _BackgroundColor1;
		half3 _BackgroundColor2;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c;
			
			bool p = false;
			if (fmod(IN.uv_MainTex.x * 4, 1) < 0.5) p = !p;
			if (fmod(IN.uv_MainTex.y * 6, 1) < 0.5) p = !p;

			if (p) {
				float4 t = tex2D(_MainTex, float2(fmod(IN.uv_MainTex.x * 8, 1), fmod(IN.uv_MainTex.y * 12, 1)));

				if (t.a > 0) {
					c = float4(_BackgroundColor2 * (1 - t.a), 1) + float4(_BackgroundColor1 * t.a, 1);
				} else {			
					c = float4(_BackgroundColor2, 1);
				}
			} else {
				float4 t = tex2D(_MainTex2, float2(fmod(IN.uv_MainTex.x * 8, 1), fmod(IN.uv_MainTex.y * 12, 1)));
			
				if (t.a > 0) {
					c = float4(_BackgroundColor1 * (1 - t.a), 1) + float4(_BackgroundColor2 * t.a, 1);
				} else {			
					c = float4(_BackgroundColor1, 1);
				}
			}
			
			//o.Albedo = float4(IN.uv_MainTex.x, IN.uv_MainTex.y, 0, 1);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
