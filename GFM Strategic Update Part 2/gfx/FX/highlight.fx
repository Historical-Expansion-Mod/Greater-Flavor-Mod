#define BRIGHTNESS	0.1 // 0 //0.05
#define CONTRAST 		2.0 // 1 //1.5
#define DESATURATION	0.4 // 0 //0


#define OVERSTATE_BRIGHTNESS		0.2 // 0.1
#define OVERSTATE_CONTRAST		2.3 // 2.0
#define OVERSTATE_DESATURATION	0.7 // 0.4


//#define FogStart	800  //800
//#define FogEnd		10000 //10000


//float FogStart	= 800;
//float FogEnd	= 10000;


// transforms
float4x4 WorldMatrix; 
float4x4 WorldViewMatrix; 
float4x4 ProjectionMatrix;

float3 LightDirection; // light direction (view space)
float4 LightColor;
float4 LightAmbient;

float3 CameraPosition;

// texture
texture tex0 < string name = "t.bmp"; >;


sampler Texture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear; //Point;
    MagFilter = Linear; //Point;
    MipFilter = Linear; //None;
    AddressU = Wrap;
    AddressV = Wrap;
};


struct VSTEXTURE_OUTPUT
{
    float4 Position : POSITION;
//    float  Fog	    : FOG;
    float4 Diffuse  : COLOR;
    float2 TexCoord : TEXCOORD0;
};

struct VSGLOW_OUTPUT
{
    float4 Position : POSITION;
    float4 Diffuse  : COLOR;
};

// draws unskinned object with one texture and one directional light.
VSTEXTURE_OUTPUT VSTexture( float4 Position : POSITION, 
			    float3 Normal   : NORMAL,
			    float2 TexCoord : TEXCOORD0 )
{
    VSTEXTURE_OUTPUT Out = (VSTEXTURE_OUTPUT)0;
  
    float3 L = -LightDirection;						// light direction (view space)
    float3 P = mul(Position, WorldViewMatrix);				// position (view space)
    float3 N = normalize(mul(Normal, (float3x3)WorldMatrix));		// normal (view space)

    Out.Position = mul(float4(P, 1), ProjectionMatrix);			// projected position
    float4 Diffuse = max(0, dot(N, L));
    Diffuse *= LightColor;
    Diffuse += LightAmbient;
    Out.Diffuse  = Diffuse;
    Out.TexCoord = TexCoord;						// texture coordinates

//    float Distance = length( CameraPosition - P.xyz );
//    Out.Fog = ( FogEnd - Distance ) / ( FogEnd - FogStart );
    
    return Out;    
}

float4 PSTexture( VSTEXTURE_OUTPUT In ) : COLOR
{
    float4 OutColor = tex2D( Texture, In.TexCoord );
    OutColor.rgb *= In.Diffuse;

    OutColor.rgb += BRIGHTNESS;
    OutColor.rgb -= 0.5f;
    OutColor.rgb *= CONTRAST;
    OutColor.rgb += 0.5f;
    float Grey = dot( OutColor.rgb, float3( 0.212671f, 0.715160f, 0.072169f ) );
    OutColor.rgb = lerp( OutColor.rgb, Grey.rrr, DESATURATION );


    return OutColor;
}


float4 PSGlow( VSTEXTURE_OUTPUT In ) : COLOR
{
    float4 OutColor = tex2D( Texture, In.TexCoord );
    OutColor.rgb *= In.Diffuse;

    OutColor.rgb += OVERSTATE_BRIGHTNESS;
    OutColor.rgb -= 0.5f;
    OutColor.rgb *= OVERSTATE_CONTRAST;
    OutColor.rgb += 0.5f;
    float Grey = dot( OutColor.rgb, float3( 0.212671f, 0.715160f, 0.072169f ) );
    OutColor.rgb = lerp( OutColor.rgb, Grey.rrr, OVERSTATE_DESATURATION );


    return OutColor;
}


technique TGlowAndTexture
{
    pass PTexture
    {   
        // single texture/one directional light shader
        VertexShader = compile vs_2_0 VSTexture();
        PixelShader  = compile ps_2_0 PSGlow();

//        FOGENABLE = TRUE;
//        FOGCOLOR = 0x00DDEEFF;
    }
}

technique NoGlow
{
    pass P0
    {
//        FOGENABLE = TRUE;
//        FOGCOLOR = 0x00DDEEFF;

        // single texture/one directional light shader
        VertexShader = compile vs_2_0 VSTexture();
        PixelShader  = compile ps_2_0 PSTexture();
    }
}

technique NoLighting
{
    pass P0
    {
	LIGHTING = FALSE;
	FOGENABLE = FALSE;
    }
}
