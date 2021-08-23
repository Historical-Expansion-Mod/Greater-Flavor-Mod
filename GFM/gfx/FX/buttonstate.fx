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

float4 PixelShaderOver( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( MapTexture, v.vTexCoord );
    float4 MixColor = float4( 0.1, 0.1, 0.1, 0 );
    OutColor += MixColor;
	OutColor *= Color;
    return OutColor;
}

float4 PixelShaderDown( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( MapTexture, v.vTexCoord );
	float4 MixColor = float4( 0.1, 0.1, 0.1, 0 );
	OutColor -= MixColor;
	OutColor *= Color;
	return OutColor;
}

float4 PixelShaderDisable( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( MapTexture, v.vTexCoord );
    float Grey = dot( OutColor.rgb, float3( 0.212671f, 0.715160f, 0.072169f ) ); 
    OutColor.rgb = Grey;
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
		PixelShader = compile ps_2_0 PixelShaderDown();
	}
}

technique over
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderOver();
	}
}

technique disable
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_2_0 VertexShaderStd();
		PixelShader = compile ps_2_0 PixelShaderDisable();
	}
}
