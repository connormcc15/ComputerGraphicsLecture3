Shader "Connor/FirstShaderMultiUV"
{	
Properties
	{
		_BaseMap	("Base Map" , 2D) = "white" {}
		_BaseColor	("Base Color" , Color) = (1,1,1,1)

		//Dropdown to pick which UV set the basemap uses
		[KeywordEnum(UV0, UV1)] _UVSET ("UV Set", Float) = 0
	}

	SubShader
	{
		Tags {"RenderType" = "Opaque" "Queue" = "Geometry" "RenderPipeline" = "UniversalRenderPipeline"}
		LOD 200

		Pass
		{
			Name "Unlit" //(Sampling only; no lighting here)
			Tags { "LightMode"="UniversalForward" }

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// Create keywords that match the [KeywordEnum] above
			#pragma shader_feature_local _UVSET_UV0 _UVSET_UV1

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			// ====== Vertex T/O ======
			struct Attributes
			{
				float4 positionOS	: POSITION;
				float2 uv0			: TEXCOORD0; //Mesh UV Channel 0
				float2 uv1			: TEXCOORD1; //Mesh UV Channel 1
			};

			struct Varyings
			{
				float4 positionHCS	: SV_POSITION;
				float2 uv			: TEXCOORD0; //UV chosen by the dropdown
			};

			//Textures and Samplers
			TEXTURE2D(_BaseMap);
			SAMPLER(sampler_BaseMap);

			CBUFFER_START(UnityPerMaterial)
				float4 _BaseColor;
				float4 _BaseMap_ST; //tiling and offset
			CBUFFER_END 

			Varyings vert (Attributes IN)
			{
				Varyings OUT;
				OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

				// Choose if UV set based on Dropdown
				#if defined(UV_SET_UV1)
					OUT.uv = TRANSFORM_TEX(IN.uv1, _BaseMap);
				#else //default UVSET UV0
					OUT.uv = TRANSFORM_TEX(IN.uv0, _BaseMap);
				#endif

				return OUT;
			}

			half4 frag (Varyings IN) : SV_Target
			{
				half4 baseTex = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
				return half4(baseTex.rgb * _BaseColor.rgb, 1.0);
			}
			ENDHLSL 
		}

	}
	FallBack Off
}
