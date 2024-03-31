float4x4 ViewProjectionMatrix;
float4x4 WorldMatrix;
float3 CameraPosition;
float4x4 matBones[45] : Bones;
float3 LightDirection;
float Time;
float4 TextureOffset;
float4 PrimaryColor   = float4(0.8, 0.0, 0, 1);
float4 SecondaryColor = float4(0.0, 0.7, 0, 1);

float FOW = 1.0;

// debug flags
//#define DEBUG_ONLY_SPECULAR
//#define DEBUG_ONLY_DIFFUSE
//#define DEBUG_ONLY_COLORMAP
//#define DEBUG_SHOW_SPECULARMAP
//#define DEBUG_SHOW_TEXCOORDS
#define DEBUG_SHOW_NORMALMAP

// select lighting model to use
#define LIGHTMODEL_WRAP
//#define LIGHTMODEL_HALFLAMBERT
//#define LIGHTMODEL_PHONG

const int SKINNING_INFLUENCES = 2;

float SPECULAR_POWER = 20;
float SPECULARITY = 1.25;
const float WRAP = 0.7;
const float AMBIENT = 0.0;
const float INTENSITY = 1.75;
const float3 LIGHT_OFFSET = float3(-250, -500, 200);
//float3 LIGHT_OFFSET = float3(0, 0, 100);

const float TRACK_SPEED = 2.5;

// Flag specific
const float ANIMATION_SPEED = 0.3;
const float INTENSITY_FLAG = 0.9;
const float3 LIGHT_OFFSET_FLAG = float3(-250, -500, 100);
const float FLAG_GRAYNESS = 0.3;
float SPECULAR_POWER_FLAG = 10;
float SPECULARITY_FLAG = 0.1;

texture tex0 : DiffuseTexture;
sampler2D DiffuseMap = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = Wrap;        
    AddressV  = Wrap;
    MipFilter = Linear;
    MagFilter = Linear;
	MinFilter = Anisotropic;
    
    MaxAnisotropy = 4;
};

texture tex1 : Texture1;
sampler2D SpecularMap = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = Wrap;        
    AddressV  = Wrap;
    MipFilter = Linear;
    MinFilter = Linear;
    MagFilter = Linear;
};

sampler2D NormalMap = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = Wrap;        
    AddressV  = Wrap;
    MipFilter = Linear;
    MagFilter = Linear;
	MinFilter = Linear;
};

struct VS_INPUT
{
    float4 vPosition   : POSITION;
    float3 vNormal     : NORMAL;
	float4 vTangent    : TANGENT;
	float2 vTexCoord0  : TEXCOORD0;
	float4 boneIndices : BLENDINDICES;
    float4 boneWeights : BLENDWEIGHT;
};

struct VS_OUTPUT
{
    float4 vPosition  : POSITION;
	float2 vTexCoord0 : TEXCOORD0;
	float3 Normal     : TEXCOORD1;
	float3 LightDirection : TEXCOORD2;
	float3 EyeVec : TEXCOORD3;
};


float3 ApplyFOWColor( float3 c ) 
{
	const float3 GREYIFY = float3( 0.212671, 0.715160, 0.072169 );
	float Grey = dot( c.rgb, GREYIFY );
	return lerp( Grey.rrr * 0.4, c.rgb, FOW > 0.5 ? 1.0 : 0.5 );
}

VS_OUTPUT SkinnedAvatarVS(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
		
	float4 skinnedPosition = (float4)0;
	float4 skinnedNormal   = (float4)0;
	
	float4 vPosition = float4(v.vPosition.xyz, 1.0);
		
	// skinning
	for( int i = 0; i < SKINNING_INFLUENCES; ++i )
    {
    	float4x4 mat = matBones[ v.boneIndices[i] ];

		float4 offset = mul( vPosition, mat ) * v.boneWeights[i];
		skinnedPosition += offset;
		
		offset = mul( normalize(v.vNormal), mat )  * v.boneWeights[i];
		skinnedNormal += offset;
	}
	
	Out.LightDirection = -normalize(skinnedPosition - CameraPosition + LIGHT_OFFSET );
	Out.EyeVec = -normalize(skinnedPosition - (CameraPosition) );
	
	Out.vPosition = mul(skinnedPosition, ViewProjectionMatrix );
	Out.vTexCoord0 = v.vTexCoord0;
	Out.Normal  = normalize(skinnedNormal);

	return Out;
}

float4 SkinnedAvatarPS( VS_OUTPUT In ) : COLOR
{
	float4 vColor = tex2D( DiffuseMap, In.vTexCoord0 );
	float3 vSpecColor = tex2D( SpecularMap, In.vTexCoord0 ).rgb;
	//return float4(vSpecColor.rrr,1);
	float3 vNormal = normalize(In.Normal);

	// get base color
	vColor.rgb = lerp(vColor.rgb, 
	                  vColor.rgb * (PrimaryColor.rgb * vSpecColor.g), 
					  vSpecColor.g);

	vColor.rgb = lerp(vColor.rgb,  
	                  vColor.rgb * (SecondaryColor.rgb * vSpecColor.b), 
					  vSpecColor.b);

	float3 L = normalize(In.LightDirection);
	float3 E = normalize(In.EyeVec);
    //float3 halfVec = L; // light is in camera so no need for normalize(EyeVec + L);
	float3 halfVec = normalize(E + L);
	float  NdotL = max(0 , dot(vNormal,L));
	
	#ifdef LIGHTMODEL_WRAP
	float diffuse = saturate((NdotL + WRAP) / (1 + WRAP)) * INTENSITY;
	#endif
	#ifdef LIGHTMODEL_HALFLAMBERT
	float diffuse = pow(0.5 * NdotL + 0.5, 2) * INTENSITY; 
	#endif
	#ifdef LIGHTMODEL_PHONG
	float diffuse = NdotL * INTENSITY + AMBIENT;
	#endif
	
	//diffuse = 0;
	//vColor.rgb = float3(0.2,0,0);
    float NDotH = dot(vNormal, halfVec);
	float vMax = saturate(NDotH );
	//float  specular = 0;
	//if( vMax != 0 )
		float specular = pow( vMax, SPECULAR_POWER );
 	
    //if( NdotL <= 0 )
    //{
     //   specular = 0;
    //}
	
	specular *= vSpecColor.r * SPECULARITY; // mask
		
	//return float4(NdotL.xxx, 1 );
	
	return float4( ApplyFOWColor(vColor.rgb * diffuse + specular), 1 );
}


float2 GetTexCoordsInAtlas(float2 TexCoord)
{
	return float2( (TexCoord.x / TextureOffset.x) + TextureOffset.z,
	               (TexCoord.y / TextureOffset.y) + TextureOffset.w );
}

VS_OUTPUT SkinnedAvatarVSFlag(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	
	float4 skinnedPosition = (float4)0;
	float4 skinnedNormal   = (float4)0;
	float4 skinnedTangent  = (float4)0;
	
	float4 vPosition = float4(v.vPosition.xyz, 1.0);

	// skinning
	for( int i = 0; i < SKINNING_INFLUENCES; ++i )
    {
    	float4x4 mat = matBones[ v.boneIndices[i] ];

		float4 offset = mul( vPosition, mat ) * v.boneWeights[i];
		skinnedPosition += offset;
		
		offset = mul( normalize(v.vNormal), mat )  * v.boneWeights[i];
		skinnedNormal += offset;

		offset = mul( normalize(v.vTangent), mat ) * v.boneWeights[i];
		skinnedTangent += offset;
	}
	
	skinnedNormal  = normalize(skinnedNormal);
	skinnedTangent = normalize(skinnedTangent);
	float3 binormal = cross(skinnedTangent.xyz, skinnedNormal.xyz ) * v.vTangent.w;
	normalize(binormal);
	
	// transform light direction into tangent space
	float3x3 matTBN = float3x3(skinnedTangent.xyz, 
	                           binormal,
							   skinnedNormal.xyz);
	Out.LightDirection = mul(matTBN, -normalize(skinnedPosition - CameraPosition + LIGHT_OFFSET_FLAG ));
	Out.EyeVec = mul(matTBN, -normalize(skinnedPosition - (CameraPosition) ));
	
	Out.vPosition = mul(skinnedPosition, ViewProjectionMatrix );
	Out.vTexCoord0 = v.vTexCoord0;
	
	return Out;
}

float4 SkinnedAvatarPSFlag( VS_OUTPUT In ) : COLOR
{
	float t = frac(Time * ANIMATION_SPEED);
	float2 NormalCoord = float2(In.vTexCoord0.x - t, In.vTexCoord0.y );
	
	//return float4(PrimaryColor.rgb,1);
	//return float4(tex2D( NormalMap, NormalCoord ).rgb, 1.0);     // normals
	
	float4 vColor = tex2D( DiffuseMap, GetTexCoordsInAtlas(In.vTexCoord0) );
	//float3 vSpecColor = tex2D( SpecularMap, In.vTexCoord0 ).rgb;
	float3 vNormal = normalize( tex2D( NormalMap, NormalCoord ).rgb * 2.0 - 1 );
	//float3 vNormal = float3(0,0,1);
		
	float3 L = normalize(In.LightDirection);
	float3 E = normalize(In.EyeVec);
	float3 halfVec = normalize(E + L);
	float  NdotL = dot(vNormal, L);
	
	//return float4(E.rgb, 1);
	
	#ifdef LIGHTMODEL_WRAP
	float diffuse = saturate((saturate(NdotL) + WRAP) / (1 + WRAP)) * INTENSITY_FLAG;
	#endif
	#ifdef LIGHTMODEL_HALFLAMBERT
	float diffuse = pow(0.5 * saturate(NdotL) + 0.5, 2) * INTENSITY_FLAG; 
	#endif
	#ifdef LIGHTMODEL_PHONG
	float diffuse = saturate(NdotL) * INTENSITY_FLAG + AMBIENT;
	#endif
	
	    
 	float  specular = pow( saturate( dot(vNormal, halfVec) ), SPECULAR_POWER_FLAG );
    if( NdotL <= 0 )
    {
       specular = 0;
    }
	
	specular *= SPECULARITY_FLAG; // mask
		
	//return float4(NdotL.xxx, 1 );
	//return float4(vColor.rgb * diffuse + specular, 1 );

	vColor.rgb = vColor.rgb  * saturate(diffuse) +  float3(0.0,0.0,0.0);
	float Grey = dot( vColor.rgb, float3( 0.212671f, 0.715160f, 0.072169f ) );
	return float4(lerp( vColor.rgb, Grey.rrr, FLAG_GRAYNESS ) + specular, vColor.a);
}

float4 SkinnedAvatarPSShadow( VS_OUTPUT In ) : COLOR
{
	
	float4 vColor = tex2D( DiffuseMap, In.vTexCoord0 );
	return vColor;
}

float4 SkinnedAvatarPSSmoke( VS_OUTPUT In ) : COLOR
{
	float t = frac(Time * ANIMATION_SPEED);
	float vAlpha = tex2D( DiffuseMap, In.vTexCoord0 ).a;
	float4 vColor = tex2D( DiffuseMap, float2(In.vTexCoord0.x, In.vTexCoord0.y + t ) );
	vColor.a =  vAlpha;
	return vColor;
}

float4 SkinnedAvatarPSTracks( VS_OUTPUT In ) : COLOR
{
	float t = frac(Time * TRACK_SPEED);
	float2 Tex = float2(In.vTexCoord0.x, In.vTexCoord0.y + t);
	float4 vColor = tex2D( DiffuseMap, Tex );
	
	return float4(vColor.rgb, vColor.a); // normal
}

/////////////////////////////////////////////////////

technique Standard
{
	pass p0
	{
		MipMapLodBias[0] = -1.0;
		
		VertexShader = compile vs_2_0 SkinnedAvatarVS();
		PixelShader = compile ps_2_0 SkinnedAvatarPS();
	}
}


technique Flag
{
	pass p0
	{
		VertexShader = compile vs_2_0 SkinnedAvatarVSFlag();
		PixelShader = compile ps_2_0 SkinnedAvatarPSFlag();
	}
}

technique Shadow
{
	pass p0
	{
		ZENABLE = True;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		ZWRITEENABLE = False;
		VertexShader = compile vs_2_0 SkinnedAvatarVS();
		PixelShader = compile ps_2_0 SkinnedAvatarPSShadow();
	}
}

technique Smoke
{
	pass p0
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		
		//SrcBlend = SRCALPHA;
		//DestBlend = ONE;
		
		VertexShader = compile vs_2_0 SkinnedAvatarVS();
		PixelShader = compile ps_2_0 SkinnedAvatarPSSmoke();
	}
}

technique TexAnim
{
	pass p0
	{
		VertexShader = compile vs_2_0 SkinnedAvatarVS();
		PixelShader = compile ps_2_0 SkinnedAvatarPSTracks();
	}
}
