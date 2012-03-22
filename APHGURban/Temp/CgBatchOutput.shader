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
       
    	Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 3
//   opengl - ALU: 19 to 81
//   d3d9 - ALU: 19 to 84
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Float 23 [_WaveScale]
Vector 24 [_WaveOffset]
"!!ARBvp1.0
# 50 ALU
PARAM c[25] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MOV R0.w, c[0].z;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.w, R2, R2;
MAD R0.w, R0.x, R0.x, -R0;
DP4 R0.z, R1, c[21];
DP4 R0.y, R1, c[20];
DP4 R0.x, R1, c[19];
ADD R0.xyz, R2, R0;
MUL R1.xyz, R0.w, c[22];
ADD result.texcoord[4].xyz, R0, R1;
MOV R1.w, c[0].z;
MOV R1.xyz, c[14];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[13].w, -vertex.position;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[15];
MUL R2.xyz, R2, vertex.attrib[14].w;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.y, R1, c[10];
DP4 R3.x, R1, c[9];
RCP R0.w, c[13].w;
MUL R1.xy, vertex.position.xzzw, c[23].x;
MAD R1, R1.xyxy, R0.w, c[24];
DP3 result.texcoord[3].y, R3, R2;
DP3 result.texcoord[5].y, R0, R2;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, R3, vertex.attrib[14];
DP3 result.texcoord[5].z, R0, vertex.normal;
DP3 result.texcoord[5].x, R0, vertex.attrib[14];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 50 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Float 22 [_WaveScale]
Vector 23 [_WaveOffset]
"vs_2_0
; 53 ALU
def c24, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mul r1.xyz, v2, c12.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
mov r0.y, r2.w
dp3 r0.z, r1, c6
mov r0.w, c24.z
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c17
dp4 r2.y, r0, c16
dp4 r2.x, r0, c15
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c20
dp4 r0.y, r1, c19
dp4 r0.x, r1, c18
add r0.xyz, r2, r0
mul r1.xyz, r0.w, c21
add oT4.xyz, r0, r1
mov r1.w, c24.z
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c12.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c9
dp4 r4.y, c14, r0
dp3 r2.w, r2, r2
rsq r0.x, r2.w
mov r1, c8
dp4 r4.x, c14, r1
mul oT2.xyz, r0.x, r2.xzyw
rcp r0.z, c12.w
mul r0.xy, v0.xzzw, c22.x
mad r0, r0.xyxy, r0.z, c23
dp3 oT3.y, r4, r3
dp3 oT5.y, r2, r3
dp3 oT3.z, v2, r4
dp3 oT3.x, r4, v1
dp3 oT5.z, r2, v2
dp3 oT5.x, r2, v1
mul oT0.xy, r0, c24
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp mat3 tmpvar_13;
  tmpvar_13[0] = tmpvar_1.xyz;
  tmpvar_13[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_13[2] = tmpvar_2;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal;
  normal = tmpvar_17;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAr, normal);
  x1.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAg, normal);
  x1.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAb, normal);
  x1.z = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBr, tmpvar_22);
  x2.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBg, tmpvar_22);
  x2.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBb, tmpvar_22);
  x2.z = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (unity_SHC.xyz * vC);
  x3 = tmpvar_27;
  tmpvar_18 = ((x1 + x2) + x3);
  shlight = tmpvar_18;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (tmpvar_14 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD2, tmpvar_6);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = tmpvar_7;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_ColorControl, tmpvar_8);
  water = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_ColorControlCube, tmpvar_10);
  reflcol = tmpvar_11;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_12;
  tmpvar_12 = col.w;
  tmpvar_3 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = col.xyz;
  tmpvar_2 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD5);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (tmpvar_1, normalize ((lightDir + viewDir))));
  nh = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_16;
  c_i0.w = 1.0;
  c = c_i0;
  c.xyz = c.xyz;
  c.xyz = (c.xyz + tmpvar_2);
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp mat3 tmpvar_13;
  tmpvar_13[0] = tmpvar_1.xyz;
  tmpvar_13[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_13[2] = tmpvar_2;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_18;
  mediump vec4 normal;
  normal = tmpvar_17;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAr, normal);
  x1.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAg, normal);
  x1.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAb, normal);
  x1.z = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBr, tmpvar_22);
  x2.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBg, tmpvar_22);
  x2.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBb, tmpvar_22);
  x2.z = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (unity_SHC.xyz * vC);
  x3 = tmpvar_27;
  tmpvar_18 = ((x1 + x2) + x3);
  shlight = tmpvar_18;
  tmpvar_4 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (tmpvar_14 * (((_World2Object * tmpvar_16).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_4;
  mediump float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD2, tmpvar_4);
  mediump vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5;
  tmpvar_6.y = tmpvar_5;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ColorControl, tmpvar_6);
  water = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_ColorControlCube, tmpvar_8);
  reflcol = tmpvar_9;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_10;
  tmpvar_10 = col.w;
  tmpvar_3 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = col.xyz;
  tmpvar_2 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD5);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_1, normalize ((lightDir + viewDir))));
  nh = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_14;
  c_i0.w = 1.0;
  c = c_i0;
  c.xyz = c.xyz;
  c.xyz = (c.xyz + tmpvar_2);
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Float 22 [_WaveScale]
Vector 23 [_WaveOffset]
"agal_vs
c24 0.4 0.45 1.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaacaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c5
bcaaaaaaaaaaabacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.x, r1.xyzz, c4
aaaaaaaaaaaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.w
bcaaaaaaaaaaaeacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r0.z, r1.xyzz, c6
aaaaaaaaaaaaaiacbiaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c24.z
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
bdaaaaaaacaaaeacaaaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r2.z, r0, c17
bdaaaaaaacaaacacaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r2.y, r0, c16
bdaaaaaaacaaabacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r2.x, r0, c15
adaaaaaaaaaaaiacacaaaappacaaaaaaacaaaappacaaaaaa mul r0.w, r2.w, r2.w
adaaaaaaadaaaiacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r3.w, r0.x, r0.x
acaaaaaaaaaaaiacadaaaappacaaaaaaaaaaaappacaaaaaa sub r0.w, r3.w, r0.w
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r0.z, r1, c20
bdaaaaaaaaaaacacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r0.y, r1, c19
bdaaaaaaaaaaabacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.x, r1, c18
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabfaaaaoeabaaaaaa mul r1.xyz, r0.w, c21
abaaaaaaaeaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r0.xyzz, r1.xyzz
aaaaaaaaabaaaiacbiaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c24.z
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaaeaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r4.xyz, r0.xyzz, c12.w
acaaaaaaacaaahacaeaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r4.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaafaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r5.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacaoaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c14, r0
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
bdaaaaaaaeaaacacaoaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c14, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r2.w
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bdaaaaaaaeaaabacaoaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c14, r1
adaaaaaaacaaahaeaaaaaaaaacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.x, r2.xzyy
aaaaaaaaafaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5, c12
afaaaaaaaaaaaeacafaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r5.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaabgaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c22.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa add r0, r0, c23
bcaaaaaaadaaacaeaeaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r4.xyzz, r3.xyzz
bcaaaaaaafaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v5.y, r2.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 v3.z, a1, r4.xyzz
bcaaaaaaadaaabaeaeaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r4.xyzz, a5
bcaaaaaaafaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v5.z, r2.xyzz, a1
bcaaaaaaafaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v5.x, r2.xyzz, a5
adaaaaaaaaaaadaeaaaaaafeacaaaaaabiaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c24
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Float 16 [_WaveScale]
Vector 17 [_WaveOffset]
Vector 18 [unity_LightmapST]
"!!ARBvp1.0
# 19 ALU
PARAM c[19] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].z;
MOV R1.xyz, c[14];
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R1.xyz, R0, c[13].w, -vertex.position;
DP3 R0.x, R1, R1;
RSQ R1.w, R0.x;
RCP R0.z, c[13].w;
MUL R0.xy, vertex.position.xzzw, c[16].x;
MAD R0, R0.xyxy, R0.z, c[17];
MUL result.texcoord[2].xyz, R1.w, R1.xzyw;
MUL result.texcoord[0].xy, R0, c[0];
MOV result.texcoord[1].xy, R0.wzzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[18], c[18].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Float 14 [_WaveScale]
Vector 15 [_WaveOffset]
Vector 16 [unity_LightmapST]
"vs_2_0
; 19 ALU
def c17, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_texcoord1 v3
mov r1.w, c17.z
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c12.w, -v0
dp3 r0.x, r1, r1
rsq r1.w, r0.x
rcp r0.z, c12.w
mul r0.xy, v0.xzzw, c14.x
mad r0, r0.xyxy, r0.z, c15
mul oT2.xyz, r1.w, r1.xzyw
mul oT0.xy, r0, c17
mov oT1.xy, r0.wzzw
mad oT3.xy, v3, c16, c16.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec2 tmpvar_1;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_4;
  tmpvar_4 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_1 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = temp.wz;
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _MainAlpha;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD2, tmpvar_6);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = tmpvar_7;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_ColorControl, tmpvar_8);
  water = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_ColorControlCube, tmpvar_10);
  reflcol = tmpvar_11;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_12;
  tmpvar_12 = col.w;
  tmpvar_3 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = col.xyz;
  tmpvar_2 = tmpvar_13;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = vec3(0.0, 0.0, 0.0);
  c.w = tmpvar_3;
  c.xyz = tmpvar_2;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec2 tmpvar_1;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_4;
  tmpvar_4 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_1 = tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = temp.wz;
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize ((((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_3 = tmpvar_7;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _MainAlpha;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_4;
  mediump float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD2, tmpvar_4);
  mediump vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5;
  tmpvar_6.y = tmpvar_5;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ColorControl, tmpvar_6);
  water = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_ColorControlCube, tmpvar_8);
  reflcol = tmpvar_9;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_10;
  tmpvar_10 = col.w;
  tmpvar_3 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = col.xyz;
  tmpvar_2 = tmpvar_11;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = vec3(0.0, 0.0, 0.0);
  c.w = tmpvar_3;
  c.xyz = tmpvar_2;
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Float 14 [_WaveScale]
Vector 15 [_WaveOffset]
Vector 16 [unity_LightmapST]
"agal_vs
c17 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacbbaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c17.z
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaabaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r2.xyzz, a0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaabaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r0.x
aaaaaaaaacaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2, c12
afaaaaaaaaaaaeacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r2.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaaaoaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c14.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa add r0, r0, c15
adaaaaaaacaaahaeabaaaappacaaaaaaabaaaafiacaaaaaa mul v2.xyz, r1.w, r1.xzyy
adaaaaaaaaaaadaeaaaaaafeacaaaaaabbaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c17
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
adaaaaaaacaaadacaeaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r2.xy, a4, c16
abaaaaaaadaaadaeacaaaafeacaaaaaabaaaaaooabaaaaaa add v3.xy, r2.xyyy, c16.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Float 31 [_WaveScale]
Vector 32 [_WaveOffset]
"!!ARBvp1.0
# 81 ALU
PARAM c[33] = { { 0.40000001, 0.44999999, 1, 0 },
		state.matrix.mvp,
		program.local[5..32] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[13].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].z;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].z;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].w;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[30];
MOV R1.w, c[0].z;
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
ADD R0.xyz, R2, R0;
ADD result.texcoord[4].xyz, R0, R1;
MOV R1.xyz, c[14];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[13].w, -vertex.position;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[15];
MUL R2.xyz, R2, vertex.attrib[14].w;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.y, R1, c[10];
DP4 R3.x, R1, c[9];
RCP R0.w, c[13].w;
MUL R1.xy, vertex.position.xzzw, c[31].x;
MAD R1, R1.xyxy, R0.w, c[32];
DP3 result.texcoord[3].y, R3, R2;
DP3 result.texcoord[5].y, R0, R2;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, R3, vertex.attrib[14];
DP3 result.texcoord[5].z, R0, vertex.normal;
DP3 result.texcoord[5].x, R0, vertex.attrib[14];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 81 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Float 30 [_WaveScale]
Vector 31 [_WaveOffset]
"vs_2_0
; 84 ALU
def c32, 0.40000001, 0.44999999, 1.00000000, 0.00000000
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mul r3.xyz, v2, c12.w
dp4 r0.x, v0, c5
add r1, -r0.x, c16
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c15
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c32.z
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c17
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c18
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c32.z
dp4 r2.z, r4, c25
dp4 r2.y, r4, c24
dp4 r2.x, r4, c23
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c32.w
mul r0, r0, r1
mul r1.xyz, r0.y, c20
mad r1.xyz, r0.x, c19, r1
mad r0.xyz, r0.z, c21, r1
mad r1.xyz, r0.w, c22, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c28
dp4 r3.y, r0, c27
dp4 r3.x, r0, c26
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c29
add r2.xyz, r2, r3
add r0.xyz, r2, r0
add oT4.xyz, r0, r1
mov r1.w, c32.z
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c12.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c14, r0
mov r0, c8
dp4 r4.x, c14, r0
dp3 r2.w, r2, r2
rsq r0.x, r2.w
mov r1, c9
dp4 r4.y, c14, r1
mul oT2.xyz, r0.x, r2.xzyw
rcp r0.z, c12.w
mul r0.xy, v0.xzzw, c30.x
mad r0, r0.xyxy, r0.z, c31
dp3 oT3.y, r4, r3
dp3 oT5.y, r2, r3
dp3 oT3.z, v2, r4
dp3 oT3.x, r4, v1
dp3 oT5.z, r2, v2
dp3 oT5.x, r2, v1
mul oT0.xy, r0, c32
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp mat3 tmpvar_14;
  tmpvar_14[0] = tmpvar_1.xyz;
  tmpvar_14[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_14[2] = tmpvar_2;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal;
  normal = tmpvar_18;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal);
  x1.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal);
  x1.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal);
  x1.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC);
  x3 = tmpvar_28;
  tmpvar_19 = ((x1 + x2) + x3);
  shlight = tmpvar_19;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  highp vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  highp vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_30 * tmpvar_13.x) + (tmpvar_31 * tmpvar_13.y)) + (tmpvar_32 * tmpvar_13.z)) * inversesqrt (tmpvar_33))) * (1.0/((1.0 + (tmpvar_33 * unity_4LightAtten0)))));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  tmpvar_4 = tmpvar_35;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (tmpvar_15 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_6;
  mediump float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD2, tmpvar_6);
  mediump vec2 tmpvar_8;
  tmpvar_8.x = tmpvar_7;
  tmpvar_8.y = tmpvar_7;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_ColorControl, tmpvar_8);
  water = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_ColorControlCube, tmpvar_10);
  reflcol = tmpvar_11;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_12;
  tmpvar_12 = col.w;
  tmpvar_3 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = col.xyz;
  tmpvar_2 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (xlv_TEXCOORD5);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 viewDir;
  viewDir = tmpvar_14;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (tmpvar_1, normalize ((lightDir + viewDir))));
  nh = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_16;
  c_i0.w = 1.0;
  c = c_i0;
  c.xyz = c.xyz;
  c.xyz = (c.xyz + tmpvar_2);
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  highp vec3 shlight;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = _Object2World[0].xyz;
  tmpvar_12[1] = _Object2World[1].xyz;
  tmpvar_12[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (tmpvar_2 * unity_Scale.w));
  highp mat3 tmpvar_14;
  tmpvar_14[0] = tmpvar_1.xyz;
  tmpvar_14[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_14[2] = tmpvar_2;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_13;
  mediump vec3 tmpvar_19;
  mediump vec4 normal;
  normal = tmpvar_18;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal);
  x1.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal);
  x1.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal);
  x1.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC);
  x3 = tmpvar_28;
  tmpvar_19 = ((x1 + x2) + x3);
  shlight = tmpvar_19;
  tmpvar_4 = shlight;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  highp vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  highp vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_30 * tmpvar_13.x) + (tmpvar_31 * tmpvar_13.y)) + (tmpvar_32 * tmpvar_13.z)) * inversesqrt (tmpvar_33))) * (1.0/((1.0 + (tmpvar_33 * unity_4LightAtten0)))));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_4 + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  tmpvar_4 = tmpvar_35;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (tmpvar_15 * (((_World2Object * tmpvar_17).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp float tmpvar_3;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_4;
  mediump float tmpvar_5;
  tmpvar_5 = dot (xlv_TEXCOORD2, tmpvar_4);
  mediump vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5;
  tmpvar_6.y = tmpvar_5;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_ColorControl, tmpvar_6);
  water = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_ColorControlCube, tmpvar_8);
  reflcol = tmpvar_9;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_10;
  tmpvar_10 = col.w;
  tmpvar_3 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = col.xyz;
  tmpvar_2 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD5);
  mediump vec3 lightDir;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 viewDir;
  viewDir = tmpvar_12;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_1, normalize ((lightDir + viewDir))));
  nh = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_14;
  c_i0.w = 1.0;
  c = c_i0;
  c.xyz = c.xyz;
  c.xyz = (c.xyz + tmpvar_2);
  c.w = tmpvar_3;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Float 30 [_WaveScale]
Vector 31 [_WaveOffset]
"agal_vs
c32 0.4 0.45 1.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r3.xyz, a1, c12.w
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.x, a0, c5
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
abaaaaaaabaaapacabaaaaaaacaaaaaabaaaaaoeabaaaaaa add r1, r1.x, c16
bcaaaaaaadaaaiacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r3.xyzz, c5
bcaaaaaaaeaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c4
bcaaaaaaadaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.x, r3.xyzz, c6
adaaaaaaacaaapacadaaaappacaaaaaaabaaaaoeacaaaaaa mul r2, r3.w, r1
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaapacaaaaaaaaacaaaaaaapaaaaoeabaaaaaa add r0, r0.x, c15
adaaaaaaabaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r1, r1, r1
aaaaaaaaaeaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r4.z, r3.x
adaaaaaaafaaapacaeaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r5, r4.x, r0
abaaaaaaacaaapacafaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r5, r2
aaaaaaaaaeaaaiaccaaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r4.w, c32.z
bdaaaaaaaeaaacacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.y, a0, c6
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
bfaaaaaaaaaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r4.y
abaaaaaaaaaaapacaaaaaaffacaaaaaabbaaaaoeabaaaaaa add r0, r0.y, c17
adaaaaaaafaaapacaaaaaaoeacaaaaaaaaaaaaoeacaaaaaa mul r5, r0, r0
abaaaaaaabaaapacafaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r5, r1
adaaaaaaaaaaapacadaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r0, r3.x, r0
abaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa add r0, r0, r2
adaaaaaaacaaapacabaaaaoeacaaaaaabcaaaaoeabaaaaaa mul r2, r1, c18
aaaaaaaaaeaaacacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r3.w
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r1.y, r1.y
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
akaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.z, r1.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
abaaaaaaabaaapacacaaaaoeacaaaaaacaaaaakkabaaaaaa add r1, r2, c32.z
bdaaaaaaacaaaeacaeaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r2.z, r4, c25
bdaaaaaaacaaacacaeaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r2.y, r4, c24
bdaaaaaaacaaabacaeaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r2.x, r4, c23
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaacaaaaappabaaaaaa max r0, r0, c32.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabeaaaaoeabaaaaaa mul r1.xyz, r0.y, c20
adaaaaaaafaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r5.xyz, r0.x, c19
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabfaaaaoeabaaaaaa mul r0.xyz, r0.z, c21
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaahacaaaaaappacaaaaaabgaaaaoeabaaaaaa mul r1.xyz, r0.w, c22
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaaaaaapacaeaaaakeacaaaaaaaeaaaacjacaaaaaa mul r0, r4.xyzz, r4.yzzx
adaaaaaaabaaaiacadaaaappacaaaaaaadaaaappacaaaaaa mul r1.w, r3.w, r3.w
bdaaaaaaadaaaeacaaaaaaoeacaaaaaabmaaaaoeabaaaaaa dp4 r3.z, r0, c28
bdaaaaaaadaaacacaaaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r3.y, r0, c27
bdaaaaaaadaaabacaaaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r3.x, r0, c26
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaabaaaappacaaaaaa sub r1.w, r5.w, r1.w
adaaaaaaaaaaahacabaaaappacaaaaaabnaaaaoeabaaaaaa mul r0.xyz, r1.w, c29
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaeaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v4.xyz, r0.xyzz, r1.xyzz
aaaaaaaaabaaaiaccaaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c32.z
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaafaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r5.xyz, r0.xyzz, c12.w
acaaaaaaacaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r5.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaafaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r5.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacaoaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c14, r0
aaaaaaaaaaaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c8
bdaaaaaaaeaaabacaoaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.x, c14, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r2.w
aaaaaaaaabaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c9
bdaaaaaaaeaaacacaoaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.y, c14, r1
adaaaaaaacaaahaeaaaaaaaaacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.x, r2.xzyy
aaaaaaaaafaaapacamaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r5, c12
afaaaaaaaaaaaeacafaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r5.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaaboaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c30.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabpaaaaoeabaaaaaa add r0, r0, c31
bcaaaaaaadaaacaeaeaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r4.xyzz, r3.xyzz
bcaaaaaaafaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v5.y, r2.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 v3.z, a1, r4.xyzz
bcaaaaaaadaaabaeaeaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r4.xyzz, a5
bcaaaaaaafaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v5.z, r2.xyzz, a1
bcaaaaaaafaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v5.x, r2.xyzz, a5
adaaaaaaaaaaadaeaaaaaafeacaaaaaacaaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c32
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 24 to 38, TEX: 4 to 4
//   d3d9 - ALU: 24 to 41, TEX: 4 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 38 ALU, 4 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.yw, fragment.texcoord[0], texture[0], 2D;
TEX R1.yw, fragment.texcoord[1], texture[0], 2D;
MAD R0.xy, R0.wyzw, c[4].x, -c[4].y;
MAD R1.xy, R1.wyzw, c[4].x, -c[4].y;
MUL R0.w, R1.y, R1.y;
MUL R0.z, R0.y, R0.y;
MAD R0.w, -R1.x, R1.x, -R0;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.w, R0, c[4].y;
RSQ R0.w, R0.w;
RCP R1.z, R0.w;
ADD R0.z, R0, c[4].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
ADD R0.xyz, R0, R1;
MUL R2.xyz, R0, c[4].z;
DP3 R0.x, R2, fragment.texcoord[2];
MUL R1.xyz, R2, R0.x;
MAD R1.xyz, -R1, c[4].x, fragment.texcoord[2];
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
RSQ R0.w, R0.w;
MOV R3.xyz, fragment.texcoord[3];
MAD R3.xyz, R0.w, fragment.texcoord[5], R3;
DP3 R0.w, R3, R3;
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, R3;
DP3 R0.w, R2, R3;
MAX R0.w, R0, c[4];
POW R0.w, R0.w, c[3].x;
MUL R2.xyz, R0.w, c[0];
MUL R2.xyz, R2, c[2].x;
MOV result.color.w, c[1].x;
TEX R1.xyz, R1, texture[2], CUBE;
TEX R0.xyz, R0.x, texture[1], 2D;
ADD R0.xyz, R0, -R1;
MAD R0.xyz, R0, c[4].z, R1;
MUL R1.xyz, R2, c[4].x;
ADD result.color.xyz, R1, R0;
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"ps_2_0
; 41 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t5.xyz
texld r1, t1, s0
texld r0, t0, s0
mov r0.x, r0.w
mad_pp r3.xy, r0, c4.x, c4.y
mov r1.x, r1.w
mad_pp r2.xy, r1, c4.x, c4.y
mul_pp r1.x, r2.y, r2.y
mul_pp r0.x, r3.y, r3.y
mad_pp r1.x, -r2, r2, -r1
mad_pp r0.x, -r3, r3, -r0
add_pp r1.x, r1, c4.z
rsq_pp r1.x, r1.x
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r1.x
rcp_pp r3.z, r0.x
add_pp r0.xyz, r3, r2
mul_pp r3.xyz, r0, c4.w
dp3_pp r0.x, r3, t2
mul_pp r1.xyz, r3, r0.x
mov r0.xy, r0.x
mad_pp r1.xyz, -r1, c4.x, t2
mov_pp r4.xyz, t3
mov_pp r0.w, c1.x
texld r2, r0, s1
texld r1, r1, s2
dp3_pp r0.x, t5, t5
rsq_pp r0.x, r0.x
mad_pp r4.xyz, r0.x, t5, r4
dp3_pp r0.x, r4, r4
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, r4
dp3_pp r0.x, r3, r0
max_pp r0.x, r0, c5
pow r3.x, r0.x, c3.x
mov r0.x, r3.x
mul r0.xyz, r0.x, c0
mul r0.xyz, r0, c2.x
add_pp r2.xyz, r2, -r1
mad_pp r1.xyz, r2, c4.w, r1
mul r0.xyz, r0, c4.x
add_pp r0.xyz, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 0.0 0.0 0.0
[bc]
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaadaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r0.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaffabaaaaaa add r3.xy, r3.xyyy, c4.y
aaaaaaaaabaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r1.w
adaaaaaaacaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r1.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaabaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r1.x, r2.y, r2.y
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaabaaabacacaaaappacaaaaaaabaaaaaaacaaaaaa sub r1.x, r2.w, r1.x
bfaaaaaaadaaaiacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r3.x
adaaaaaaadaaaiacadaaaappacaaaaaaadaaaaaaacaaaaaa mul r3.w, r3.w, r3.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.w, r0.x
abaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaakkabaaaaaa add r1.x, r1.x, c4.z
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r1.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
abaaaaaaaaaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r3.xyzz, r2.xyzz
adaaaaaaadaaahacaaaaaakeacaaaaaaaeaaaappabaaaaaa mul r3.xyz, r0.xyzz, c4.w
bcaaaaaaaaaaabacadaaaakeacaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, r3.xyzz, v2
adaaaaaaabaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r0.x
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
bfaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r1.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c4.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeaeaaaaaa add r1.xyz, r1.xyzz, v2
aaaaaaaaaeaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, v3
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
ciaaaaaaacaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r2, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaabaaapacabaaaageacaaaaaaacaaaaaaafbababb tex r1, r1.xyzy, s2 <cube wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaafaaahacaaaaaaaaacaaaaaaafaaaaoeaeaaaaaa mul r5.xyz, r0.x, v5
abaaaaaaaeaaahacafaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r5.xyzz, r4.xyzz
bcaaaaaaaaaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r0.x, r4.xyzz, r4.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r0.x, r4.xyzz
bcaaaaaaaaaaabacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.x, r3.xyzz, r0.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaadaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r3, r0.x, c3.x
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.x, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
acaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa sub r2.xyz, r2.xyzz, r1.xyzz
adaaaaaaafaaahacacaaaakeacaaaaaaaeaaaappabaaaaaa mul r5.xyz, r2.xyzz, c4.w
abaaaaaaabaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r5.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Float 0 [_MainAlpha]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 24 ALU, 4 TEX
PARAM c[2] = { program.local[0],
		{ 2, 1, 0.5 } };
TEMP R0;
TEMP R1;
TEX R0.yw, fragment.texcoord[1], texture[0], 2D;
TEX R1.yw, fragment.texcoord[0], texture[0], 2D;
MAD R0.xy, R0.wyzw, c[1].x, -c[1].y;
MAD R1.xy, R1.wyzw, c[1].x, -c[1].y;
MUL R0.w, R0.y, R0.y;
MUL R0.z, R1.y, R1.y;
MAD R0.w, -R0.x, R0.x, -R0;
MAD R0.z, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[1].y;
RSQ R1.z, R0.w;
ADD R0.z, R0, c[1].y;
RSQ R0.w, R0.z;
RCP R0.z, R1.z;
RCP R1.z, R0.w;
ADD R0.xyz, R1, R0;
MUL R1.xyz, R0, c[1].z;
DP3 R0.x, fragment.texcoord[2], R1;
MUL R1.xyz, R0.x, R1;
MAD R1.xyz, -R1, c[1].x, fragment.texcoord[2];
MOV result.color.w, c[0].x;
TEX R1.xyz, R1, texture[2], CUBE;
TEX R0.xyz, R0.x, texture[1], 2D;
ADD R0.xyz, R0, -R1;
MAD result.color.xyz, R0, c[1].z, R1;
END
# 24 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Float 0 [_MainAlpha]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"ps_2_0
; 24 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c1, 2.00000000, -1.00000000, 1.00000000, 0.50000000
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r1, t1, s0
texld r0, t0, s0
mov r1.x, r1.w
mad_pp r2.xy, r1, c1.x, c1.y
mov r0.x, r0.w
mad_pp r3.xy, r0, c1.x, c1.y
mul_pp r1.x, r2.y, r2.y
mad_pp r1.x, -r2, r2, -r1
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
add_pp r1.x, r1, c1.z
rsq_pp r1.x, r1.x
add_pp r0.x, r0, c1.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r1.x
rcp_pp r3.z, r0.x
add_pp r0.xyz, r3, r2
mul_pp r1.xyz, r0, c1.w
dp3_pp r0.x, t2, r1
mul_pp r1.xyz, r0.x, r1
mad_pp r2.xyz, -r1, c1.x, t2
mov r1.xy, r0.x
texld r0, r2, s2
texld r1, r1, s1
add_pp r1.xyz, r1, -r0
mad_pp r0.xyz, r1, c1.w, r0
mov_pp r0.w, c0.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Float 0 [_MainAlpha]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_ColorControl] 2D
SetTexture 2 [_ColorControlCube] CUBE
"agal_ps
c1 2.0 -1.0 1.0 0.5
[bc]
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
aaaaaaaaabaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r1.w
adaaaaaaacaaadacabaaaafeacaaaaaaabaaaaaaabaaaaaa mul r2.xy, r1.xyyy, c1.x
abaaaaaaacaaadacacaaaafeacaaaaaaabaaaaffabaaaaaa add r2.xy, r2.xyyy, c1.y
aaaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r0.w
adaaaaaaadaaadacaaaaaafeacaaaaaaabaaaaaaabaaaaaa mul r3.xy, r0.xyyy, c1.x
abaaaaaaadaaadacadaaaafeacaaaaaaabaaaaffabaaaaaa add r3.xy, r3.xyyy, c1.y
adaaaaaaabaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r1.x, r2.y, r2.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaabaaabacacaaaappacaaaaaaabaaaaaaacaaaaaa sub r1.x, r2.w, r1.x
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaadaaaiacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r3.x
adaaaaaaadaaaiacadaaaappacaaaaaaadaaaaaaacaaaaaa mul r3.w, r3.w, r3.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.w, r0.x
abaaaaaaabaaabacabaaaaaaacaaaaaaabaaaakkabaaaaaa add r1.x, r1.x, c1.z
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaakkabaaaaaa add r0.x, r0.x, c1.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r1.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
abaaaaaaaaaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r3.xyzz, r2.xyzz
adaaaaaaabaaahacaaaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r0.xyzz, c1.w
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r0.x, v2, r1.xyzz
adaaaaaaabaaahacaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.x, r1.xyzz
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaaaabaaaaaa mul r2.xyz, r2.xyzz, c1.x
abaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeaeaaaaaa add r2.xyz, r2.xyzz, v2
aaaaaaaaabaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, r0.x
ciaaaaaaaaaaapacacaaaageacaaaaaaacaaaaaaafbababb tex r0, r2.xyzy, s2 <cube wrap linear point>
ciaaaaaaabaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r1, r1.xyyy, s1 <2d wrap linear point>
acaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa sub r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappabaaaaaa mul r1.xyz, r1.xyzz, c1.w
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaaiacaaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c0.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 32 to 41
//   d3d9 - ALU: 35 to 44
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 20 [_WaveScale]
Vector 21 [_WaveOffset]
"!!ARBvp1.0
# 40 ALU
PARAM c[22] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[0].z;
MOV R1.xyz, c[18];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, R0, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[19];
MUL R2.xyz, R2, vertex.attrib[14].w;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[4].y, R0, R2;
DP3 result.texcoord[4].z, R0, vertex.normal;
DP3 result.texcoord[4].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[3].y, R1, R2;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
RCP R0.w, c[17].w;
MUL R1.xy, vertex.position.xzzw, c[20].x;
MAD R1, R1.xyxy, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"vs_2_0
; 43 ALU
def c21, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mov r1.w, c21.z
mov r1.xyz, c17
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
mov r1, c8
dp4 r4.y, c18, r0
dp3 r2.w, r2, r2
rsq r0.w, r2.w
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 oT3.y, r0, r3
dp3 oT3.z, v2, r0
dp3 oT3.x, r0, v1
mul oT2.xyz, r0.w, r2.xzyw
rcp r0.z, c16.w
mul r0.xy, v0.xzzw, c19.x
mad r0, r0.xyxy, r0.z, c20
mul oT0.xy, r0, c21
mov oT1.xy, r0.wzzw
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT4.y, r2, r3
dp3 oT4.z, r2, v2
dp3 oT4.x, r2, v1
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_4;
  mediump vec3 tmpvar_5;
  tmpvar_5 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD2, tmpvar_5);
  mediump vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6;
  tmpvar_7.y = tmpvar_6;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ColorControl, tmpvar_7);
  water = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_10;
  tmpvar_10 = textureCube (_ColorControlCube, tmpvar_9);
  reflcol = tmpvar_10;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_11;
  tmpvar_11 = col.w;
  tmpvar_2 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTexture0, tmpvar_13);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_14.w;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_15;
  tmpvar_15 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_16;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_3;
  tmpvar_3 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_3;
  mediump float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD2, tmpvar_3);
  mediump vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = tmpvar_4;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ColorControl, tmpvar_5);
  water = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_ColorControlCube, tmpvar_7);
  reflcol = tmpvar_8;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_9;
  tmpvar_9 = col.w;
  tmpvar_2 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTexture0, tmpvar_11);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_12.w;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_14;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"agal_vs
c21 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacbfaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c21.z
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r2.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c18, r0
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bdaaaaaaaeaaacacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c18, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r2.w
bdaaaaaaaeaaabacbcaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c18, r1
adaaaaaaabaaahacaeaaaakeacaaaaaabaaaaappabaaaaaa mul r1.xyz, r4.xyzz, c16.w
acaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r1.xyzz, a0
bcaaaaaaadaaacaeaaaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r0.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeaaaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r0.xyzz, a5
adaaaaaaacaaahaeaaaaaappacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.w, r2.xzyy
aaaaaaaaabaaapacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c16
afaaaaaaaaaaaeacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r1.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaabdaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c19.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa add r0, r0, c20
adaaaaaaaaaaadaeaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c21
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bcaaaaaaaeaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v4.y, r2.xyzz, r3.xyzz
bcaaaaaaaeaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v4.z, r2.xyzz, a1
bcaaaaaaaeaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v4.x, r2.xyzz, a5
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 9 [unity_Scale]
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Float 12 [_WaveScale]
Vector 13 [_WaveOffset]
"!!ARBvp1.0
# 32 ALU
PARAM c[14] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[0].z;
MOV R1.xyz, c[10];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
MAD R0.xyz, R0, c[9].w, -vertex.position;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[11];
MUL R2.xyz, R2, vertex.attrib[14].w;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[7];
DP4 R3.y, R1, c[6];
DP4 R3.x, R1, c[5];
RCP R0.w, c[9].w;
MUL R1.xy, vertex.position.xzzw, c[12].x;
MAD R1, R1.xyxy, R0.w, c[13];
DP3 result.texcoord[3].y, R3, R2;
DP3 result.texcoord[4].y, R0, R2;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, R3, vertex.attrib[14];
DP3 result.texcoord[4].z, R0, vertex.normal;
DP3 result.texcoord[4].x, R0, vertex.attrib[14];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Float 11 [_WaveScale]
Vector 12 [_WaveOffset]
"vs_2_0
; 35 ALU
def c13, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mov r1.w, c13.z
mov r1.xyz, c9
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r2.xyz, r0, c8.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c10, r0
mov r0, c5
dp4 r4.y, c10, r0
dp3 r2.w, r2, r2
rsq r0.x, r2.w
mov r1, c4
dp4 r4.x, c10, r1
mul oT2.xyz, r0.x, r2.xzyw
rcp r0.z, c8.w
mul r0.xy, v0.xzzw, c11.x
mad r0, r0.xyxy, r0.z, c12
dp3 oT3.y, r4, r3
dp3 oT4.y, r2, r3
dp3 oT3.z, v2, r4
dp3 oT3.x, r4, v1
dp3 oT4.z, r2, v2
dp3 oT4.x, r2, v1
mul oT0.xy, r0, c13
mov oT1.xy, r0.wzzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_4;
  mediump vec3 tmpvar_5;
  tmpvar_5 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD2, tmpvar_5);
  mediump vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6;
  tmpvar_7.y = tmpvar_6;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ColorControl, tmpvar_7);
  water = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_10;
  tmpvar_10 = textureCube (_ColorControlCube, tmpvar_9);
  reflcol = tmpvar_10;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_11;
  tmpvar_11 = col.w;
  tmpvar_2 = tmpvar_11;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_13;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_3;
  tmpvar_3 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_3;
  mediump float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD2, tmpvar_3);
  mediump vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = tmpvar_4;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ColorControl, tmpvar_5);
  water = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_ColorControlCube, tmpvar_7);
  reflcol = tmpvar_8;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_9;
  tmpvar_9 = col.w;
  tmpvar_2 = tmpvar_9;
  lightDir = xlv_TEXCOORD3;
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_10;
  tmpvar_10 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((_LightColor0.xyz * pow (nh, _Gloss)) * 2.0) * _Specular);
  c_i0.xyz = tmpvar_11;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_Scale]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Float 11 [_WaveScale]
Vector 12 [_WaveOffset]
"agal_vs
c13 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacanaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c13.z
aaaaaaaaabaaahacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c9
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r0.z, r1, c6
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, r1, c4
bdaaaaaaaaaaacacabaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r0.y, r1, c5
adaaaaaaacaaahacaaaaaakeacaaaaaaaiaaaappabaaaaaa mul r2.xyz, r0.xyzz, c8.w
acaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r2.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c6
bdaaaaaaaeaaaeacakaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c10, r0
aaaaaaaaaaaaapacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c5
bdaaaaaaaeaaacacakaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c10, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r2.w
aaaaaaaaabaaapacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c4
bdaaaaaaaeaaabacakaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c10, r1
adaaaaaaacaaahaeaaaaaaaaacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.x, r2.xzyy
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
afaaaaaaaaaaaeacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r1.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaaalaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c11.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaaamaaaaoeabaaaaaa add r0, r0, c12
bcaaaaaaadaaacaeaeaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r4.xyzz, r3.xyzz
bcaaaaaaaeaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v4.y, r2.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 v3.z, a1, r4.xyzz
bcaaaaaaadaaabaeaeaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r4.xyzz, a5
bcaaaaaaaeaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v4.z, r2.xyzz, a1
bcaaaaaaaeaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v4.x, r2.xyzz, a5
adaaaaaaaaaaadaeaaaaaafeacaaaaaaanaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c13
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 20 [_WaveScale]
Vector 21 [_WaveOffset]
"!!ARBvp1.0
# 41 ALU
PARAM c[22] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[0].z;
MOV R1.xyz, c[18];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, R0, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[19];
MUL R2.xyz, R2, vertex.attrib[14].w;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[4].y, R0, R2;
DP3 result.texcoord[4].z, R0, vertex.normal;
DP3 result.texcoord[4].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[3].y, R1, R2;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
RCP R0.w, c[17].w;
MUL R1.xy, vertex.position.xzzw, c[20].x;
MAD R1, R1.xyxy, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.texcoord[5].w, R0, c[16];
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"vs_2_0
; 44 ALU
def c21, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mov r1.w, c21.z
mov r1.xyz, c17
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
mov r1, c8
dp4 r4.y, c18, r0
dp3 r2.w, r2, r2
rsq r0.w, r2.w
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 oT3.y, r0, r3
dp3 oT3.z, v2, r0
dp3 oT3.x, r0, v1
mul oT2.xyz, r0.w, r2.xzyw
rcp r0.z, c16.w
mul r0.xy, v0.xzzw, c19.x
mad r0, r0.xyxy, r0.z, c20
mul oT0.xy, r0, c21
mov oT1.xy, r0.wzzw
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT4.y, r2, r3
dp3 oT4.z, r2, v2
dp3 oT4.x, r2, v1
dp4 oT5.w, r0, c15
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_4;
  mediump vec3 tmpvar_5;
  tmpvar_5 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD2, tmpvar_5);
  mediump vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6;
  tmpvar_7.y = tmpvar_6;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ColorControl, tmpvar_7);
  water = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_10;
  tmpvar_10 = textureCube (_ColorControlCube, tmpvar_9);
  reflcol = tmpvar_10;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_11;
  tmpvar_11 = col.w;
  tmpvar_2 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_14;
  tmpvar_14 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, tmpvar_14);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_13.w) * tmpvar_15.w);
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_17;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_3;
  tmpvar_3 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_3;
  mediump float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD2, tmpvar_3);
  mediump vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = tmpvar_4;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ColorControl, tmpvar_5);
  water = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_ColorControlCube, tmpvar_7);
  reflcol = tmpvar_8;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_9;
  tmpvar_9 = col.w;
  tmpvar_2 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5));
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_12;
  tmpvar_12 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, tmpvar_12);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * tmpvar_11.w) * tmpvar_13.w);
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_15;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"agal_vs
c21 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacbfaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c21.z
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r2.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c18, r0
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bdaaaaaaaeaaacacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c18, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r2.w
bdaaaaaaaeaaabacbcaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c18, r1
adaaaaaaabaaahacaeaaaakeacaaaaaabaaaaappabaaaaaa mul r1.xyz, r4.xyzz, c16.w
acaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r1.xyzz, a0
bcaaaaaaadaaacaeaaaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r0.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeaaaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r0.xyzz, a5
adaaaaaaacaaahaeaaaaaappacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.w, r2.xzyy
aaaaaaaaabaaapacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c16
afaaaaaaaaaaaeacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r1.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaabdaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c19.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa add r0, r0, c20
adaaaaaaaaaaadaeaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c21
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bcaaaaaaaeaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v4.y, r2.xyzz, r3.xyzz
bcaaaaaaaeaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v4.z, r2.xyzz, a1
bcaaaaaaaeaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v4.x, r2.xyzz, a5
bdaaaaaaafaaaiaeaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 v5.w, r0, c15
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 20 [_WaveScale]
Vector 21 [_WaveOffset]
"!!ARBvp1.0
# 40 ALU
PARAM c[22] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[0].z;
MOV R1.xyz, c[18];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, R0, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[19];
MUL R2.xyz, R2, vertex.attrib[14].w;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
DP3 result.texcoord[4].y, R0, R2;
DP3 result.texcoord[4].z, R0, vertex.normal;
DP3 result.texcoord[4].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[3].y, R1, R2;
DP3 result.texcoord[3].z, vertex.normal, R1;
DP3 result.texcoord[3].x, R1, vertex.attrib[14];
RCP R0.w, c[17].w;
MUL R1.xy, vertex.position.xzzw, c[20].x;
MAD R1, R1.xyxy, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 40 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"vs_2_0
; 43 ALU
def c21, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mov r1.w, c21.z
mov r1.xyz, c17
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
mov r1, c8
dp4 r4.y, c18, r0
dp3 r2.w, r2, r2
rsq r0.w, r2.w
dp4 r4.x, c18, r1
mad r0.xyz, r4, c16.w, -v0
dp3 oT3.y, r0, r3
dp3 oT3.z, v2, r0
dp3 oT3.x, r0, v1
mul oT2.xyz, r0.w, r2.xzyw
rcp r0.z, c16.w
mul r0.xy, v0.xzzw, c19.x
mad r0, r0.xyxy, r0.z, c20
mul oT0.xy, r0, c21
mov oT1.xy, r0.wzzw
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT4.y, r2, r3
dp3 oT4.z, r2, v2
dp3 oT4.x, r2, v1
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_4;
  mediump vec3 tmpvar_5;
  tmpvar_5 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD2, tmpvar_5);
  mediump vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6;
  tmpvar_7.y = tmpvar_6;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ColorControl, tmpvar_7);
  water = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_10;
  tmpvar_10 = textureCube (_ColorControlCube, tmpvar_9);
  reflcol = tmpvar_10;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_11;
  tmpvar_11 = col.w;
  tmpvar_2 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, tmpvar_13);
  lowp vec4 tmpvar_15;
  tmpvar_15 = textureCube (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_14.w * tmpvar_15.w);
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_17;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_3;
  tmpvar_3 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_3;
  mediump float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD2, tmpvar_3);
  mediump vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = tmpvar_4;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ColorControl, tmpvar_5);
  water = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_ColorControlCube, tmpvar_7);
  reflcol = tmpvar_8;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_9;
  tmpvar_9 = col.w;
  tmpvar_2 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize (xlv_TEXCOORD3);
  lightDir = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTextureB0, tmpvar_11);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = (tmpvar_12.w * tmpvar_13.w);
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_14;
  tmpvar_14 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_15;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"agal_vs
c21 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacbfaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c21.z
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r2.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c18, r0
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bdaaaaaaaeaaacacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c18, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r2.w
bdaaaaaaaeaaabacbcaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c18, r1
adaaaaaaabaaahacaeaaaakeacaaaaaabaaaaappabaaaaaa mul r1.xyz, r4.xyzz, c16.w
acaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r1.xyzz, a0
bcaaaaaaadaaacaeaaaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r0.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 v3.z, a1, r0.xyzz
bcaaaaaaadaaabaeaaaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r0.xyzz, a5
adaaaaaaacaaahaeaaaaaappacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.w, r2.xzyy
aaaaaaaaabaaapacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c16
afaaaaaaaaaaaeacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r1.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaabdaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c19.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa add r0, r0, c20
adaaaaaaaaaaadaeaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c21
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bcaaaaaaaeaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v4.y, r2.xyzz, r3.xyzz
bcaaaaaaaeaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v4.z, r2.xyzz, a1
bcaaaaaaaeaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v4.x, r2.xyzz, a5
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Float 20 [_WaveScale]
Vector 21 [_WaveOffset]
"!!ARBvp1.0
# 38 ALU
PARAM c[22] = { { 0.40000001, 0.44999999, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[0].z;
MOV R1.xyz, c[18];
DP4 R0.z, R1, c[11];
DP4 R0.y, R1, c[10];
DP4 R0.x, R1, c[9];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, R0, R0;
MOV R1.xyz, vertex.attrib[14];
MUL R2.xyz, vertex.normal.zxyw, R1.yzxw;
MAD R2.xyz, vertex.normal.yzxw, R1.zxyw, -R2;
MOV R1, c[19];
MUL R2.xyz, R2, vertex.attrib[14].w;
RSQ R0.w, R0.w;
MUL result.texcoord[2].xyz, R0.w, R0.xzyw;
DP4 R3.z, R1, c[11];
DP4 R3.y, R1, c[10];
DP4 R3.x, R1, c[9];
DP3 result.texcoord[4].y, R0, R2;
DP3 result.texcoord[4].z, R0, vertex.normal;
DP3 result.texcoord[4].x, R0, vertex.attrib[14];
RCP R0.w, c[17].w;
MUL R1.xy, vertex.position.xzzw, c[20].x;
MAD R1, R1.xyxy, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[3].y, R3, R2;
DP3 result.texcoord[3].z, vertex.normal, R3;
DP3 result.texcoord[3].x, R3, vertex.attrib[14];
MUL result.texcoord[0].xy, R1, c[0];
MOV result.texcoord[1].xy, R1.wzzw;
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"vs_2_0
; 41 ALU
def c21, 0.40000001, 0.44999999, 1.00000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
mov r1.w, c21.z
mov r1.xyz, c17
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r2.xyz, r0, c16.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r3.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c18, r0
mov r0, c9
dp4 r4.y, c18, r0
dp3 r2.w, r2, r2
rsq r0.x, r2.w
mov r1, c8
dp4 r4.x, c18, r1
mul oT2.xyz, r0.x, r2.xzyw
rcp r0.z, c16.w
mul r0.xy, v0.xzzw, c19.x
mad r0, r0.xyxy, r0.z, c20
mul oT0.xy, r0, c21
mov oT1.xy, r0.wzzw
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 oT3.y, r4, r3
dp3 oT4.y, r2, r3
dp3 oT3.z, v2, r4
dp3 oT3.x, r4, v1
dp3 oT4.z, r2, v2
dp3 oT4.x, r2, v1
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 tmpvar_3;
  tmpvar_3 = ((texture2D (_BumpMap, xlv_TEXCOORD0).xyz * 2.0) - 1.0);
  bump1 = tmpvar_3;
  lowp vec3 tmpvar_4;
  tmpvar_4 = ((texture2D (_BumpMap, xlv_TEXCOORD1).xyz * 2.0) - 1.0);
  bump2 = tmpvar_4;
  mediump vec3 tmpvar_5;
  tmpvar_5 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_5;
  mediump float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD2, tmpvar_5);
  mediump vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6;
  tmpvar_7.y = tmpvar_6;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ColorControl, tmpvar_7);
  water = tmpvar_8;
  mediump vec3 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_10;
  tmpvar_10 = textureCube (_ColorControlCube, tmpvar_9);
  reflcol = tmpvar_10;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_11;
  tmpvar_11 = col.w;
  tmpvar_2 = tmpvar_11;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_12.w;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_13;
  tmpvar_13 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_14;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp float _WaveScale;
uniform highp vec4 _WaveOffset;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesTANGENT;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize (_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec2 tmpvar_5;
  mediump vec2 tmpvar_6;
  mediump vec3 tmpvar_7;
  highp vec4 temp;
  temp = (((_glesVertex.xzxz * _WaveScale) / unity_Scale.w) + _WaveOffset);
  highp vec2 tmpvar_8;
  tmpvar_8 = (temp.xy * vec2(0.4, 0.45));
  tmpvar_5 = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = temp.wz;
  tmpvar_6 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((((_World2Object * tmpvar_10).xyz * unity_Scale.w) - _glesVertex.xyz)).xzy;
  tmpvar_7 = tmpvar_11;
  highp mat3 tmpvar_12;
  tmpvar_12[0] = tmpvar_1.xyz;
  tmpvar_12[1] = (cross (tmpvar_2, tmpvar_1.xyz) * _glesTANGENT.w);
  tmpvar_12[2] = tmpvar_2;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  highp vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_16;
  tmpvar_16 = (tmpvar_13 * (((_World2Object * tmpvar_15).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_5;
  xlv_TEXCOORD1 = tmpvar_6;
  xlv_TEXCOORD2 = tmpvar_7;
  xlv_TEXCOORD3 = tmpvar_3;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp float _Specular;
uniform highp float _MainAlpha;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform samplerCube _ColorControlCube;
uniform sampler2D _ColorControl;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp float tmpvar_2;
  mediump vec4 col;
  mediump vec4 reflcol;
  mediump vec4 water;
  mediump vec3 bump2;
  mediump vec3 bump1;
  lowp vec3 normal;
  normal.xy = ((texture2D (_BumpMap, xlv_TEXCOORD0).wy * 2.0) - 1.0);
  normal.z = sqrt (((1.0 - (normal.x * normal.x)) - (normal.y * normal.y)));
  bump1 = normal;
  lowp vec3 normal_i0;
  normal_i0.xy = ((texture2D (_BumpMap, xlv_TEXCOORD1).wy * 2.0) - 1.0);
  normal_i0.z = sqrt (((1.0 - (normal_i0.x * normal_i0.x)) - (normal_i0.y * normal_i0.y)));
  bump2 = normal_i0;
  mediump vec3 tmpvar_3;
  tmpvar_3 = ((bump1 + bump2) * 0.5);
  tmpvar_1 = tmpvar_3;
  mediump float tmpvar_4;
  tmpvar_4 = dot (xlv_TEXCOORD2, tmpvar_3);
  mediump vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4;
  tmpvar_5.y = tmpvar_4;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_ColorControl, tmpvar_5);
  water = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD2 - ((2.0 * dot (xlv_TEXCOORD2, tmpvar_1)) * tmpvar_1));
  lowp vec4 tmpvar_8;
  tmpvar_8 = textureCube (_ColorControlCube, tmpvar_7);
  reflcol = tmpvar_8;
  col.xyz = water.xyz;
  col.xyz = mix (reflcol.xyz, col.xyz, vec3(0.5, 0.5, 0.5));
  col.w = _MainAlpha;
  mediump float tmpvar_9;
  tmpvar_9 = col.w;
  tmpvar_2 = tmpvar_9;
  lightDir = xlv_TEXCOORD3;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_LightTexture0, xlv_TEXCOORD5);
  mediump vec3 lightDir_i0;
  lightDir_i0 = lightDir;
  mediump float atten;
  atten = tmpvar_10.w;
  mediump vec4 c_i0;
  highp float nh;
  mediump float tmpvar_11;
  tmpvar_11 = max (0.0, dot (tmpvar_1, normalize ((lightDir_i0 + normalize (xlv_TEXCOORD4)))));
  nh = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((_LightColor0.xyz * pow (nh, _Gloss)) * (atten * 2.0)) * _Specular);
  c_i0.xyz = tmpvar_12;
  c_i0.w = 1.0;
  c = c_i0;
  c.w = tmpvar_2;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Float 19 [_WaveScale]
Vector 20 [_WaveOffset]
"agal_vs
c21 0.4 0.45 1.0 0.0
[bc]
aaaaaaaaabaaaiacbfaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c21.z
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r2.xyz, r2.xyzz, a0
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaabaaahacabaaaancaaaaaaaaaaaaaaajacaaaaaa mul r1.xyz, a1.zxyw, r0.yzxx
aaaaaaaaaaaaahacafaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, a5
adaaaaaaadaaahacabaaaamjaaaaaaaaaaaaaafcacaaaaaa mul r3.xyz, a1.yzxw, r0.zxyy
acaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaafaaaappaaaaaaaa mul r3.xyz, r1.xyzz, a5.w
aaaaaaaaaaaaapacakaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c10
bdaaaaaaaeaaaeacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.z, c18, r0
aaaaaaaaaaaaapacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0, c9
bdaaaaaaaeaaacacbcaaaaoeabaaaaaaaaaaaaoeacaaaaaa dp4 r4.y, c18, r0
bcaaaaaaacaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r2.w, r2.xyzz, r2.xyzz
akaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r2.w
aaaaaaaaabaaapacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c8
bdaaaaaaaeaaabacbcaaaaoeabaaaaaaabaaaaoeacaaaaaa dp4 r4.x, c18, r1
adaaaaaaacaaahaeaaaaaaaaacaaaaaaacaaaafiacaaaaaa mul v2.xyz, r0.x, r2.xzyy
aaaaaaaaabaaapacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1, c16
afaaaaaaaaaaaeacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.z, r1.w
adaaaaaaaaaaadacaaaaaaoiaaaaaaaabdaaaaaaabaaaaaa mul r0.xy, a0.xzzw, c19.x
adaaaaaaaaaaapacaaaaaaeeacaaaaaaaaaaaakkacaaaaaa mul r0, r0.xyxy, r0.z
abaaaaaaaaaaapacaaaaaaoeacaaaaaabeaaaaoeabaaaaaa add r0, r0, c20
adaaaaaaaaaaadaeaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul v0.xy, r0.xyyy, c21
aaaaaaaaabaaadaeaaaaaaklacaaaaaaaaaaaaaaaaaaaaaa mov v1.xy, r0.wzzz
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bcaaaaaaadaaacaeaeaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v3.y, r4.xyzz, r3.xyzz
bcaaaaaaaeaaacaeacaaaakeacaaaaaaadaaaakeacaaaaaa dp3 v4.y, r2.xyzz, r3.xyzz
bcaaaaaaadaaaeaeabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 v3.z, a1, r4.xyzz
bcaaaaaaadaaabaeaeaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v3.x, r4.xyzz, a5
bcaaaaaaaeaaaeaeacaaaakeacaaaaaaabaaaaoeaaaaaaaa dp3 v4.z, r2.xyzz, a1
bcaaaaaaaeaaabaeacaaaakeacaaaaaaafaaaaoeaaaaaaaa dp3 v4.x, r2.xyzz, a5
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 30 to 41, TEX: 2 to 4
//   d3d9 - ALU: 35 to 44, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1], texture[0], 2D;
TEX R0.yw, fragment.texcoord[0], texture[0], 2D;
DP3 R0.x, fragment.texcoord[5], fragment.texcoord[5];
MAD R1.xy, R1.wyzw, c[4].x, -c[4].y;
MOV result.color.w, c[1].x;
TEX R2.w, R0.x, texture[1], 2D;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.z, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R0.z, fragment.texcoord[4];
RSQ R0.x, R0.x;
MAD R2.xyz, R0.x, fragment.texcoord[3], R2;
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, R2;
MAD R0.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
MUL R0.w, R1.y, R1.y;
MAD R0.w, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[4].y;
RSQ R0.w, R0.w;
RCP R1.z, R0.w;
ADD R0.z, R0, c[4].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, R2;
DP3 R0.x, R0, c[4].z;
MAX R0.x, R0, c[4].w;
POW R0.x, R0.x, c[3].x;
MUL R0.w, R2, c[4].x;
MUL R0.xyz, R0.x, c[0];
MUL R0.xyz, R0, R0.w;
MUL result.color.xyz, R0, c[2].x;
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 39 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r1, t0, s0
mov r1.x, r1.w
dp3 r0.x, t5, t5
mov r0.xy, r0.x
mad_pp r2.xy, r1, c4.x, c4.y
texld r5, r0, s1
texld r0, t1, s0
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
mov r1.x, r0.w
mov r1.y, r0
mad_pp r3.xy, r1, c4.x, c4.y
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
dp3_pp r1.x, t4, t4
rsq_pp r4.x, r1.x
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
dp3_pp r1.x, t3, t3
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r4.xyz, r4.x, t4
mad_pp r4.xyz, r1.x, t3, r4
dp3_pp r1.x, r4, r4
rsq_pp r1.x, r1.x
rcp_pp r3.z, r0.x
mul_pp r0.xyz, r1.x, r4
add_pp r1.xyz, r2, r3
mul_pp r0.xyz, r1, r0
dp3_pp r0.x, r0, c4.w
max_pp r0.x, r0, c5
pow r1.w, r0.x, c3.x
mul_pp r0.x, r5, c4
mul r1.xyz, r1.w, c0
mul r0.xyz, r1, r0.x
mul r0.xyz, r0, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
aaaaaaaaabaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r1.w
adaaaaaaadaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r1.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaffabaaaaaa add r3.xy, r3.xyyy, c4.y
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaaeaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r1.x
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaaeaaahacaeaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r4.xyz, r4.x, v4
adaaaaaaafaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r5.xyz, r1.x, v3
abaaaaaaaeaaahacafaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r5.xyzz, r4.xyzz
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
aaaaaaaaaaaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.y
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
adaaaaaaacaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r0.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaafaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r2.x
adaaaaaaafaaabacafaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r5.x, r5.x, r2.x
acaaaaaaaaaaabacafaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r5.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaafaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r5.x, r3.x
adaaaaaaafaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r5.x, r5.x, r3.x
acaaaaaaaaaaabacafaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r5.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r1.x, r4.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r2.xyzz, r3.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaeaaaappabaaaaaa dp3 r0.x, r0.xyzz, c4.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
adaaaaaaaaaaabacaaaaaappacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.w, c4
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.x, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 2 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1], texture[0], 2D;
TEX R0.yw, fragment.texcoord[0], texture[0], 2D;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xy, R1.wyzw, c[4].x, -c[4].y;
RSQ R0.x, R0.x;
MOV R2.xyz, fragment.texcoord[3];
MAD R2.xyz, R0.x, fragment.texcoord[4], R2;
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, R2;
MAD R0.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
MUL R0.w, R1.y, R1.y;
MAD R0.w, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[4].y;
ADD R0.z, R0, c[4].y;
RSQ R0.w, R0.w;
RSQ R0.z, R0.z;
RCP R1.z, R0.w;
RCP R0.z, R0.z;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, R2;
DP3 R0.x, R0, c[4].z;
MAX R0.x, R0, c[4].w;
POW R0.x, R0.x, c[3].x;
MUL R0.xyz, R0.x, c[0];
MUL R0.xyz, R0, c[2].x;
MUL result.color.xyz, R0, c[4].x;
MOV result.color.w, c[1].x;
END
# 30 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
"ps_2_0
; 35 ALU, 2 TEX
dcl_2d s0
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s0
texld r0, t1, s0
mov r1.x, r1.w
mad_pp r2.xy, r1, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
mov r1.x, r0.w
mov r1.y, r0
mad_pp r4.xy, r1, c4.x, c4.y
add_pp r0.x, r0, c4.z
rsq_pp r1.x, r0.x
rcp_pp r2.z, r1.x
mul_pp r0.x, r4.y, r4.y
mad_pp r0.x, -r4, r4, -r0
dp3_pp r1.x, t4, t4
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mov_pp r3.xyz, t3
mad_pp r3.xyz, r1.x, t4, r3
dp3_pp r1.x, r3, r3
rsq_pp r1.x, r1.x
rcp_pp r4.z, r0.x
mul_pp r0.xyz, r1.x, r3
add_pp r1.xyz, r2, r4
mul_pp r0.xyz, r1, r0
dp3_pp r0.x, r0, c4.w
max_pp r0.x, r0, c5
pow r1.x, r0.x, c3.x
mov r0.x, r1.x
mul r0.xyz, r0.x, c0
mul r0.xyz, r0, c2.x
mul r0.xyz, r0, c4.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 0.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
ciaaaaaaaaaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v1, s0 <2d wrap linear point>
aaaaaaaaabaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r1.w
adaaaaaaacaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r1.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaacaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r2.x
adaaaaaaacaaaiacacaaaappacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.w, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
aaaaaaaaabaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r0.w
aaaaaaaaabaaacacaaaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.y
adaaaaaaaeaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r4.xy, r1.xyyy, c4.x
abaaaaaaaeaaadacaeaaaafeacaaaaaaaeaaaaffabaaaaaa add r4.xy, r4.xyyy, c4.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
afaaaaaaacaaaeacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r1.x
adaaaaaaaaaaabacaeaaaaffacaaaaaaaeaaaaffacaaaaaa mul r0.x, r4.y, r4.y
bfaaaaaaadaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.x, r4.x
adaaaaaaadaaabacadaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r3.x, r3.x, r4.x
acaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.x, r0.x
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
aaaaaaaaadaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r3.xyz, v3
adaaaaaaafaaahacabaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r5.xyz, r1.x, v4
abaaaaaaadaaahacafaaaakeacaaaaaaadaaaakeacaaaaaa add r3.xyz, r5.xyzz, r3.xyzz
bcaaaaaaabaaabacadaaaakeacaaaaaaadaaaakeacaaaaaa dp3 r1.x, r3.xyzz, r3.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
afaaaaaaaeaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r4.z, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaadaaaakeacaaaaaa mul r0.xyz, r1.x, r3.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaaeaaaakeacaaaaaa add r1.xyz, r2.xyzz, r4.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaeaaaappabaaaaaa dp3 r0.x, r0.xyzz, c4.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.x, c0
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaaeaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c4.x
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 41 ALU, 4 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2.yw, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[1], texture[0], 2D;
MAD R2.xy, R2.wyzw, c[4].x, -c[4].y;
RCP R0.x, fragment.texcoord[5].w;
MAD R0.zw, fragment.texcoord[5].xyxy, R0.x, c[4].z;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.z, R2.y, R2.y;
MAD R2.z, -R2.x, R2.x, -R2;
ADD R2.z, R2, c[4].y;
RSQ R2.z, R2.z;
DP3 R0.x, fragment.texcoord[5], fragment.texcoord[5];
RSQ R1.x, R1.x;
RCP R2.z, R2.z;
MOV result.color.w, c[1].x;
TEX R1.w, R0.zwzw, texture[1], 2D;
TEX R0.w, R0.x, texture[2], 2D;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[4];
MAD R0.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R0.xyz, R1.x, R0;
MAD R1.xy, R3.wyzw, c[4].x, -c[4].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[4].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
ADD R1.xyz, R2, R1;
MUL R0.xyz, R1, R0;
DP3 R0.x, R0, c[4].z;
MAX R0.y, R0.x, c[4].w;
POW R0.y, R0.y, c[3].x;
SLT R0.x, c[4].w, fragment.texcoord[5].z;
MUL R0.x, R0, R1.w;
MUL R0.x, R0, R0.w;
MUL R0.x, R0, c[4];
MUL R1.xyz, R0.y, c[0];
MUL R0.xyz, R1, R0.x;
MUL result.color.xyz, R0, c[2].x;
END
# 41 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 44 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t3.xyz
dcl t4.xyz
dcl t5
rcp r1.x, t5.w
mad r2.xy, t5, r1.x, c4.w
dp3 r0.x, t5, t5
mov r1.xy, r0.x
texld r5, r1, s2
texld r0, r2, s1
texld r2, t0, s0
texld r1, t1, s0
mov r1.x, r1.w
mad_pp r3.xy, r1, c4.x, c4.y
dp3_pp r1.x, t4, t4
rsq_pp r4.x, r1.x
dp3_pp r1.x, t3, t3
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mul_pp r4.xyz, r4.x, t4
mad_pp r4.xyz, r1.x, t3, r4
dp3_pp r1.x, r4, r4
rsq_pp r1.x, r1.x
rcp_pp r3.z, r0.x
mul_pp r0.xyz, r1.x, r4
add_pp r1.xyz, r2, r3
mul_pp r0.xyz, r1, r0
dp3_pp r0.x, r0, c4.w
max_pp r0.x, r0, c5
pow r1.w, r0.x, c3.x
cmp r0.x, -t5.z, c5, c5.y
mul_pp r0.x, r0, r0.w
mul_pp r0.x, r0, r5
mul_pp r0.x, r0, c4
mul r1.xyz, r1.w, c0
mul r0.xyz, r1, r0.x
mul r0.xyz, r0, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 1.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaadaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r3, v1, s0 <2d wrap linear point>
afaaaaaaabaaabacafaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, v5.w
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
adaaaaaaabaaadacafaaaaoeaeaaaaaaabaaaaaaacaaaaaa mul r1.xy, v5, r1.x
abaaaaaaabaaadacabaaaafeacaaaaaaaeaaaappabaaaaaa add r1.xy, r1.xyyy, c4.w
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaabaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r1, r1.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
aaaaaaaaaaaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.y
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
adaaaaaaacaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r0.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaaeaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r2.x
adaaaaaaaeaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r4.x, r4.x, r2.x
acaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r3.y
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
adaaaaaaadaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r1.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaffabaaaaaa add r3.xy, r3.xyyy, c4.y
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaaeaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r1.x
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaaeaaaiacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.w, r3.x
adaaaaaaaeaaaiacaeaaaappacaaaaaaadaaaaaaacaaaaaa mul r4.w, r4.w, r3.x
acaaaaaaaaaaabacaeaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.w, r0.x
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaaeaaahacaeaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r4.xyz, r4.x, v4
adaaaaaaafaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r5.xyz, r1.x, v3
abaaaaaaaeaaahacafaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r5.xyzz, r4.xyzz
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r1.x, r4.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r2.xyzz, r3.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaeaaaappabaaaaaa dp3 r0.x, r0.xyzz, c4.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaacaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r2, r0.x, c3.x
bfaaaaaaafaaaeacafaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r5.z, v5.z
ckaaaaaaaaaaabacafaaaakkacaaaaaaafaaaaaaabaaaaaa slt r0.x, r5.z, c5.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaabaaaappacaaaaaa mul r0.x, r0.x, r1.w
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaappacaaaaaa mul r0.x, r0.x, r0.w
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.x, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 4 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2.yw, fragment.texcoord[0], texture[0], 2D;
TEX R3.yw, fragment.texcoord[1], texture[0], 2D;
TEX R0.w, fragment.texcoord[5], texture[2], CUBE;
MAD R2.xy, R2.wyzw, c[4].x, -c[4].y;
DP3 R0.x, fragment.texcoord[5], fragment.texcoord[5];
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.z, R2.y, R2.y;
MAD R2.z, -R2.x, R2.x, -R2;
ADD R2.z, R2, c[4].y;
RSQ R2.z, R2.z;
RSQ R1.x, R1.x;
RCP R2.z, R2.z;
MOV result.color.w, c[1].x;
TEX R1.w, R0.x, texture[1], 2D;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[4];
MAD R0.xyz, R1.x, fragment.texcoord[3], R0;
DP3 R1.x, R0, R0;
RSQ R1.x, R1.x;
MUL R0.xyz, R1.x, R0;
MAD R1.xy, R3.wyzw, c[4].x, -c[4].y;
MUL R1.z, R1.y, R1.y;
MAD R1.z, -R1.x, R1.x, -R1;
ADD R1.z, R1, c[4].y;
RSQ R1.z, R1.z;
RCP R1.z, R1.z;
ADD R1.xyz, R2, R1;
MUL R0.xyz, R1, R0;
DP3 R0.x, R0, c[4].z;
MAX R0.y, R0.x, c[4].w;
POW R0.y, R0.y, c[3].x;
MUL R0.x, R1.w, R0.w;
MUL R0.x, R0, c[4];
MUL R1.xyz, R0.y, c[0];
MUL R0.xyz, R1, R0.x;
MUL result.color.xyz, R0, c[2].x;
END
# 37 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 40 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r2, t0, s0
texld r1, t1, s0
mov r1.x, r1.w
mad_pp r3.xy, r1, c4.x, c4.y
dp3_pp r1.x, t4, t4
rsq_pp r4.x, r1.x
dp3 r0.x, t5, t5
mov r0.xy, r0.x
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mul_pp r4.xyz, r4.x, t4
mad_pp r4.xyz, r1.x, t3, r4
dp3_pp r1.x, r4, r4
rsq_pp r1.x, r1.x
texld r5, r0, s1
texld r0, t5, s2
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r2.z, r0.x
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rcp_pp r3.z, r0.x
mul_pp r0.xyz, r1.x, r4
add_pp r1.xyz, r2, r3
mul_pp r0.xyz, r1, r0
dp3_pp r0.x, r0, c4.w
max_pp r0.x, r0, c5
pow r1.w, r0.x, c3.x
mul r0.x, r5, r0.w
mul_pp r0.x, r0, c4
mul r1.xyz, r1.w, c0
mul r0.xyz, r1, r0.x
mul r0.xyz, r0, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaadaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r3, v1, s0 <2d wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
ciaaaaaaabaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r1, r0.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaacaaaaaaafbababb tex r0, v5, s2 <cube wrap linear point>
aaaaaaaaaaaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.y
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
adaaaaaaacaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r0.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaaeaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r2.x
adaaaaaaaeaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r4.x, r4.x, r2.x
acaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaacacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r3.y
aaaaaaaaabaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r3.w
adaaaaaaadaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r1.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaffabaaaaaa add r3.xy, r3.xyyy, c4.y
afaaaaaaacaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r0.x
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaaeaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r4.x, r1.x
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaaeaaaiacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.w, r3.x
adaaaaaaaeaaaiacaeaaaappacaaaaaaadaaaaaaacaaaaaa mul r4.w, r4.w, r3.x
acaaaaaaaaaaabacaeaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.w, r0.x
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaaeaaahacaeaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r4.xyz, r4.x, v4
adaaaaaaafaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r5.xyz, r1.x, v3
abaaaaaaaeaaahacafaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r5.xyzz, r4.xyzz
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r1.x, r4.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r2.xyzz, r3.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaeaaaappabaaaaaa dp3 r0.x, r0.xyzz, c4.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaacaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r2, r0.x, c3.x
adaaaaaaaaaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r0.x, r1.w, r0.w
aaaaaaaaabaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r2.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.x, c4
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.x, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 3 TEX
PARAM c[5] = { program.local[0..3],
		{ 2, 1, 0.5, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.yw, fragment.texcoord[1], texture[0], 2D;
TEX R0.yw, fragment.texcoord[0], texture[0], 2D;
TEX R2.w, fragment.texcoord[5], texture[1], 2D;
DP3 R0.x, fragment.texcoord[4], fragment.texcoord[4];
MAD R1.xy, R1.wyzw, c[4].x, -c[4].y;
RSQ R0.x, R0.x;
MOV R2.xyz, fragment.texcoord[3];
MAD R2.xyz, R0.x, fragment.texcoord[4], R2;
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, R2;
MAD R0.xy, R0.wyzw, c[4].x, -c[4].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
MUL R0.w, R1.y, R1.y;
MAD R0.w, -R1.x, R1.x, -R0;
ADD R0.w, R0, c[4].y;
RSQ R0.w, R0.w;
RCP R1.z, R0.w;
ADD R0.z, R0, c[4].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
ADD R0.xyz, R0, R1;
MUL R0.xyz, R0, R2;
DP3 R0.x, R0, c[4].z;
MAX R0.x, R0, c[4].w;
POW R0.x, R0.x, c[3].x;
MUL R0.w, R2, c[4].x;
MUL R0.xyz, R0.x, c[0];
MUL R0.xyz, R0, R0.w;
MUL result.color.xyz, R0, c[2].x;
MOV result.color.w, c[1].x;
END
# 32 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 35 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 2.00000000, -1.00000000, 1.00000000, 0.50000000
def c5, 0.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t3.xyz
dcl t4.xyz
dcl t5.xy
texld r2, t0, s0
texld r1, t1, s0
texld r0, t5, s1
mov r1.x, r1.w
mad_pp r3.xy, r1, c4.x, c4.y
mov r0.y, r2
mov r0.x, r2.w
mad_pp r2.xy, r0, c4.x, c4.y
mul_pp r0.x, r2.y, r2.y
mad_pp r0.x, -r2, r2, -r0
add_pp r0.x, r0, c4.z
rsq_pp r1.x, r0.x
rcp_pp r2.z, r1.x
mul_pp r0.x, r3.y, r3.y
mad_pp r0.x, -r3, r3, -r0
dp3_pp r1.x, t4, t4
add_pp r0.x, r0, c4.z
rsq_pp r0.x, r0.x
rsq_pp r1.x, r1.x
mov_pp r4.xyz, t3
mad_pp r4.xyz, r1.x, t4, r4
dp3_pp r1.x, r4, r4
rsq_pp r1.x, r1.x
rcp_pp r3.z, r0.x
mul_pp r0.xyz, r1.x, r4
add_pp r1.xyz, r2, r3
mul_pp r0.xyz, r1, r0
dp3_pp r0.x, r0, c4.w
max_pp r0.x, r0, c5
pow r1.w, r0.x, c3.x
mul_pp r0.x, r0.w, c4
mul r1.xyz, r1.w, c0
mul r0.xyz, r1, r0.x
mul r0.xyz, r0, c2.x
mov_pp r0.w, c1.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Float 1 [_MainAlpha]
Float 2 [_Specular]
Float 3 [_Gloss]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 2.0 -1.0 1.0 0.5
c5 0.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v5, s1 <2d wrap linear point>
aaaaaaaaabaaabacabaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r1.w
adaaaaaaadaaadacabaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r3.xy, r1.xyyy, c4.x
abaaaaaaadaaadacadaaaafeacaaaaaaaeaaaaffabaaaaaa add r3.xy, r3.xyyy, c4.y
aaaaaaaaaaaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.y
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
adaaaaaaacaaadacaaaaaafeacaaaaaaaeaaaaaaabaaaaaa mul r2.xy, r0.xyyy, c4.x
abaaaaaaacaaadacacaaaafeacaaaaaaaeaaaaffabaaaaaa add r2.xy, r2.xyyy, c4.y
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
bfaaaaaaadaaaiacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r2.x
adaaaaaaadaaaiacadaaaappacaaaaaaacaaaaaaacaaaaaa mul r3.w, r3.w, r2.x
acaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r3.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r0.x
afaaaaaaacaaaeacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r2.z, r1.x
adaaaaaaaaaaabacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r0.x, r3.y, r3.y
bfaaaaaaaeaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r4.x, r3.x
adaaaaaaaeaaabacaeaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r4.x, r4.x, r3.x
acaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r4.x, r0.x
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa add r0.x, r0.x, c4.z
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
aaaaaaaaaeaaahacadaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r4.xyz, v3
adaaaaaaafaaahacabaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r5.xyz, r1.x, v4
abaaaaaaaeaaahacafaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r5.xyzz, r4.xyzz
bcaaaaaaabaaabacaeaaaakeacaaaaaaaeaaaakeacaaaaaa dp3 r1.x, r4.xyzz, r4.xyzz
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
afaaaaaaadaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.z, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r0.xyz, r1.x, r4.xyzz
abaaaaaaabaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r2.xyzz, r3.xyzz
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacaaaaaakeacaaaaaaaeaaaappabaaaaaa dp3 r0.x, r0.xyzz, c4.w
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaafaaaaoeabaaaaaa max r0.x, r0.x, c5
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
adaaaaaaaaaaabacaaaaaappacaaaaaaaeaaaaoeabaaaaaa mul r0.x, r0.w, c4
adaaaaaaabaaahacabaaaaaaacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.x, c0
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaaaaabaaaaaa mul r0.xyz, r0.xyzz, c2.x
aaaaaaaaaaaaaiacabaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c1.x
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

}
	}

#LINE 104

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