Shader "Connor/TestShader"
{	
Properties
	{
		_BaseMap	("Base Map" , 2D) = "white" {}
		_BaseColor	("Base Color" , Color) = (1,1,1,1)

		//Dropdown to pick which UV set the basemap uses
		[KeywordEnum(UV0, UV1)] _UVSET ("UV Set", Float) = 0

		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range (0.5, 8)) = 3
		_RimStrength ("Rim Strength", Range(0,1)) = 0.5
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
				float3 normalOS		: NORMAL; //added for rim/ fresnel
				float2 uv0			: TEXCOORD0; //Mesh UV Channel 0
				float2 uv1			: TEXCOORD1; //Mesh UV Channel 1
			};

			struct Varyings
			{
				float4 positionHCS	: SV_POSITION;
				float2 uv			: TEXCOORD0; //UV chosen by the dropdown

				float3 positionWS	: TEXCOORD1; // added
				float3 normalWS		: TEXCOORD2; // added
			};

			//Textures and Samplers
			TEXTURE2D(_BaseMap);
			SAMPLER(sampler_BaseMap);

			CBUFFER_START(UnityPerMaterial)
				float4 _BaseColor;
				float4 _BaseMap_ST; //tiling and offset
				float4 _RimColor;
				float _RimPower;
				float _RimStrength;
			CBUFFER_END 

			Varyings vert (Attributes IN)
			{
				Varyings OUT;

				//World Data
				float3 posWS = TransformObjectToWorld(IN.positionOS.xyz); 
				float3 nrmWS = TransformObjectToWorldNormal(IN.normalOS);
				
				OUT.positionWS = posWS;
				OUT.normalWS = nrmWS;
				OUT.positionHCS = TransformObjectToHClip(posWS);

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
				half3 color	  = baseTex.rgb * _BaseColor.rgb;

				// ------ viewDir in URP ------
				//Get Vector from surface point to camera (world space)
				float3 viewDirWS = GetWorldSpaceViewDir(IN.positionWS);
				viewDirWS = SafeNormalize(viewDirWS);

				//Optional: Fresnel / rim using the world-space normal 
				float3 n = SafeNormalize(IN.normalWS);
				float ndotv = saturate(dot(n, viewDirWS));
				float fres = pow(1.0 - ndotv, _RimPower);
				color += (_RimColor.rgb * fres) * _RimStrength;

				return half4(color, 1.0);

			}
			ENDHLSL 
		}

	}
	FallBack Off
}
