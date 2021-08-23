texture tex0 < string name = "C:\\Active Projects\\eu3\\game\\gfx\\test\\testred.dds"; >;	// First Texture
texture tex1 < string name = "C:\\Active Projects\\eu3\\game\\gfx\\test\\testred.dds"; >;	// First Texture

float4x4 WorldViewProjectionMatrix; 
float CurrentState;
float4 vFirstColor;
float4 vSecondColor;

sampler TextureOne =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler TextureTwo =
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
    float3 vTexCoord  : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float3  vTexCoord0 : TEXCOORD0;
};


VS_OUTPUT OurVertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
   	Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );
	Out.vTexCoord0  = v.vTexCoord;

	return Out;
}

float4 OurPixelShader( VS_OUTPUT v ) : COLOR
{
	if( v.vTexCoord0.x <= CurrentState )
		return vFirstColor;
	else
		return vSecondColor;
}

float4 OurTexturePixelShader( VS_OUTPUT v ) : COLOR
{
	if( v.vTexCoord0.x <= CurrentState )
		return tex2D( TextureOne, v.vTexCoord0.xy );
	else
		return tex2D( TextureTwo, v.vTexCoord0.xy );
}

float4 ScrollPixelShader( VS_OUTPUT v ) : COLOR
{
	//if( v.vTexCoord0.x > 0.95 )
		//return float4(1.0,1.0,1.0,1.0);
	//else
		//return float4(0.0,0.0,1.0,1.0);
		//return float4(v.vTexCoord0.x,v.vTexCoord0.x,1.0,1.0);
	return tex2D( TextureOne, float2( v.vTexCoord0.x+CurrentState, v.vTexCoord0.y ) );
}

technique tec0
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = True;
		
		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 OurPixelShader();
	}
}

technique ColorProgress
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = True;
		
		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 OurTexturePixelShader();
	}
}

technique ScrollTech
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = True;
		
		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 ScrollPixelShader();
	}
}
