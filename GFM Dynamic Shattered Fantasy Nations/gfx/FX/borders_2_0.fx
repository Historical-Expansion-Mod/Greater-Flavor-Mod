texture tex0 < string ResourceName = "borders.tga"; >;
texture tex1 < string ResourceName = "borderDirections.tga"; >;
texture tex2 < string ResourceName = "TerraIncog.tga"; >;
texture tex3 < string ResourceName = "Diag.tga"; >;
texture tex4 < string ResourceName = "ColorWater.tga"; >;

float4x4 WorldMatrix		: World; 
float4x4 ViewMatrix		: View; 
float4x4 ProjectionMatrix	: Projection; 

//Depends on mapsize
#define EXTRA_U 0.0075f

#define X_OFFSET 0.5
#define Z_OFFSET 0.5

float	ColorMapHeight;
float	ColorMapWidth;

float	ColorMapTextureHeight;
float	ColorMapTextureWidth;

float	MapWidth;
float	MapHeight;

float	BorderTextureWidth;
float	BorderTextureHeight;

//_pBordersAndTerraIncogFOWTexture
sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Point; //Linear; //Point;
    MagFilter = Point; //Linear; //Point;
    MipFilter = None;
    AddressU = Clamp; //Wrap;
    AddressV = Clamp; //Wrap;
};

//province_border.dds
sampler ProvinceBorderTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Clamp; //Wrap;
    AddressV = Clamp; //Wrap;
};

//_pBordersAndTerraIncogFOWTexture
sampler TerraIncognitaFiltered  =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

//Borderdiags...
sampler ProvinceBorderDiagTexture  =
sampler_state
{
    Texture = <tex3>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp; //Wrap;
    AddressV = Clamp; //Wrap;
};

//Colormap_water
sampler ColorWaterTexture  =
sampler_state
{
    Texture = <tex4>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp; //Wrap;
    AddressV = Clamp; //Wrap;
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
    float2  vTexCoord1 : TEXCOORD1;
	float2	vColorTex  : TEXCOORD2;
};

struct VS_WATERINPUT
{
    float4 vPosition  : POSITION;
    float2 vProvCoord  : TEXCOORD0;
    float2 vDiagCoord  : TEXCOORD1;    
};

struct VS_WATEROUTPUT
{
    float4 vPosition  : POSITION;
    float2 vProvCoord  : TEXCOORD0;
    float2 vDiagCoord  : TEXCOORD1;    
};


/////////////////////////////////////////////////////////////////////////////////

#define WATER_BORDER_ALT 0.0

float4x4 WorldViewProjectionMatrix;

VS_WATEROUTPUT VertexShader_WaterBorder(const VS_WATERINPUT v )
{
	float4 vPosition = float4( v.vPosition.x, WATER_BORDER_ALT, v.vPosition.y, 1 );
	VS_WATEROUTPUT Out = (VS_WATEROUTPUT)0;

	//float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	//float3 P = mul(v.vPosition, (float4x3)WorldView);
	//Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	
	//TODO remove this strange number
	float3 P = vPosition;
	P.z -= 0.7;
	Out.vPosition = mul( float4(P , 1.0), WorldViewProjectionMatrix );

	Out.vPosition.y += 2.0;

	Out.vProvCoord  = v.vProvCoord;
	Out.vDiagCoord  = v.vDiagCoord;

	return Out;
}

float4 PixelShader_WaterBorder( VS_WATEROUTPUT v ) : COLOR
{
	float4 Color = tex2D( ProvinceBorderTexture, v.vProvCoord );
	Color.rgb *= Color.a;
	
	float4 DiagColor = tex2D( ProvinceBorderDiagTexture, v.vDiagCoord );
	DiagColor.rgb *= DiagColor.a;

	Color.rgb = max( DiagColor.rgb, Color.rgb );
	Color.a = max( Color.a, DiagColor.a );
	return Color;
}


VS_OUTPUT VertexShader_Border(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0  = v.vTexCoord;
	
	Out.vTexCoord0.y += EXTRA_U;//0.0293f;
	
	Out.vColorTex.x = (ColorMapWidth * Out.vTexCoord0.x) / MapWidth;
	Out.vColorTex.y = (ColorMapHeight * Out.vTexCoord0.y) / MapHeight;
	
	float2 TexCoord = v.vTexCoord;
	TexCoord.y += 0.0293f;

	TexCoord.x *= BorderTextureWidth;
	TexCoord.y *= BorderTextureHeight;

	Out.vTexCoord1 = TexCoord;

	return Out;
}

float4 PixelShader_ProvinceBorder( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	
	
	//v.vTexCoord0.y -= (0f;
	
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );

	float2 TexCoord = v.vTexCoord1;

	TexCoord %= 1;				// 0 => 1 range.. only thing we need is the decimal part.
	TexCoord.y = ( 1.0 - TexCoord.y );// * 0.25;
	TexCoord.x /= 16;				// it's 32 pieces, make it for the first, and add to x to point it to the right in the pixelshader
	TexCoord.x *= 0.8;

	float2 TexCoord2 = TexCoord;
	TexCoord.x += BaseColor.b;
	TexCoord2.x += BaseColor.a;

	float4 Color = tex2D( ProvinceBorderTexture, TexCoord );
	Color.rgb *= Color.a;
	float4 DiagColor = tex2D( ProvinceBorderDiagTexture, TexCoord2 );
	DiagColor.rgb *= DiagColor.a;

//	Color.rgb += DiagColor.rgb;
	Color.rgb = max( DiagColor.rgb, Color.rgb );
	Color.a = max( Color.a, DiagColor.a );

	float4 TerraIncognita = tex2D( TerraIncognitaFiltered, v.vTexCoord0 );
	Color.rgb += ( TerraIncognita.g - 0.25 )*1.33;
	//Color.a += max( ( TerraIncognita.g - 0.25 )*1.33, 0 );

	Color.rgb += tex2D( ColorWaterTexture, v.vColorTex ).aaa;
	
	return Color;
}

// only difference right now is it uses .r instead of .b
float4 PixelShader_CountryBorder( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );

	float2 TexCoord = v.vTexCoord1;

	TexCoord %= 1;				// 0 => 1 range.. only thing we need is the decimal part.
	//TexCoord.y *= 0.25;
	TexCoord.x *= 0.9375;			// 60 pixels color. 4 not.
	TexCoord.x /= 16;				// it's 16 pieces, make it for the first, and add to x to point it to the right in the pixelshader


	// This weird number is (I think) due to 5-bits of color gives bad precision.
	// 0.97, 0.968 is to little..  somewhere    0.9675 < x < 0.968
	// 0.96, 0.965, 0.9675 is to much
	// 0.98  color on right instead...
	// 0.9678 extremly close but to much (pink is shown in yellow)
	// 0.9679 extremly close but to much (pink is shown in yellow)
	// 0.96   ( PINK is shown in yellow)

	TexCoord.x += ( BaseColor.r * 0.97 );	// 0.97 is ok when we use 60 out of 64 pixels..

	// add and scale here to get bigger or smaller borders depending on zoom?

	float4 Color = tex2D( ProvinceBorderTexture, TexCoord );
	
	return Color;
}

// only difference right now is it uses .g instead of .b
float4 PixelShader_River( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = float4( 0.1, 0.1, 0.1, 0 );
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );

	float2 TexCoord = v.vTexCoord1;

	TexCoord %= 1;				// 0 => 1 range.. only thing we need is the decimal part.
	//TexCoord.y *= 0.25;
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

	TexCoord.x += ( BaseColor.g * 0.99 ); //0.98 );	// 0.97 is ok when we use 60 out of 64 pixels..

	// add and scale here to get bigger or smaller borders depending on zoom?

	float4 Color = tex2D( ProvinceBorderTexture, TexCoord );

	return Color;
}

/////////////////////////////////////////////////////////////////////////////////


technique ProvinceBorderShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_Border();
		PixelShader = compile ps_2_0 PixelShader_ProvinceBorder();
	}
}


technique CountryBorderShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_Border();
		PixelShader = compile ps_2_0 PixelShader_CountryBorder();
	}
}

technique RiverShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_Border();
		PixelShader = compile ps_2_0 PixelShader_River();
	}
}

technique WaterBorderShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_WaterBorder();
		PixelShader = compile ps_2_0 PixelShader_WaterBorder();
	}
}