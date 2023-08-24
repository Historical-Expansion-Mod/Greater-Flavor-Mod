#define BRIGHTNESS 0.05 //-0.03
#define CONTRAST 1.0
#define DESATURATION 0.3

#define X_OFFSET 0.5
#define Z_OFFSET 0.5

#define LIGHTNESS 1.0

#define LAND_ALT 0.35
#define SEA_FLOOR_ALT 0.0

#define X_MAGIC 1.0f
#define Y_MAGIC 0.0f

texture tex0 < string ResourceName = "Base.tga"; >;		// Base texture
texture tex1 < string ResourceName = "Terrain.tga"; >;	// Terrain texture
texture tex2 < string ResourceName = "Color.dds"; >;		// Color texture
texture tex3 < string ResourceName = "Alpha.dds"; >;		// Terrain Alpha Mask
texture tex4 < string ResourceName = "BorderDirection.dds"; >;	// Borders texture
texture tex5 < string ResourceName = "ProvinceBorders.dds"; >;
texture tex6 < string ResourceName = "CountryBorders.dds"; >;
texture tex7 < string ResourceName = "TerraIncog.dds"; >;


float4x4 WorldMatrix		: World; 
float4x4 ViewMatrix		: View; 
float4x4 ProjectionMatrix	: Projection; 
float4x4 AbsoluteWorldMatrix;
float3	 LightDirection;
float3	CameraPosition;
float	 vAlpha;

float	ColorMapHeight;
float	ColorMapWidth;

float	ColorMapTextureHeight;
float	ColorMapTextureWidth;

float	MapWidth;
float	MapHeight;

float	BorderWidth;
float	BorderHeight;

const float3 GREYIFY = float3( 0.212671, 0.715160, 0.072169 );

float3 ApplyFOWColor( float3 c, float FOW ) 
{
	float Grey = dot( c.rgb, GREYIFY );
	return lerp( Grey.rrr * 0.4, c.rgb, FOW > 0.8 ? 1.0 : 0.3 );
}

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = Linear; //None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler TreeTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};


sampler MapTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = Linear; //None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler NoiseTexture  =
sampler_state
{
    Texture = <tex5>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = Linear; //None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler OverlayTexture  =
sampler_state
{
    Texture = <tex5>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = Linear; //None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler StripesTexture  =
sampler_state
{
    Texture = <tex7>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};


sampler ColorTexture  =
sampler_state
{
    Texture = <tex4>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

// used for political, religious etc etc..
sampler GeneralTexture  =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler GeneralTexture2  =
sampler_state
{
    Texture = <tex3>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};


sampler TerrainAlphaTexture  =
sampler_state
{
    Texture = <tex3>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler TextureSheet  =
sampler_state
{
    Texture = <tex6>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler BorderDirectionTexture  =
sampler_state
{
    Texture = <tex4>;
    MinFilter = Linear;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler WinterTexture  =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler BorderTexture  =
sampler_state
{
    Texture = <tex2>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler QuadIndexTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Point; //Linear;
    MagFilter = Point; //Linear;
    MipFilter = None;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler TerraIncognitaTextureTerrain =
sampler_state
{
    Texture = <tex7>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};

sampler TerraIncognitaTextureTree =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};


struct VS_INPUT
{
    float2 vPosition  : POSITION;
    int2 vProvinceId : TEXCOORD0;
};

struct VS_BORDER_INPUT
{
	int4 vPositionBorderLookup : POSITION;
	float4 vBorderOffsetColor : COLOR0;
};

struct VS_INPUT_BEACH
{
    float2 vPosition  : POSITION;
    float4 vTerrainIndexColor : COLOR0;
  //  float2 vPixelCoord : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float3  vTexCoord0 : TEXCOORD0;	// third beein' lightIntensity
    float2  vTexCoord1 : TEXCOORD1;
    float2  vColorTexCoord : TEXCOORD2;

    float2  vBorderTexCoord0 : TEXCOORD3;
    float2  vBorderTexCoord1 : TEXCOORD4;

    float2  vTerrainTexCoord : TEXCOORD5;

    float2 vProvinceIndexCoord  : TEXCOORD6;
    float4 vBorderOffsetColor : COLOR0;
    
    
};

struct VS_MAP_OUTPUT
{
    float4  vPosition : POSITION;
    float3  vTexCoord0 : TEXCOORD0;	// third beein' lightIntensity
    float2  vTexCoord1 : TEXCOORD1;
    float2  vColorTexCoord : TEXCOORD2;
	float2	vProvinceId : TEXCOORD3;
    float2  vTerrainTexCoord : TEXCOORD4; 
    float4	vTerrainIndexColor : TEXCOORD5;
	float4 vPosTex : TEXCOORD6; // workarounds
};

struct VS_OUTPUT_BEACH
{
    float4  vPosition : POSITION;
    float2  vTexCoordBase : TEXCOORD0;
    float2  vColorTexCoord : TEXCOORD1;
	// Later put this into ONE texcoord, this is easier for debugging etc..
    float3  vLightIntensity : TEXCOORD2;
    float2 vProvinceIndexCoord  : TEXCOORD3;
    float2 vBorderTexCoord0		: TEXCOORD4;
    
    float4 vTerrainIndexColor : TEXCOORD5;
    float2  vTexCoord1 : TEXCOORD6;
    float4 vBorderOffsetColor : COLOR0;
};

struct VS_INPUT_PTI
{
    float2 vPosition  : POSITION;
};

struct VS_OUTPUT_PTI
{
    float4  vPosition : POSITION;
};


struct VS_INPUT_TREE
{
    float3 vPosition : POSITION;
    float2 vTexCoord : TEXCOORD0;
};

struct VS_OUTPUT_TREE
{
    float4 vPosition   : POSITION;
    float2 vTexCoord   : TEXCOORD0;
    float2 vTexCoordTI : TEXCOORD1;
};

///////	//////////////////////////////////////////////////////////////////////////


float TerrainIndexOffsetX;
float TerrainIndexOffsetY;

float TerrainIndexSizeX;
float TerrainIndexSizeY;

#define TILE_STRETCH_FACTOR 8.0
#define TILE_STRETCH_DIVIDE 0.125 //1.0 / TILE_STRETCH_FACTOR


//Change these when changing num tiles....
const float NUM_TILES_X = 1.0/8.0;
const float NUM_TILES_Y = 1.0/8.0;


//32.0 = 64 textures    16.0 = 256 textures
#define NUM_TERRAINS_FACTOR 32.0 //NUM_TILES_X * 256.0 / Num Terrains?
#define X_CLAMP 0.125
#define Y_CLAMP 0.125
//...

struct TILE_STRUCT
{
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
    float2  vColorTexCoord : TEXCOORD2;
    float4 vTerrainIndexColor : COLOR0;
};


float4 GenerateTiles( TILE_STRUCT v )
{
	float4 IndexColor = tex2D( QuadIndexTexture, v.vTerrainIndexColor.xy ); //Coordinates for for quad texture of index colors
	float4 ColorColor = tex2D( ColorTexture, v.vTexCoord1 ); //Coordinates for colormap

	float2 noisecoord = v.vTexCoord0+0.5;
	float3 noisy = tex2D(NoiseTexture, noisecoord ).rgb;

	IndexColor *= 256.0; //size of colorbyte

	float4 IndexCoordX = fmod(IndexColor, NUM_TERRAINS_FACTOR); //x coord in tiles sheet
	IndexCoordX = trunc(IndexCoordX);
	float4 vIndexCoordX = IndexCoordX / NUM_TERRAINS_FACTOR;
	
	float4 IndexCoordY = IndexColor / NUM_TERRAINS_FACTOR; //y coord in tiles sheet
	IndexCoordY = trunc(IndexCoordY);
	float4 vIndexCoordY = IndexCoordY * NUM_TILES_Y;
	
	float2 TexCoord = v.vColorTexCoord + 0.5;
	TexCoord = frac( TexCoord ); // 0 => 1 range.. only thing we need is the decimal part.
	TexCoord.x = 1.0 - TexCoord.x;
	
	float2 PixelTexCoord = v.vTexCoord0;
	PixelTexCoord = frac( PixelTexCoord ); // 0 => 1 range.. only thing we need is the decimal part.
	
	TexCoord.x *= NUM_TILES_X;
	TexCoord.y *= (NUM_TILES_Y - 0.001);
	
	TexCoord.x = clamp( TexCoord.x, 0.001, X_CLAMP );
	TexCoord.y = clamp( TexCoord.y, 0.001, Y_CLAMP );
	
	float2 uvThis;
	uvThis.x = vIndexCoordX.x;
	uvThis.y = vIndexCoordY.x;

	float4 LeftTerrain = tex2D( TextureSheet, TexCoord + uvThis );
	
	uvThis.x = vIndexCoordX.y;
	uvThis.y = vIndexCoordY.y;
	
	float4 UpLeftTerrain = tex2D( TextureSheet, TexCoord + uvThis );
	
	uvThis.x = vIndexCoordX.z;
	uvThis.y = vIndexCoordY.z;

	float4 Terrain = tex2D( TextureSheet, TexCoord + uvThis ); //->left
	
	//return Terrain;	
	uvThis.x = vIndexCoordX.w;
	uvThis.y = vIndexCoordY.w;
	
	float4 UpTerrain = tex2D( TextureSheet, TexCoord + uvThis ); //->upleft
	
	
	
//	noisy.x = tex2D(NoiseTexture, noisecoord / 12 ).r;
//	noisy.y = tex2D(NoiseTexture, noisecoord / 2 + 1.5 ).r;
//	noisy.z = tex2D(NoiseTexture, noisecoord / 6 + 2.0 ).r;
			  		
	//noisy -= 0.5;
	//noisy *= 0.8;
	
	float4 x1 = lerp( LeftTerrain, Terrain, saturate( PixelTexCoord.x + noisy.x)  );
	float4 x2 = lerp( UpLeftTerrain, UpTerrain, saturate( PixelTexCoord.x + noisy.y) );
	float4 y1 = lerp( x1,x2, saturate( PixelTexCoord.y + noisy.z)  );


	// Comment out this line for no colormap
	y1 = ((y1*2.0f + ColorColor))/3.0f;
				
	return y1;
}

float GenerateHeight( TILE_STRUCT v )
{
	float4 IndexColor = tex2Dlod( QuadIndexTexture, float4(v.vTerrainIndexColor.xy, 0, 0) ); //Coordinates for for quad texture of index colors
	
	float2 noisecoord = v.vTexCoord0+0.5;
	float3 noisy = tex2Dlod(NoiseTexture, float4( noisecoord, 0, 0 ) ).rgb;
	
	IndexColor *= 256.0; //size of colorbyte

	float4 IndexCoordX = fmod(IndexColor, NUM_TERRAINS_FACTOR); //x coord in tiles sheet
	IndexCoordX = trunc(IndexCoordX);
	float4 vIndexCoordX = IndexCoordX / NUM_TERRAINS_FACTOR;
	
	float4 IndexCoordY = IndexColor / NUM_TERRAINS_FACTOR; //y coord in tiles sheet
	IndexCoordY = trunc(IndexCoordY);
	float4 vIndexCoordY = IndexCoordY * NUM_TILES_Y;
	
	float2 TexCoord = v.vColorTexCoord + 0.5;
	TexCoord = frac( TexCoord ); // 0 => 1 range.. only thing we need is the decimal part.
	TexCoord.x = 1.0 - TexCoord.x;
	
	float2 PixelTexCoord = v.vTexCoord0;
	PixelTexCoord = frac( PixelTexCoord ); // 0 => 1 range.. only thing we need is the decimal part.
	
	TexCoord.x *= NUM_TILES_X;
	TexCoord.y *= (NUM_TILES_Y - 0.001);
	
	TexCoord.x = clamp( TexCoord.x, 0.001, X_CLAMP );
	TexCoord.y = clamp( TexCoord.y, 0.001, Y_CLAMP );
	
	float2 uvThis;
	uvThis.x = vIndexCoordX.x;
	uvThis.y = vIndexCoordY.x;

	float4 LeftTerrain = tex2Dlod( TextureSheet, float4(TexCoord + uvThis, 0, 0) );
	
	uvThis.x = vIndexCoordX.y;
	uvThis.y = vIndexCoordY.y;
	
	float4 UpLeftTerrain = tex2Dlod( TextureSheet, float4(TexCoord + uvThis, 0, 0) );
	
	uvThis.x = vIndexCoordX.z;
	uvThis.y = vIndexCoordY.z;

	float4 Terrain = tex2Dlod( TextureSheet, float4(TexCoord + uvThis, 0, 0) ); //->left
	
	//return Terrain;	
	uvThis.x = vIndexCoordX.w;
	uvThis.y = vIndexCoordY.w;
	
	float4 UpTerrain = tex2Dlod( TextureSheet, float4(TexCoord + uvThis, 0, 0) ); //->upleft
	
	float x1 = lerp( LeftTerrain.a, Terrain.a, saturate( PixelTexCoord.x + noisy.x) );
	float x2 = lerp( UpLeftTerrain.a, UpTerrain.a, saturate( PixelTexCoord.x + noisy.y) );
	float y1 = lerp( x1, x2, saturate( PixelTexCoord.y + noisy.z) );
	
	return y1;
	
}

float4x4 inverse(float4x4 m) {
    float n11 = m[0][0], n12 = m[1][0], n13 = m[2][0], n14 = m[3][0];
    float n21 = m[0][1], n22 = m[1][1], n23 = m[2][1], n24 = m[3][1];
    float n31 = m[0][2], n32 = m[1][2], n33 = m[2][2], n34 = m[3][2];
    float n41 = m[0][3], n42 = m[1][3], n43 = m[2][3], n44 = m[3][3];

    float t11 = n23 * n34 * n42 - n24 * n33 * n42 + n24 * n32 * n43 - n22 * n34 * n43 - n23 * n32 * n44 + n22 * n33 * n44;
    float t12 = n14 * n33 * n42 - n13 * n34 * n42 - n14 * n32 * n43 + n12 * n34 * n43 + n13 * n32 * n44 - n12 * n33 * n44;
    float t13 = n13 * n24 * n42 - n14 * n23 * n42 + n14 * n22 * n43 - n12 * n24 * n43 - n13 * n22 * n44 + n12 * n23 * n44;
    float t14 = n14 * n23 * n32 - n13 * n24 * n32 - n14 * n22 * n33 + n12 * n24 * n33 + n13 * n22 * n34 - n12 * n23 * n34;

    float det = n11 * t11 + n21 * t12 + n31 * t13 + n41 * t14;
    float idet = 1.0f / det;

    float4x4 ret;

    ret[0][0] = t11 * idet;
    ret[0][1] = (n24 * n33 * n41 - n23 * n34 * n41 - n24 * n31 * n43 + n21 * n34 * n43 + n23 * n31 * n44 - n21 * n33 * n44) * idet;
    ret[0][2] = (n22 * n34 * n41 - n24 * n32 * n41 + n24 * n31 * n42 - n21 * n34 * n42 - n22 * n31 * n44 + n21 * n32 * n44) * idet;
    ret[0][3] = (n23 * n32 * n41 - n22 * n33 * n41 - n23 * n31 * n42 + n21 * n33 * n42 + n22 * n31 * n43 - n21 * n32 * n43) * idet;

    ret[1][0] = t12 * idet;
    ret[1][1] = (n13 * n34 * n41 - n14 * n33 * n41 + n14 * n31 * n43 - n11 * n34 * n43 - n13 * n31 * n44 + n11 * n33 * n44) * idet;
    ret[1][2] = (n14 * n32 * n41 - n12 * n34 * n41 - n14 * n31 * n42 + n11 * n34 * n42 + n12 * n31 * n44 - n11 * n32 * n44) * idet;
    ret[1][3] = (n12 * n33 * n41 - n13 * n32 * n41 + n13 * n31 * n42 - n11 * n33 * n42 - n12 * n31 * n43 + n11 * n32 * n43) * idet;

    ret[2][0] = t13 * idet;
    ret[2][1] = (n14 * n23 * n41 - n13 * n24 * n41 - n14 * n21 * n43 + n11 * n24 * n43 + n13 * n21 * n44 - n11 * n23 * n44) * idet;
    ret[2][2] = (n12 * n24 * n41 - n14 * n22 * n41 + n14 * n21 * n42 - n11 * n24 * n42 - n12 * n21 * n44 + n11 * n22 * n44) * idet;
    ret[2][3] = (n13 * n22 * n41 - n12 * n23 * n41 - n13 * n21 * n42 + n11 * n23 * n42 + n12 * n21 * n43 - n11 * n22 * n43) * idet;

    ret[3][0] = t14 * idet;
    ret[3][1] = (n13 * n24 * n31 - n14 * n23 * n31 + n14 * n21 * n33 - n11 * n24 * n33 - n13 * n21 * n34 + n11 * n23 * n34) * idet;
    ret[3][2] = (n14 * n22 * n31 - n12 * n24 * n31 - n14 * n21 * n32 + n11 * n24 * n32 + n12 * n21 * n34 - n11 * n22 * n34) * idet;
    ret[3][3] = (n12 * n23 * n31 - n13 * n22 * n31 + n13 * n21 * n32 - n11 * n23 * n32 - n12 * n21 * n33 + n11 * n22 * n33) * idet;

    return ret;
}

const float vXStretch = 16; //higher gives textures more stretch change both values
const float vYStretch = 16;

///////////////////////////////////////////////////////////////////////////////////////
// Map vertex shaders
///////////////////////////////////////////////////////////////////////////////////////
#define PROVINCE_LOOKUP_SIZE 256.0f
VS_MAP_OUTPUT VertexShader_Map_General(const VS_INPUT v )
{
	VS_MAP_OUTPUT Out = (VS_MAP_OUTPUT)0;

	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	Out.vPosTex = Out.vPosition;


	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );

	///////New Stuff

	float WorldX = WorldPosition.x;
	float WorldY = WorldPosition.z;
	
	Out.vColorTexCoord.xy = float2( WorldX/vXStretch, WorldY/vYStretch );
	Out.vTexCoord0.xy = float2( WorldX, WorldY );
	//Out.vColorTexCoord.xy = float2( WorldX, WorldY );
	
	WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	Out.vTexCoord1.xy = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );

	Out.vTerrainIndexColor.x = ((WorldPosition.x - TerrainIndexOffsetX) + X_MAGIC ) / TerrainIndexSizeX;
	Out.vTerrainIndexColor.y = ((WorldPosition.z - TerrainIndexOffsetY) + Y_MAGIC ) / TerrainIndexSizeY;
	
	Out.vTerrainIndexColor = clamp(Out.vTerrainIndexColor,0.0,1.0);
	
	//// End new stuff


	float2 TerrainCoord = WorldPosition.xz;
	TerrainCoord += 0.5;
	TerrainCoord /= 8.0;
	Out.vTerrainTexCoord  = TerrainCoord;

	Out.vProvinceId = v.vProvinceId;
	
	return Out;
}

VS_MAP_OUTPUT VertexShader_Map_General_Low(const VS_INPUT v )
{
	VS_MAP_OUTPUT Out = (VS_MAP_OUTPUT)0;

	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	Out.vPosTex = Out.vPosition;


	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );

	///////New Stuff

	float WorldX = WorldPosition.x;
	float WorldY = WorldPosition.z;
	
	Out.vColorTexCoord.xy = float2( WorldX/512.0, WorldY/512.0 );
	Out.vTexCoord0.xy = float2( WorldX, WorldY );
	//Out.vColorTexCoord.xy = float2( WorldX, WorldY );
	
	WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	Out.vTexCoord1.xy = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );

	Out.vTerrainIndexColor.x = ((WorldPosition.x - TerrainIndexOffsetX) + X_MAGIC ) / TerrainIndexSizeX;
	Out.vTerrainIndexColor.y = ((WorldPosition.z - TerrainIndexOffsetY) + Y_MAGIC ) / TerrainIndexSizeY;
	
	Out.vTerrainIndexColor = clamp(Out.vTerrainIndexColor,0.0,1.0);
	
	//// End new stuff


	float2 TerrainCoord = WorldPosition.xz;
	TerrainCoord += 0.5;
	TerrainCoord /= 8.0;
	Out.vTerrainTexCoord  = TerrainCoord;

	Out.vProvinceId = v.vProvinceId;
	
	return Out;
}

VS_MAP_OUTPUT VertexShader_Map(const VS_INPUT v )
{
	VS_MAP_OUTPUT Out = (VS_MAP_OUTPUT)0;
	
	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	Out.vPosTex = Out.vPosition;

	Out.vProvinceId = v.vProvinceId;

	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );
	
	float WorldX = WorldPosition.x;
	float WorldY = WorldPosition.z;
	
	Out.vColorTexCoord.xy = float2( WorldX/16.0, WorldY/16.0 );
	Out.vTexCoord0.xy = float2( WorldX, WorldY );
	
	WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	Out.vTexCoord1.xy = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );

	Out.vTerrainIndexColor.x = ((WorldPosition.x - TerrainIndexOffsetX) + X_MAGIC ) / TerrainIndexSizeX;
	Out.vTerrainIndexColor.y = ((WorldPosition.z - TerrainIndexOffsetY) + Y_MAGIC ) / TerrainIndexSizeY;		
	
	Out.vTerrainIndexColor = clamp(Out.vTerrainIndexColor,0.0,1.0);
	return Out;
}

///////////////////////////////////////////////////////////////////////////////////////
// Map fragment shaders
///////////////////////////////////////////////////////////////////////////////////////

#define COLOR_VALUE 0.9
#define COLOR_LIGHTNESS 1.5

float4 White = float4( 1, 1, 1, 1 );

TILE_STRUCT ParallaxMapping( TILE_STRUCT v, float3 viewDir ){

	float cameraHeight = viewDir.y;
	viewDir = normalize(viewDir);
	const float numLayers = 10;
	float layerHeight = 1.0 / numLayers;
	float currentLayerHeight = 0.0;
	float2 P = float2(viewDir.x, (viewDir.z - 1.0)*0.5) * 0.1;
	float2 deltaTexCoords = P / numLayers;
	
	// get initial values
	float2 currentTexCoords = v.vColorTexCoord;
	float currentHeightMapValue = GenerateHeight(v);
	float deltaHeightMapValue = 0;
	float layer = 1;
	float refineRate = trunc(smoothstep(0, -300, cameraHeight) * 2 + 1);
	float refine = trunc(2.0/refineRate);
  
	while( refine )
	{
		while(currentLayerHeight < currentHeightMapValue)
		{
			// shift texture coordinates along direction of P
			currentTexCoords += deltaTexCoords;
			v.vColorTexCoord = currentTexCoords;
			// get depthmap value at current texture coordinates
			deltaHeightMapValue = GenerateHeight( v ) - currentHeightMapValue;
			currentHeightMapValue += deltaHeightMapValue;
			// get depth of next layer
			currentLayerHeight += layerHeight;
			layer+=1; 
		}
		currentTexCoords -= deltaTexCoords;
		currentLayerHeight -= layerHeight;
		currentHeightMapValue -= deltaHeightMapValue;
		deltaTexCoords /= layer;
		layerHeight /= layer;
		refine--;
		//layer = 1;
	}
	
	return v;
}

float SelfShadow( TILE_STRUCT v, float3 lightDir, float3 viewDir )
{
	float numLayers = 10;
	float layerHeight = 1.0 / 1000;
	float currentLayerHeight = GenerateHeight(v);
	float currentHeightMapValue = 0.0;
	float2 P = normalize(lightDir).xy * 0.1;
	float2 deltaTexCoords = P / numLayers;
	float2 currentTexCoords = v.vColorTexCoord;
	float penumbraFactor = 0.0;
	float layerRate = clamp(length(viewDir)/200, 1.0, 10.0);
	
	while( step(0, numLayers)*step(layerRate, 10)  ){
		// shift texture coordinates along direction of P
		currentTexCoords += deltaTexCoords/(step(5.5, numLayers)*30 + step(numLayers, 5.5));
		v.vColorTexCoord = currentTexCoords;
		// get depthmap value at current texture coordinates
		currentHeightMapValue = GenerateHeight( v );
		currentLayerHeight += layerHeight;
		penumbraFactor += step(currentLayerHeight, currentHeightMapValue)*(currentHeightMapValue - currentLayerHeight)/(11-numLayers) * 2;
		// get depth of next layer
		numLayers -= layerRate;
	}
	
	return clamp(penumbraFactor, 0.0, 0.65);
}

float3 Hue(float H)
{
    float R = abs(H * 6 - 3) - 1;
    float G = 2 - abs(H * 6 - 2);
    float B = 2 - abs(H * 6 - 4);
    return saturate(float3(R,G,B));
}

float3 HSVtoRGB(float3 HSV)
{
    return ((Hue(HSV.x) - 1) * HSV.y + 1) * HSV.z;
}

float3 RGBtoHSV(float3 RGB)
{
    float3 HSV = 0;
    
	HSV.z = max(RGB.r, max(RGB.g, RGB.b));
    float M = min(RGB.r, min(RGB.g, RGB.b));
    float C = HSV.z - M;

    if (C != 0)
    {
        HSV.y = C / HSV.z;
        float3 Delta = (HSV.z - RGB) / C;
        Delta.rgb -= Delta.brg;
        Delta.rg += float2(2,4);
        if (RGB.r >= HSV.z)
            HSV.x = Delta.b;
        else if (RGB.g >= HSV.z)
            HSV.x = Delta.r;
        else
            HSV.x = Delta.g;
        HSV.x = frac(HSV.x / 6);
    }
    return HSV;
}

float4 PixelShader_Map2_0_General( VS_MAP_OUTPUT v ) : COLOR
{
	
	//The map is a flat plane with normal in the y direction. This is always the truth. Thus the TBN Matrix is always as follows:
	float3x3 WorldMat3 = float3x3(WorldMatrix._11_12_13, WorldMatrix._21_22_23, WorldMatrix._31_32_33);
	float3 T = normalize(mul(WorldMat3, float3(1, 0, 0)));
	float3 B = normalize(mul(WorldMat3, float3(0, 0, 1)));
	float3 N = normalize(mul(WorldMat3, float3(0, 1, 0)));
	float3x3 TBN = transpose(float3x3(T, B, N));
	
	float3 TanLightPos = mul(TBN, float3(0.7, 0.7, 0.2));
	float3 TanViewPos = mul(TBN, CameraPosition);
	float3 TanFragPos = mul(TBN, v.vPosTex);
	
	float3 viewDir = TanViewPos - TanFragPos;
	float3 lightDir = TanLightPos - TanFragPos;
	
    TILE_STRUCT s;
    s.vTexCoord1 = v.vTexCoord1;
    s.vColorTexCoord = v.vColorTexCoord;
    s.vTerrainIndexColor = v.vTerrainIndexColor;
    s.vTexCoord0 = v.vTexCoord0.xy;
	
	s = ParallaxMapping( s, viewDir );
	float penumbraFactor = SelfShadow( s, lightDir, viewDir );
	

    float4 TerrainColor = GenerateTiles( s );

    float Grey = dot( TerrainColor.rgb, GREYIFY ); 
 	TerrainColor.rgb = Grey;
	TerrainColor *= White;
	
	float2 vProvinceUV = v.vProvinceId + 0.5f;
    vProvinceUV /= PROVINCE_LOOKUP_SIZE;
  
  	float4 Color1 = tex2D( GeneralTexture, vProvinceUV ) - 0.7;
	float4 Color2 = tex2D( GeneralTexture2, vProvinceUV ) - 0.7;

	float vColor = tex2D( StripesTexture, v.vTerrainTexCoord ).a;
	float4 Color = lerp(Color1, Color2, vColor);
	
	Color.rgb = lerp(TerrainColor.rgb, Color.rgb, 0.3);
	Color.rgb *= COLOR_LIGHTNESS;
	Color.rgb *= (1.0 - penumbraFactor/1.6);
	
	return Color;
}


float4 PixelShader_Map2_0_General_Low( VS_MAP_OUTPUT v ) : COLOR
{
	
	float4 OverlayColor = tex2D( OverlayTexture, v.vColorTexCoord );
	
	float2 vProvinceUV = v.vProvinceId + 0.5f;
    vProvinceUV /= PROVINCE_LOOKUP_SIZE;
  
  	float4 Color1 = tex2D( GeneralTexture, vProvinceUV ) - 0.7;
	float4 Color2 = tex2D( GeneralTexture2, vProvinceUV ) - 0.7;

	float vColor = tex2D( StripesTexture, v.vTerrainTexCoord ).a;
	float4 Color = Color2 * vColor + Color1 * ( 1.0 - vColor );
	float4 ColorColor = tex2D( ColorTexture, v.vTexCoord1 ); //Coordinates for colormap
	
	
	Color.rgb = lerp(Color.rgb, ColorColor.rgb, 0.3);
	//Color.rgb *= float3( 1.0, 0.95, 0.90 );
	//Color.rgb *= COLOR_LIGHTNESS;
	float3 ColorHSV = RGBtoHSV(Color.rgb);
	ColorHSV.y *= max(0.85, ColorHSV.z);
	ColorHSV.z *= 1.6;
	Color.rgb = HSVtoRGB(ColorHSV);
	Color.rgb = lerp(Color.rgb, OverlayColor.rgb, 0.5);
	Color.rgb *= 1.17;
	//Color.r *= 1.10;
	//Color.g *= 1.05;
	Color.rgb = lerp(Color.rgb, float3(0.83, 0.78, 0.44), 0.1);
	Color.rgb = lerp(Color.rgb, Color.rrr, 0.15);
	Color.g = lerp(Color.g, Color.r, 0.075);
	Color.b = lerp(Color.b, 1.0 - Color.r, 0.1);
	Color.r *= 1.03;
	

	return Color;
	
}


float4 PixelShader_Map2_0( VS_MAP_OUTPUT v ) : COLOR
{

	//The map is a flat plane with normal in the y direction. This is always the truth. Thus the TBN Matrix is always as follows:
	float3x3 WorldMat3 = float3x3(WorldMatrix._11_12_13, WorldMatrix._21_22_23, WorldMatrix._31_32_33);
	float3 T = normalize(mul(WorldMat3, float3(1, 0, 0)));
	float3 B = normalize(mul(WorldMat3, float3(0, 0, 1)));
	float3 N = normalize(mul(WorldMat3, float3(0, 1, 0)));
	float3x3 TBN = transpose(float3x3(T, B, N));
	
	float3 TanLightPos = mul(TBN, float3(0.7, 0.7, 0.2));
	float3 TanViewPos = mul(TBN, CameraPosition);
	float3 TanFragPos = mul(TBN, v.vPosTex);
	
	float3 viewDir = TanViewPos - TanFragPos;
	float3 lightDir = TanLightPos - TanFragPos;
	
    TILE_STRUCT s;
    s.vTexCoord1 = v.vTexCoord1;
    s.vColorTexCoord = v.vColorTexCoord;
    s.vTerrainIndexColor = v.vTerrainIndexColor;
    s.vTexCoord0 = v.vTexCoord0.xy;
	
	s = ParallaxMapping( s, viewDir );
	float penumbraFactor = SelfShadow( s, lightDir, viewDir );

    float4 OutColor = GenerateTiles( s );
	OutColor.rgb *= LIGHTNESS;
	
	float2 vProvinceUV = v.vProvinceId + 0.5f;
    vProvinceUV /= PROVINCE_LOOKUP_SIZE;
  
	float4 FogColor = tex2D( GeneralTexture, vProvinceUV );

	//Winter
	float Grey = dot( OutColor.rgb, GREYIFY );
	OutColor.rgb = lerp( OutColor.rgb, Grey.rrr, FogColor.b );
	OutColor.rgb += float3(FogColor.b,FogColor.b,FogColor.b)*0.3;
	
	// FOW /////////////////
	//OutColor.rgb *= lerp(0.4, 1.0, FogColor.r);
	OutColor.rgb = ApplyFOWColor( OutColor.rgb, FogColor.r);
	OutColor.rgb += FogColor.g;
	OutColor.rgb *= (1.0 - penumbraFactor/1.5);
	///////////////////
	
	return OutColor;
}

///////////////////////////////////////////////////////////////////////////////////////
// Beach shader
///////////////////////////////////////////////////////////////////////////////////////


VS_OUTPUT_BEACH VertexShader_Beach_General(const VS_INPUT_BEACH v )
{
	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	
	VS_OUTPUT_BEACH Out = (VS_OUTPUT_BEACH)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	//float3 VertexNormal = mul( v.vNormal, WorldMatrix );

	//float3 direction = normalize( LightDirection );
	//Out.vLightIntensity.xy = max( dot( VertexNormal, -direction ), 0.5f );
	Out.vLightIntensity.z = vPosition.y;

	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );
	Out.vColorTexCoord.xy = float2( WorldPosition.x/BorderWidth, WorldPosition.z/BorderHeight );

	float2 TerrainCoord = WorldPosition.xz;
	TerrainCoord += 0.5;
	TerrainCoord /= 8.0;
	Out.vTexCoordBase  = TerrainCoord;

	Out.vBorderTexCoord0 = float2( vPosition.x/BorderWidth, vPosition.z/BorderHeight );
	
	Out.vProvinceIndexCoord = v.vTerrainIndexColor;
	
	Out.vBorderTexCoord0.xy = float2( WorldPosition.x/8.0, WorldPosition.z/8.0 );
	Out.vTexCoordBase.xy = float2( WorldPosition.x, WorldPosition.z );
	
	float WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	float WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	
	Out.vColorTexCoord.xy = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );
	
	Out.vTerrainIndexColor.x = ((WorldPosition.x - TerrainIndexOffsetX) + X_MAGIC ) / TerrainIndexSizeX;
	Out.vTerrainIndexColor.y = ((WorldPosition.z - TerrainIndexOffsetY) + Y_MAGIC ) / TerrainIndexSizeY;
	
	
	Out.vTerrainIndexColor = clamp(Out.vTerrainIndexColor,0.0,1.0);
		
	Out.vBorderOffsetColor = v.vTerrainIndexColor;
	
	float2 StripeTerrainCoord = WorldPosition.xz;
	StripeTerrainCoord += 0.5;
	StripeTerrainCoord /= 8.0;
	Out.vTerrainIndexColor.zw  = StripeTerrainCoord;
	
	return Out;
}

float4 PixelShader_Beach_General( VS_OUTPUT_BEACH v ) : COLOR
{
	
	TILE_STRUCT s;
	s.vTexCoord1 = v.vColorTexCoord;
	s.vColorTexCoord = v.vBorderTexCoord0;
	s.vTerrainIndexColor = v.vTerrainIndexColor;
	s.vTexCoord0 = v.vTexCoordBase;

	float4 y1 = GenerateTiles( s );
	
	/////////////////
	
	float Grey = dot( y1.rgb, GREYIFY ); 
 	y1.rgb = Grey * White;

	float2 borderoffset = v.vBorderOffsetColor.rg + float2(-0.001/256,0);
	float4 Color1 = tex2D( GeneralTexture, borderoffset );
	float4 Color2 = tex2D( GeneralTexture2, borderoffset );

	float vColor = tex2D( StripesTexture, v.vTerrainIndexColor ).a;
	float4 Color = lerp( Color1, Color2, vColor ) - 0.7;

	Color.rgb = lerp(y1.rgb, Color.rgb, 0.3);
	Color.rgb *= COLOR_LIGHTNESS;
	Color.a = 1;

	return Color;
}


float4 PixelShader_Beach_General_Low( VS_OUTPUT_BEACH v ) : COLOR
{
	float4 Color = tex2D( GeneralTexture, v.vProvinceIndexCoord ) - 0.7;
	
	float4 OutColor;
	OutColor.rgb = Color.rgb;
	OutColor.a = 1;
	
	float4 ColorColor = tex2D( ColorTexture, v.vColorTexCoord ); //Coordinates for colormap
    	
	//float4 OutColor = float4( COLOR_VALUE,COLOR_VALUE,COLOR_VALUE,1);
	OutColor.rgb = lerp(ColorColor.rgb, float3(OutColor.r,OutColor.g,OutColor.b), 0.3);
	
	OutColor.rgb *= COLOR_LIGHTNESS;

	//float vAlpha = 1;
	//if ( v.vLightIntensity.z < 0.3f )
	//{
	//	vAlpha = 1.2;
	//	vAlpha += ( v.vLightIntensity.z - 0.3f)*0.7f;
	//	vAlpha = saturate( vAlpha );	
	//	vAlpha *= vAlpha;
	//}

	//OutColor.a = vAlpha;
	return OutColor;
}

///////////////////////////////////////////////////////////////////////////////////////
// Border shader
/////////////////////////////////////////////////////////////////////////////////
struct VS_BORDER_OUTPUT
{
    float4  vPosition : POSITION;
    float4  vUV_ProvUV : TEXCOORD0;
    float4 vBorderOffsetColor : TEXCOORD1; 
};

#define MAX_HALF_SIZE 1000.0f
#define HALF_PIXEL 0.5f
#define BORDER_PADDING_OFFSET 0.02f;

VS_BORDER_OUTPUT VertexShader_Map_Border(const VS_BORDER_INPUT v )
{
	VS_BORDER_OUTPUT Out;
	
	float2 vSign = sign( v.vPositionBorderLookup.xy );
	Out.vUV_ProvUV.xy = saturate( vSign );
	Out.vUV_ProvUV.x *= 1.0f - 2 * BORDER_PADDING_OFFSET;
	Out.vUV_ProvUV.x += BORDER_PADDING_OFFSET;
	Out.vUV_ProvUV.x *= 0.8 / 32;
	Out.vUV_ProvUV.y *= 0.25f - 2 * BORDER_PADDING_OFFSET;
	Out.vUV_ProvUV.y += BORDER_PADDING_OFFSET;
	
	vSign *= -MAX_HALF_SIZE;
	vSign += HALF_PIXEL + v.vPositionBorderLookup.xy;
	float4 vPosition = float4( vSign.x , LAND_ALT + 0.02, vSign.y, 1 ); // Increase z slightly to remove z-fighting
	
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);

	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	
	Out.vUV_ProvUV.zw = v.vPositionBorderLookup.zw;
	Out.vBorderOffsetColor = v.vBorderOffsetColor;
	
	return Out;
}

#define BORDERLOOKUP_SIZE 512.0f

float4 PixelShader_Map2_0_Border( VS_BORDER_OUTPUT v ) : COLOR
{
	// Do some magic to transform the position to usable uv-coordinates
	float2 TexCoord = v.vUV_ProvUV.xy;
	TexCoord.y /= 2;
	
	float2 BorderUV = v.vUV_ProvUV.zw + 0.5f;
	BorderUV /= BORDERLOOKUP_SIZE;
	
	float4 BorderTypeColor = tex2D( BorderDirectionTexture, BorderUV );
	
	float CornerOffset = 0;
	float SettingsBitMask = ( BorderTypeColor.b * 255 );
	if ( abs(SettingsBitMask - 1) < 0.01 )
	{
		CornerOffset = 1;
	}

	if ( abs(SettingsBitMask - 2) < 0.01  )
	{
	  TexCoord.y += 0.5;
	}

	if ( abs(SettingsBitMask - 3) < 0.01  )
	{
		CornerOffset = 1;
		TexCoord.y += 0.5;
	}
	
	float2 TexCoord2 = TexCoord;
	float2 TexCoord3 = TexCoord;
	
	TexCoord.x += (v.vBorderOffsetColor.b * CornerOffset) + (BorderTypeColor.a * (1.0 - CornerOffset));
	TexCoord.y += ( BorderTypeColor.a * CornerOffset );
	const float BIAS = -0.8;
	float4 ProvinceBorder = tex2Dbias( BorderTexture, float4(TexCoord, 0, BIAS) );
	//float4 ProvinceBorder = tex2D( BorderTexture, TexCoord );
	
	TexCoord2.x += BorderTypeColor.r;
	TexCoord2.y += 0.125; // 0.25
	float4 CountryBorder = tex2Dbias( BorderTexture, float4(TexCoord2, 0, BIAS) );
	//float4 CountryBorder = tex2D( BorderTexture, TexCoord2 );
		
	TexCoord3.x += v.vBorderOffsetColor.a * CornerOffset + BorderTypeColor.g;
	TexCoord3.y += 0.25; // 0.5
	TexCoord3.y += (BorderTypeColor.a * CornerOffset);
	
	float4 DiagBorder = tex2D( BorderTexture, TexCoord3 );

	ProvinceBorder.rgb *= ProvinceBorder.a;
	CountryBorder.rgb *= CountryBorder.a;
	DiagBorder.rgb *= DiagBorder.a;

	float4 OutColor = 0;
	
	OutColor.rgb = ProvinceBorder.rgb*ProvinceBorder.a;
	OutColor.a = max( ProvinceBorder.a, CountryBorder.a );
	OutColor.a = max( OutColor.a, DiagBorder.a );
	
	OutColor.rgb = CountryBorder.rgb * CountryBorder.a + OutColor.rgb*( 1.0f - CountryBorder.a );
	OutColor.rgb = max( OutColor.rgb, DiagBorder.rgb );

	return OutColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////


VS_OUTPUT_BEACH VertexShader_Beach(const VS_INPUT_BEACH v )
{
	float4 vPosition = float4( v.vPosition.x, LAND_ALT, v.vPosition.y, 1 );
	
	VS_OUTPUT_BEACH Out = (VS_OUTPUT_BEACH)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	//float3 VertexNormal = mul( v.vNormal, WorldMatrix );

	//float3 direction = normalize( LightDirection );
	//Out.vLightIntensity.xy = max( dot( VertexNormal, -direction ), 0.5f );
	Out.vLightIntensity.z = vPosition.y;

	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );
		
	Out.vBorderTexCoord0.xy = float2( WorldPosition.x/8.0, WorldPosition.z/8.0 );
	Out.vTexCoordBase.xy = float2( WorldPosition.x, WorldPosition.z );
	
	float WorldX = (ColorMapWidth * WorldPosition.x) / MapWidth;
	float WorldY = (ColorMapHeight * WorldPosition.z) / MapHeight;
	
	Out.vColorTexCoord.xy = float2( ( WorldX + X_OFFSET)/ColorMapTextureWidth, (WorldY + Z_OFFSET)/ColorMapTextureHeight );
	
	Out.vTerrainIndexColor.x = ((WorldPosition.x - TerrainIndexOffsetX) + X_MAGIC ) / TerrainIndexSizeX;
	Out.vTerrainIndexColor.y = ((WorldPosition.z - TerrainIndexOffsetY) + Y_MAGIC ) / TerrainIndexSizeY;
	
	Out.vTerrainIndexColor = clamp(Out.vTerrainIndexColor,0.0,1.0);
	Out.vBorderOffsetColor = v.vTerrainIndexColor;
	
	return Out;
}

float4 PixelShader_Beach( VS_OUTPUT_BEACH v ) : COLOR
{
	TILE_STRUCT s;
    s.vTexCoord1 = v.vColorTexCoord;
    s.vColorTexCoord = v.vBorderTexCoord0;
    s.vTerrainIndexColor = v.vTerrainIndexColor;
    s.vTexCoord0 = v.vTexCoordBase;

    float4 OutColor = GenerateTiles( s );
	
	OutColor.rgb *= LIGHTNESS;
    //return OutColor;
	// FOW /////////////////
	
	float3 FogColor = tex2D( GeneralTexture, v.vBorderOffsetColor.rg + float2(-0.001/256,0)).rgb;
	
	OutColor.rgb = ApplyFOWColor( OutColor.rgb, FogColor.r);
	OutColor.rgb += FogColor.g*1.1;
	
	//Winter
	float Grey = dot( OutColor.rgb, GREYIFY );
	OutColor.rgb = lerp( OutColor.rgb, Grey.rrr, FogColor.b );
	OutColor.rgb += float3(FogColor.b,FogColor.b,FogColor.b)*0.3;
	
	OutColor.rgb *= LIGHTNESS;
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
	return float4( 1, 1, 1, 1 );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

VS_OUTPUT_TREE VertexShader_TREE(const VS_INPUT_TREE v )
{
	float4 vPosition = float4( v.vPosition, 1.0 );
	vPosition.y += LAND_ALT;
	VS_OUTPUT_TREE Out = (VS_OUTPUT_TREE)0;
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float3 P = mul(vPosition, (float4x3)WorldView);
	
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);
	float4 WorldPosition = mul( vPosition, AbsoluteWorldMatrix );
	Out.vTexCoordTI = float2( WorldPosition.x/BorderWidth, WorldPosition.z/BorderHeight );

	Out.vTexCoord = v.vTexCoord;

	return Out;
}

float4 PixelShader_TREE( VS_OUTPUT_TREE v ) : COLOR
{
	float4 OutColor = tex2D( TreeTexture, v.vTexCoord );
//	float vFOW = ( tex2D( TerraIncognitaTextureTree, v.vTexCoordTI ).g - 0.25 )*1.33;
//	if ( vFOW < 0 )
	//	OutColor.rgb += vFOW;
	OutColor.a *= vAlpha;
	
	//float Grey = dot( OutColor.rgb, GREYIFY );
	//float winter = 1.2;
	
	//OutColor.rgb = lerp( OutColor.rgb, Grey.rrr, winter );
	//OutColor.rgb += float3(winter,winter,winter)*0.3;
	
	//OutColor.rgb = lerp(OutColor.rgb, float3(127.0/255.0,28.0/255.0,28.0/255.0), 0.6);
	return OutColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

technique TerrainShader_Graphical
{
	pass p0
	{
		VertexShader = compile vs_3_0 VertexShader_Map();
		PixelShader = compile ps_3_0 PixelShader_Map2_0();
	}
}

technique TerrainShader_General
{
	pass p0
	{
		VertexShader = compile vs_3_0 VertexShader_Map_General();
		PixelShader = compile ps_3_0 PixelShader_Map2_0_General();
	}
}

technique TerrainShader_General_Low
{
	pass p0
	{
		VertexShader = compile vs_3_0 VertexShader_Map_General_Low();
		PixelShader = compile ps_3_0 PixelShader_Map2_0_General_Low();
	}
}

technique TerrainShader_Border
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		
		VertexShader = compile vs_1_1 VertexShader_Map_Border();
		PixelShader = compile ps_2_0 PixelShader_Map2_0_Border();
	}
}


technique BeachShader_Graphical
{
	pass p0
	{
		ALPHATESTENABLE = True;
	
		ALPHABLENDENABLE = True;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
			
		VertexShader = compile vs_1_1 VertexShader_Beach();
		PixelShader = compile ps_2_0 PixelShader_Beach();
	}
}


technique BeachShader_General
{
	pass p0
	{		
		
		//ALPHATESTENABLE = True;
		//ALPHABLENDENABLE = True;
		//SrcBlend = SRCALPHA;
		//§DestBlend = INVSRCALPHA;
				
		VertexShader = compile vs_1_1 VertexShader_Beach_General();
		PixelShader = compile ps_2_0 PixelShader_Beach_General();
	}
}

technique BeachShader_General_Low
{
	pass p0
	{
		VertexShader = compile vs_1_1 VertexShader_Beach_General();
		PixelShader = compile ps_2_0 PixelShader_Beach_General_Low();
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
		PixelShader = compile ps_2_0 PixelShader_PTI();
	}
}

technique TreeShader
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = True;

		VertexShader = compile vs_1_1 VertexShader_TREE();
		PixelShader = compile ps_2_0 PixelShader_TREE();
	}
}
