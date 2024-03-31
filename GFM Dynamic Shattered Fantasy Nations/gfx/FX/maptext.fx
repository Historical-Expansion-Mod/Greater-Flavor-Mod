texture tex0 < string name = "sdf"; >;	// Base texture

float4x4 WorldViewProjectionMatrix; 
//float4x4 WorldMatrix; 
//float4x4 ViewMatrix; 
//float4x4 ProjectionMatrix; 

float3	LightPosition;
float CurrentState;
float MaxV;

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

struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float3 vNormal    : NORMAL;
    float2 vTexCoord  : TEXCOORD0;
    float4 vDiffuse   : COLOR;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
    float4  vDiffuse   : COLOR;
};


VS_OUTPUT VertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );
	//float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	//float3 P = mul(v.vPosition, (float4x3)WorldView);
	//Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0  = v.vTexCoord;
	//float ActualState = MaxV - CurrentState;
	float ActualV = min( v.vTexCoord.y + CurrentState, 1 );
	Out.vTexCoord0.y = ActualV;
	
	Out.vDiffuse = v.vDiffuse;

	return Out;
}


float4 PixelShader( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	OutColor.a *= v.vDiffuse.a;
	
	return OutColor;
}


technique tec0
{
	pass p0
	{
		fvf = XYZ | Normal | Diffuse | Tex1;

		LightEnable[0] = false;
		Lighting = False;

		ALPHABLENDENABLE = True;

		Texture[0] = <tex0>;

		ColorOp[0] = Modulate;
		ColorArg1[0] = Texture;
		ColorArg2[0] = current;
  
		ColorOp[1] = Disable;
		AlphaOp[1] = Disable;

		VertexShader = compile vs_1_1 VertexShader();
		PixelShader = compile ps_1_1 PixelShader();
	}
}
