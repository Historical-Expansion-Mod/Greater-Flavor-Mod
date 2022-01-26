texture tex0 < string name = "sdf"; >;	// Base texture

float4x4 WorldViewProjectionMatrix; 
float4	 FlagCoords;

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float3 vNormal    : NORMAL;
    float2 vTexCoord  : TEXCOORD0;
    float4 vDiffuse   : COLOR;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
    float4  vDiffuse   : COLOR;
};


VS_OUTPUT VertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );

	Out.vTexCoord0.x = v.vTexCoord.x/FlagCoords.x;
	Out.vTexCoord0.x = Out.vTexCoord0.x + FlagCoords.z;
	Out.vTexCoord0.y = v.vTexCoord.y/FlagCoords.y;
	Out.vTexCoord0.y = Out.vTexCoord0.y + FlagCoords.w;

	Out.vDiffuse = v.vDiffuse;

	return Out;
}


float4 PixelShader( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	OutColor.a *= v.vDiffuse.a;
	
	return OutColor;
}


technique tec0
{
	pass p0
	{
		fvf = XYZ | Normal | Diffuse | Tex1;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader();
		PixelShader = compile ps_1_1 PixelShader();
	}
}
