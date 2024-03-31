texture tex0 < string name = "borders.tga"; >;
texture tex1 < string name = "borderDirections.tga"; >;

//float4x4 WorldViewProjectionMatrix; 
float4x4 WorldMatrix; 
float4x4 ViewMatrix; 
float4x4 ProjectionMatrix; 


sampler BaseTexture1_1  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler BaseTexture2_0  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Point;
    MagFilter = Point;
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

struct VS_OUTPUT_1_1
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
};

struct VS_OUTPUT_2_0
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
};

/////////////////////////////////////////////////////////////////////////////////

VS_OUTPUT_1_1 VertexShader_Border_1_1(const VS_INPUT v )
{
	VS_OUTPUT_1_1 Out = (VS_OUTPUT_1_1)0;

	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0  = v.vTexCoord;

	return Out;
}

float4 PixelShader_Border_1_1( VS_OUTPUT_1_1 v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	float4 BaseColor = tex2D( BaseTexture1_1, v.vTexCoord0 );

	OutColor.a = BaseColor.b;	// * 0.5;
	OutColor.r = BaseColor.r;

	return OutColor;
}

/////////////////////////////////////////////////////////////////////////////////

VS_OUTPUT_2_0 VertexShader_Border_2_0(const VS_INPUT v )
{
	VS_OUTPUT_2_0 Out = (VS_OUTPUT_2_0)0;

	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0  = v.vTexCoord;

	float2 TexCoord = v.vTexCoord;

	TexCoord.x *= 2048;
	TexCoord.y *= 1024;

	Out.vTexCoord1 = TexCoord;

	return Out;
}

float4 PixelShader_Border_2_0( VS_OUTPUT_2_0 v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	float4 BaseColor = tex2D( BaseTexture2_0, v.vTexCoord0 );

	float2 TexCoord = v.vTexCoord1;

	TexCoord %= 1;				// 0 => 1 range.. only thing we need is the decimal part.
	TexCoord.x *= 0.9375;			// 60 pixels color. 4 not.
	//TexCoord.y = 1.0 - TexCoord.y;
	TexCoord.x /= 16;				// it's 16 pieces, make it for the first, and add to x to point it to the right in the pixelshader


	// This weird number is (I think) due to 5-bits of color gives bad precision.
	// 0.97, 0.968 is to little..  somewhere    0.9675 < x < 0.968
	// 0.96, 0.965, 0.9675 is to much
	// 0.98  color on right instead...
	// 0.9678 extremly close but to much (pink is shown in yellow)
	// 0.9679 extremly close but to much (pink is shown in yellow)
	// 0.96   ( PINK is shown in yellow)

	TexCoord.x += ( BaseColor.b * 0.97 );	// 0.97 is ok when we use 60 out of 64 pixels..

	// add and scale here to get bigger or smaller borders depending on zoom?

	float4 Color = tex2D( DirectionsTexture, TexCoord );

	Color.r += BaseColor.r;

	return Color;
}

/////////////////////////////////////////////////////////////////////////////////


technique BorderShader_2_0
{
	pass p0
	{
		fvf = XYZ | Tex1;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;
		Texture[1] = <tex1>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader_Border_2_0();
		PixelShader = compile ps_2_0 PixelShader_Border_2_0();
	}
}


technique BorderShader_1_1
{
	pass p0
	{
		fvf = XYZ | Tex1;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;
		Texture[1] = <tex1>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader_Border_1_1();
		PixelShader = compile ps_1_1 PixelShader_Border_1_1();
	}
}
