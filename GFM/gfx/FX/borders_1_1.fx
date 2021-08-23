texture tex0 < string ResourceName = "borders.tga"; >;
texture tex1 < string ResourceName = "borderDirections.tga"; >;

float4x4 WorldMatrix		: World; 
float4x4 ViewMatrix		: View; 
float4x4 ProjectionMatrix	: Projection; 


sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler DirectionsTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float2 vTexCoord  : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
};


/////////////////////////////////////////////////////////////////////////////////

VS_OUTPUT VertexShader_Border(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0  = v.vTexCoord;

	return Out;
}

float4 PixelShader_Border( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );

	OutColor.a = BaseColor.b;	// * 0.5;
	OutColor.r = BaseColor.r;

	return OutColor;
}

/////////////////////////////////////////////////////////////////////////////////


technique BorderShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_Border();
		PixelShader = compile ps_1_1 PixelShader_Border();
	}
}
