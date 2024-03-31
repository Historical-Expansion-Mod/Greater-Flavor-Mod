texture tex0;

float4x4 ProjectionMatrix; 
float4x4 TextureMatrix; 
float4x4 WorldViewMatrix;
float4x4 WorldMatrix;
float4x4 ViewMatrix;
float Alpha;

#define LAND_ALT 0.25

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
//    AddressU = Wrap;//Clamp;
  //  AddressV = Wrap;//Clamp;
	AddressU = Clamp;
    AddressV = Clamp;

	MipFilter = None;
	MagFilter = Linear;
    MinFilter = Linear;	
};

struct VS_INPUT
{
    float2 vPosition  : POSITION;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float3  vTexCoord0 : TEXCOORD0;
};


VS_OUTPUT GeneralVertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);

	float4 WorldPos = mul(vPosition, WorldView);
	Out.vPosition  = mul(WorldPos, ProjectionMatrix );
	Out.vTexCoord0  = mul(vPosition, TextureMatrix).xyz;

	return Out;
}


float4 GeneralPixelShader( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	return OutColor;
}


technique tec0
{
	pass p0
	{
		ZENABLE = False;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;

		VertexShader = compile vs_2_0 GeneralVertexShader();
		PixelShader = compile ps_2_0 GeneralPixelShader();
	}
}
