texture tex0 < string name = "Forest.tga"; >;

float4x4 WorldViewProjectionMatrix; 

sampler MapTexture  =
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
    float4  vDiffuse  : COLOR;
    float2  vTexCoord : TEXCOORD0;
};


VS_OUTPUT VertexShader_Map(const VS_INPUT v )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
    Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );
    Out.vDiffuse   = v.vDiffuse;
    Out.vTexCoord  = v.vTexCoord;
    return Out;
}

float4 PixelShader_Map( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( MapTexture, v.vTexCoord );
    OutColor += v.vDiffuse * 0.2f;
//    OutColor.a = 1;
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

//		VertexShaderConstant[4] = (WorldViewProjectionMatrix); // World*View*Proj Matrix

		VertexShader = compile vs_1_1 VertexShader_Map();
		PixelShader = compile ps_1_1 PixelShader_Map();
	}
}
