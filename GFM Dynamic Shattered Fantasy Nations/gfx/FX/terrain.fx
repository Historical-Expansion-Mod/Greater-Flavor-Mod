texture tex0 < string name = "Base.tga"; >;	// Base texture
texture tex1 < string name = "Terrain.tga"; >;	// Terrain texture
texture tex2 < string name = "Color.dds"; >;	// Color texture

//float4x4 WorldViewProjectionMatrix; 
float4x4 WorldMatrix; 
float4x4 ViewMatrix; 
float4x4 ProjectionMatrix; 

float3	LightDirection; //Position;

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


sampler MapTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler ColorTexture  =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};


struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float3 vNormal    : NORMAL;
    float2 vTexCoord  : TEXCOORD0;
    float2 vTexCoord2 : TEXCOORD1;
    float4 vDiffuse   : COLOR;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float4  vDiffuse  : COLOR;
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
    float2  vTexCoord2 : TEXCOORD2;
    float3	vLightIntensity : TEXCOORD3;
};

struct VS_OUTPUT_BEACH
{
    float4  vPosition : POSITION;
    float4  vDiffuse  : COLOR;
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
    float2  vTexCoord2 : TEXCOORD2;

	// Later put this into ONE texcoord, this is easier for debugging etc..
    float3  vLightIntensityAndBeach : TEXCOORD3;
};

struct VS_INPUT_PTI
{
    float4 vPosition  : POSITION;
};

struct VS_OUTPUT_PTI
{
    float4  vPosition : POSITION;
};


VS_OUTPUT VertexShader_Map(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	float3 VertexNormal = mul( v.vNormal, WorldMatrix );

//	float dist = length( P - LightPosition );
	float3 direction = normalize( LightDirection ); // P - LightPosition );
	Out.vLightIntensity.x = max( dot( VertexNormal, -direction ), 0.3f );
	Out.vDiffuse   = v.vDiffuse;
	Out.vTexCoord0  = v.vTexCoord;
	Out.vTexCoord1  = v.vTexCoord;
	Out.vTexCoord2  = v.vTexCoord2;

	return Out;
}

float4 PixelShader_Map( VS_OUTPUT v ) : COLOR
{
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );
	float4 TerrainColor = tex2D( MapTexture, v.vTexCoord1 );
	float4 Color = tex2D( ColorTexture, v.vTexCoord2 );
	float4 OutColor = ( TerrainColor.rgba*TerrainColor.a + ( 1.0f - TerrainColor.a ) * BaseColor.rgba ) * v.vLightIntensity.x;
	OutColor.rgb *= Color.rgb;
	return OutColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


VS_OUTPUT_BEACH VertexShader_Beach(const VS_INPUT v )
{
	VS_OUTPUT_BEACH Out = (VS_OUTPUT_BEACH)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	float3 VertexNormal = mul( v.vNormal, WorldMatrix );

//	float dist = length( P - LightPosition );
	float3 direction = normalize( LightDirection ); // P - LightPosition );
	Out.vLightIntensityAndBeach.x = max( dot( VertexNormal, -direction ), 0.3f );
	Out.vDiffuse   = v.vDiffuse;
	Out.vTexCoord0  = v.vTexCoord;
	Out.vTexCoord1  = v.vTexCoord;
	Out.vTexCoord2  = v.vTexCoord2;

	Out.vLightIntensityAndBeach.y = v.vPosition.y*2.0f;	// perhaps *4 instead?

	return Out;
}

float4 PixelShader_Beach( VS_OUTPUT_BEACH v ) : COLOR
{
	float4 BaseColor = tex2D( BaseTexture, v.vTexCoord0 );
	float4 TerrainColor = tex2D( MapTexture, v.vTexCoord1 );
	float4 OutColor = TerrainColor*v.vLightIntensityAndBeach.y + ( 1.0f - v.vLightIntensityAndBeach.y ) * BaseColor;
	float4 Color = tex2D( ColorTexture, v.vTexCoord2 );
	OutColor *= v.vLightIntensityAndBeach.x;
	OutColor.rgb *= Color.rgb;
	OutColor.a = 1;
	return OutColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


VS_OUTPUT_PTI VertexShader_PTI(const VS_INPUT_PTI v )
{
	VS_OUTPUT_PTI Out = (VS_OUTPUT_PTI)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	return Out;
}

float4 PixelShader_PTI( VS_OUTPUT_PTI v ) : COLOR
{
	return float4( 0.1, 0.1, 0.1, 1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


technique TerrainShader
{
	pass p0
	{
		fvf = XYZ | Normal | Diffuse | Tex2;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;
		Texture[1] = <tex1>;
		Texture[2] = <tex2>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader_Map();
		PixelShader = compile ps_1_1 PixelShader_Map();
	}
}

technique BeachShader
{
	pass p0
	{
		fvf = XYZ | Normal | Diffuse | Tex2;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;
		Texture[1] = <tex1>;
		Texture[2] = <tex2>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader_Beach();
		PixelShader = compile ps_1_1 PixelShader_Beach();
	}
}

technique PTIShader
{
	pass p0
	{
		fvf = XYZ;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader_PTI();
		PixelShader = compile ps_1_1 PixelShader_PTI();
	}
}
