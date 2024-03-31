texture tex0 < string name = "sdf"; >;	// Base texture

//float4x4 WorldViewProjectionMatrix; 

float4x4 WorldMatrix; 
float4x4 ViewMatrix; 
float4x4 ProjectionMatrix; 
float4x4 RotationMatrix;

float4	 FlagCoords;
float	 AnimationState;

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


VS_OUTPUT OurVertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	//float4x4 WorldView = mul(RotationMatrix,WorldMatrix );
	float4x4 WorldView = mul(WorldMatrix, ViewMatrix);
	float4 InPosition = v.vPosition;
	
	// 3.14159265f*2.0f;
	float vThisY = 1.5f * v.vDiffuse.b * sin( -AnimationState + v.vDiffuse.b*3.14159265*2.0f*1.0f );
	
	float3 v0 = float3( 0, vThisY, 0 );
	
	//InPosition.y += 0.5f + vThisY*0.3f;
	InPosition.z += vThisY*0.3f;

	float3 P = mul(InPosition, (float4x3)WorldView);
	Out.vPosition  = mul(float4(P, 1), ProjectionMatrix);

	Out.vTexCoord0.x = v.vTexCoord.x/FlagCoords.x;
	Out.vTexCoord0.x = Out.vTexCoord0.x + FlagCoords.z;
	Out.vTexCoord0.y = v.vTexCoord.y/FlagCoords.y;
	Out.vTexCoord0.y = Out.vTexCoord0.y + FlagCoords.w;

	//Out.vDiffuse.r = sin( -AnimationState + (v.vDiffuse.b + 1.0f/200.0f)*3.14159265*2.0f*1.0f ) * 0.2 + 0.6;
	Out.vDiffuse.r = sin( -AnimationState + v.vDiffuse.b*3.14159265*2.0f*1.0f ) * 0.2 + 0.6;

	return Out;
}


float4 OurPixelShader( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	OutColor.rgb *= v.vDiffuse.rrr;
	
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

		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 OurPixelShader();
	}
}
