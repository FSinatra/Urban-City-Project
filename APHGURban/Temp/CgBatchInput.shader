    Shader "FX/Water (kdg) 4" {
    Properties {
        _MainAlpha ("Tansparency", Range(0.0,1.0)) = 0.5
        _WaveScale ("Wave scale", Range (0.02,0.15)) = .07
        _ColorControl ("Reflective color (RGB) fresnel (A) ", 2D) = "" { }
        _ColorControlCube ("Reflective color cube (RGB) fresnel (A) ", Cube) = "" { TexGen CubeReflect }
        _BumpMap ("Waves Normalmap ", 2D) = "" { }
        WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
        _MainTex ("Fallback texture", 2D) = "" { }
       
        _Specular ("Specular", Range (0,1)) = .07
        _Gloss ("Gloss", Range (0,128)) = 1
    }
     
       
    // -----------------------------------------------------------
    // Fragment program
     
    Subshader {
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
       
    CGPROGRAM
            #pragma surface surf SimpleSpecular alpha vertex:vert
            //uniform float4 _horizonColor;
     
            uniform float _MainAlpha;
            uniform float4 WaveSpeed;
            uniform float _WaveScale;
            uniform float4 _WaveOffset;
           
            uniform float _Specular;
            uniform float _Gloss;
           
            sampler2D _BumpMap;
            sampler2D _ColorControl;
            samplerCUBE _ColorControlCube;
           
            #include "UnityCG.cginc"
     
            struct Input {
                 
                 half2 bumpuv0 : TEXCOORD0;
                half2 bumpuv1 : TEXCOORD1;
                half3 vDir : TEXCOORD2;
                half3 worldRefl;
                INTERNAL_DATA
            };
           
            void vert (inout appdata_full v, out Input o) {
                float4 s;
     
                // scroll bump waves
                float4 temp;
                temp.xyzw = v.vertex.xzxz * _WaveScale / unity_Scale.w + _WaveOffset;
                o.bumpuv0 = temp.xy * float2(.4, .45);
                o.bumpuv1 = temp.wz;
     
                // object space view direction
                o.vDir = normalize( ObjSpaceViewDir(v.vertex) ).xzy;
            }
     
            void surf (Input IN, inout SurfaceOutput o) {
             
                half3 bump1 = UnpackNormal(tex2D( _BumpMap, IN.bumpuv0 )).rgb;
                half3 bump2 = UnpackNormal(tex2D( _BumpMap, IN.bumpuv1 )).rgb;
                half3 bump = (bump1 + bump2) * 0.5;
                o.Normal = bump;
                 
                half3 worldRefl = WorldReflectionVector (IN, o.Normal);
                half fresnel = dot( IN.vDir, bump);
                half4 water = tex2D( _ColorControl, float2(fresnel,fresnel) );
                half3 R = IN.vDir - ( 2 * dot(IN.vDir, o.Normal )) * o.Normal;
                half4 reflcol = texCUBE (_ColorControlCube, R);
             
                half4 col;
           
                col.rgb = water.rgb;
                            //make 0.5 into a slider eventually
                col.rgb = lerp( reflcol.rgb, col.rgb, 0.5 );
               
                col.a = _MainAlpha;
               
                o.Albedo = 0.0;
               
                o.Alpha = col.a;
                o.Emission = col;
            }
           
            half4 LightingSimpleSpecular (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
            {
                        half3 h = normalize (lightDir + viewDir);
     
                        half diff = max (0, dot (s.Normal, lightDir));
     
                        float nh = max (0, dot (s.Normal, h));
                        float spec = pow (nh, _Gloss);
             
                         half4 c;
                        c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * (atten * 2) * _Specular;
                        //I have alpha set to 1 for debugging. Really it doesn't seem to matter what I put here
                        c.a = 1;
                        return c;
                        }
            ENDCG
    }
     
    // -----------------------------------------------------------
    //  Old cards (you can ignore anything below here)
     
    // three texture, cubemaps
    Subshader {
        //Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Pass {
            Color (0.5,0.5,0.5,0.5)
            SetTexture [_MainTex] {
                Matrix [_WaveMatrix]
                combine texture * primary
            }
            SetTexture [_MainTex] {
                Matrix [_WaveMatrix2]
                combine texture * primary + previous
            }
            SetTexture [_ColorControlCube] {
                combine texture +- previous, primary
                Matrix [_Reflection]
            }
        }
    }
     
    // dual texture, cubemaps
    Subshader {
        //Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Pass {
            Color (0.5,0.5,0.5,0.5)
            SetTexture [_MainTex] {
                Matrix [_WaveMatrix]
                combine texture
            }
            SetTexture [_ColorControlCube] {
                combine texture +- previous, primary
                Matrix [_Reflection]
            }
        }
    }
     
    // single texture
    Subshader {
        //Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "RenderType"="Transparent"}
        Pass {
            Color (0.5,0.5,0.5,0)
            SetTexture [_MainTex] {
                Matrix [_WaveMatrix]
                combine texture, primary
            }
        }
    }
     
    }