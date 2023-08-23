texture tex0 < string name = "River.tga"; >;
texture tex1 < string name = "RiverMovement.tga"; >;
texture tex2 < string name = "TerraIncog.dds"; >;		// Borders texture
texture tex3 < string name = "colormap_rivers.dds"; >;


#define X_OFFSET 0.5
#define Z_OFFSET 0.5

float4x4 WorldMatrix; 
float4x4 ViewMatrix; 
float4x4 ProjectionMatrix; 
float4x4 AbsoluteWorldMatrix;
float	 vTime;

float	ColorMapHeight;
float	ColorMapWidth;

float	ColorMapTextureHeight;
float	ColorMapTextureWidth;

float	MapWidth;
float	MapHeight;

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = clamp;
    AddressV = clamp;
};

sampler AnimatedTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler TerraIncognitaTexture =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler Water =
sampler_state
{
    Texture = <tex3>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};


struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float2 vTexCoord0 : TEXCOORD0;
    float2 vTexCoord1 : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4  vPosition  : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
    float2  vTerrainTexCoord : TEXCOORD2;
    float2  vWaterTexCoord : TEXCOORD3;
};


VS_OUTPUT VertexShader_River(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(v.vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	
	//Out.vPosition.z = Out.vPosition.z - 1.5f;
	
	Out.vTexCoord0 = v.vTexCoord0;
	Out.vTexCoord1 = v.vTexCoord1 - float2( 0, vTime* 0.3 );

	float4 WorldPosition = mul( v.vPosition, AbsoluteWorldMatrix );
	Out.vTerrainTexCoord  = float2( WorldPosition.x/2048.0f, WorldPosition.z/1024.0f );
	
	float WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	float WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	
	Out.vWaterTexCoord = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );

	//Out.vWaterTexCoord = float2( WorldPosition.x/936.0f, WorldPosition.z/360.0f );

	return Out;
}

const float waterColorModValue = -0.3;

float4 PixelShader_River( VS_OUTPUT v ) : COLOR
{
	//return float4(1,0,0,1);
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	
	//return OutColor;
	float4 Movement = tex2D( AnimatedTexture, v.vTexCoord1 );
	//return Movement;
	float4 WaterColor = tex2D( Water, v.vWaterTexCoord );
	//return WaterColor;
	OutColor.rgb = (WaterColor.rgb+waterColorModValue) * Movement.a + OutColor.rgb * ( 1.0 - Movement.a );
	OutColor.rgb += Movement.rgb;
	//OutColor.a = WaterColor.a;
	
	// Terra incognita
	//float4 TerraIncognita = tex2D( TerraIncognitaTexture, v.vTerrainTexCoord );
	//OutColor.rgb += ( TerraIncognita.g - 0.25 )*1.33;

	return OutColor;
}

technique RiverShader
{
	pass p0
	{
		ALPHABLENDENABLE = true;
		ALPHATESTENABLE = true;

		VertexShader = compile vs_1_1 VertexShader_River();
		PixelShader = compile ps_2_0 PixelShader_River();
	}
}
