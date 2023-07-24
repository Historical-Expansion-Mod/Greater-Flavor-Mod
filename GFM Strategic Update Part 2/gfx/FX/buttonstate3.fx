texture tex0 < string name = "Texture.tga"; >;

float4x4 WorldViewProjectionMatrix;
float4 Color = float4( 1, 1, 1, 1 );
float  vXOffset = 0;					// For textures with more than one frame

sampler MapTexture  =
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
    float2 vTexCoord  : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord : TEXCOORD0;
};


VS_OUTPUT VertexShaderStd(const VS_INPUT v )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
    Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );

    Out.vTexCoord  = v.vTexCoord;
	Out.vTexCoord.x += vXOffset;
    return Out;
}

float4 PixelShaderUp( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( MapTexture, v.vTexCoord );
	OutColor *= Color;
 
    return OutColor;
}

technique up
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderUp();
	}
}

technique down
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderUp();
	}
}

technique over
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderUp();
	}
}

technique disable
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderUp();
	}
}
