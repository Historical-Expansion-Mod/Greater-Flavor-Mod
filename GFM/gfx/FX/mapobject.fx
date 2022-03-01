texture tex0 : Diffuse < string ResourceName = "Diffuse.tga"; >;
texture tex1 : Diffuse < string ResourceName = "FOW.tga"; >;

//float4x4 WorldViewProjectionMatrix	: WorldViewProjection;
float4x4 WorldMatrix			: World;
float4x4 ViewMatrix;
float4x4 ProjectionMatrix;
float4x4 WorldViewProjectionMatrix;

float4x4 AbsoluteWorldMatrix;

float4 LightDirection;
float4 LightAmbient;
float4 LightColor;

sampler2D DiffuseTexture = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

sampler2D TerraIncognitaTexture = 
sampler_state 
{
    texture = <tex1>;
    MIPFILTER = None;
    MINFILTER = Linear;
    MAGFILTER = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VS_INPUT 
{
   float4 Position : POSITION;
   float2 TexCoord : TEXCOORD0;
   float3 Normal   : NORMAL;
};

struct VS_OUTPUT 
{
   float4 Position :        POSITION;
   float2 TexCoord :        TEXCOORD0;
   float3 LightDirection :  TEXCOORD1;
   float2 WorldCoord :      TEXCOORD2;
   float3 Normal :          TEXCOORD3;
   float3 Diffuse  :	    COLOR;
};



VS_OUTPUT MapObject_VS( VS_INPUT In )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
//	float4x4 WorldViewProjectionMatrix = WorldMatrix * ViewMatrix * ProjectionMatrix;
	Out.Position = mul( float4(In.Position.xyz, 1.0f), WorldViewProjectionMatrix );
	Out.Normal = mul( In.Normal, WorldMatrix );
	Out.LightDirection = LightDirection;
	Out.TexCoord = In.TexCoord;

	float4 WorldPosition = mul( In.Position, AbsoluteWorldMatrix );
	Out.WorldCoord = float2( WorldPosition.x/2048.0f, WorldPosition.z/1024.0f );

	return Out;
}



float4 MapObject_PS( VS_OUTPUT In ) : COLOR
{
	float3 LightDirection = -In.LightDirection;
	float3 Normal = normalize(In.Normal.xyz);
	float3 diff = dot( Normal, LightDirection ).xxx;

	diff *= LightColor.rgb;
	float4 Diffuse = tex2D( DiffuseTexture, In.TexCoord );
	float3 ColorOut = Diffuse * LightAmbient + Diffuse * diff;

	ColorOut = lerp( ColorOut , Diffuse.rgb, 0.5 );	// get's to bright otherwise..  could send in "less" light perhaps?

	// Terra incognita
	float4 TerraIncognita = tex2D( TerraIncognitaTexture, In.WorldCoord );
	ColorOut.rgb += ( TerraIncognita.g - 0.25 )*1.33;

	return float4( ColorOut, 1.0f);
}

technique MapObjectShader
{
	pass p0
	{
		VertexShader = compile vs_1_1 MapObject_VS();
		PixelShader = compile ps_2_0 MapObject_PS();
	}
}
