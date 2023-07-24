texture tex0 < string name = "C:\\Active Projects\\eu3\\game\\gfx\\test\\testred.dds"; >;	// Base texture

float4x4 WorldViewProjectionMatrix; 
float Zoom = 1;

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


VS_OUTPUT VertexShader_MapWidget(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
   	Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );

	float2 TexCoord = v.vTexCoord;
	TexCoord -= 0.5;
	TexCoord /= Zoom;
	TexCoord += 0.5;
	Out.vTexCoord  = TexCoord;

	return Out;
}

float4 PixelShader_MapWidget( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord );
	OutColor.a = 0.5;
  	return OutColor;
}

technique MapWidget
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;

		VertexShader = compile vs_1_1 VertexShader_MapWidget();
		PixelShader = compile ps_2_0 PixelShader_MapWidget();
	}
}
