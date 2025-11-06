Shader "URP_VertexExtrude"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}  // Texture property
        _Amount ("Extrude", Range(0.0,0.1)) = 0.001  // Extrude amount
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Declare texture and extrusion amount
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float _Amount;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            // Vertex Shader (handles extrusion)
            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // Extrude the vertex position along its normal
                float3 extrudedPosition = IN.positionOS.xyz + IN.normalOS * _Amount;

                // Transform object space to homogeneous clip space
                OUT.positionCS = TransformObjectToHClip(extrudedPosition);

                // Pass UV coordinates to fragment shader
                OUT.uv = IN.uv;

                // Calculate the world-space normal for lighting
                OUT.worldNormal = normalize(TransformObjectToWorldNormal(IN.normalOS));

                return OUT;
            }

            // Fragment Shader (handles texture sampling and lighting)
            half4 frag(Varyings IN) : SV_Target
            {
                // Sample the texture
                half4 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

                // Get the main light direction and color
                Light mainLight = GetMainLight();
                half3 lightDir = normalize(mainLight.direction);
                half3 lightColor = mainLight.color;

                // Calculate diffuse lighting using Lambert's cosine law
                half NdotL = max(dot(IN.worldNormal, lightDir), 0.0);
                // Calculate final color based on diffuse lighting and texture color
                half3 finalColor = albedo.rgb * lightColor * NdotL;

                return half4(finalColor, 1.0); // Output final color
            }

            ENDHLSL
        }
    }
}

