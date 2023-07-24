texture tex0 < string name = "C:\\Active Projects\\eu3\\game\\gfx\\test\\testred.dds"; >;	// Base texture

float4x4 WorldViewProjectionMatrix; 
float CurrentProgress;
float2 CameraPosition;

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
	MinFilter = Anisotropic;
    MaxAnisotropy = 4;
    //MinFilter = Linear;//Point;
    MagFilter = Linear;//Point;
    MipFilter = None;//Linear;//Point;
    AddressU = Clamp;
    AddressV = Clamp;
	AddressW = Clamp;
};

struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float2 vProgress  : TEXCOORD0;
	float2 vTexCoord  : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord : TEXCOORD1;
	float  vProgress : TEXCOORD0;
};


VS_OUTPUT VertexShader_Arrow(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4 vPosition = v.vPosition;
	vPosition.x -= CameraPosition.x;
	vPosition.z -= CameraPosition.y;
	
   	Out.vPosition  = mul( vPosition, WorldViewProjectionMatrix );
	

	Out.vProgress  = CurrentProgress - v.vProgress.x;
	Out.vTexCoord = v.vTexCoord;

	return Out;
}

float4 PixelShader_Arrow( VS_OUTPUT v ) : COLOR
{
	// v.vTexCoord.x - is arrow?
	// v.vTexCoord.y - is position in y dir
	// v.vProgress - progress along arrow

	float2 Tex = float2(0, 0);
	Tex.x = v.vTexCoord.x;
	Tex.y = v.vTexCoord.y;// + (step(0.5, v.vProgress) * 0.5);
	float2 Tex2 = Tex;
	Tex2.y += 0.5;


	float4 OutColor = tex2D( BaseTexture, Tex );
	float4 OutColor2 = tex2D( BaseTexture, Tex2 );
	
	OutColor = lerp ( OutColor, OutColor2, saturate( v.vProgress * 50.0f ) );
//	float4 MrColor = float4(0,0,0,1);
//	if (Tex.x > 0.5)
//		MrColor.r = 1.0;
//	else
//		MrColor.b = 1.0;
		
	//OutColor = OutColor * OutColor.a + MrColor * float4(1.0-OutColor.a,1.0-OutColor.a,1.0-OutColor.a,1.0-OutColor.a);
	//OutColor.a = 1;
	return OutColor;
	//return float4(v.vProgress,0,0,1);//OutColor;
}


technique tec0
{
	pass p0
	{
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = True;
		ZWRITEENABLE = False;
		//alphatest = true;
		//ColorOp[0] = Modulate;
		//ColorArg1[0] = Texture;
		//ColorArg2[0] = Current;
		
		//AlphaOp[0] = SelectArg1;
		//AlphaArg1[0] = Texture;
		//AlphaArg2[0] = Current;
		
		VertexShader = compile vs_2_0 VertexShader_Arrow();
		PixelShader = compile ps_2_0 PixelShader_Arrow();
	}
}
