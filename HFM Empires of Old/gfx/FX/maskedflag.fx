texture tex0 < string name = "sdf"; >;	// Base texture
texture tex1 < string name = "sdf"; >;	// Base texture

float4x4 WorldViewProjectionMatrix; 
float4	 FlagCoords;

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

sampler MaskTexture  =
sampler_state
{
    Texture = <tex1>;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = None;
    AddressU = Wrap;
    AddressV = Wrap;
};

struct VS_INPUT
{
    float4 vPosition  : POSITION;
    float2 vTexCoord  : TEXCOORD0;
    float2 vMaskCoord  : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2  vTexCoord0 : TEXCOORD0;
    float2  vTexCoord1 : TEXCOORD1;
};


VS_OUTPUT OurVertexShader(const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	Out.vPosition  = mul(v.vPosition, WorldViewProjectionMatrix );

	Out.vTexCoord1 = v.vMaskCoord;

	Out.vTexCoord0.x = v.vTexCoord.x/FlagCoords.x;
	Out.vTexCoord0.x = Out.vTexCoord0.x + FlagCoords.z;
	Out.vTexCoord0.y = v.vTexCoord.y/FlagCoords.y;
	Out.vTexCoord0.y = Out.vTexCoord0.y + FlagCoords.w;

	

	return Out;
}

float4 OurPixelShader( VS_OUTPUT v ) : COLOR
{
	float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
	float4 MaskColor = tex2D( MaskTexture, v.vTexCoord1.xy );
	OutColor.a = MaskColor.a;
	
	return OutColor;
}

float4 PixelShaderOver( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
    float4 MaskColor = tex2D( MaskTexture, v.vTexCoord1.xy );
    float4 MixColor = float4( 0.1, 0.1, 0.1, 0 );
    OutColor.a = MaskColor.a;
    OutColor += MixColor;
    
    return OutColor;
}

float4 PixelShaderDown( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
    float4 MaskColor = tex2D( MaskTexture, v.vTexCoord1.xy );
    float4 MixColor = float4( 0.1, 0.1, 0.1, 0 );
    OutColor.a = MaskColor.a;
    OutColor -= MixColor;
    
    return OutColor;
}

float4 PixelShaderDisable( VS_OUTPUT v ) : COLOR
{
    float4 OutColor = tex2D( BaseTexture, v.vTexCoord0.xy );
    float4 MaskColor = tex2D( MaskTexture, v.vTexCoord1.xy );
    float Grey = dot( OutColor.rgb, float3( 0.212671f, 0.715160f, 0.072169f ) ); 
    
    OutColor.rgb = Grey;
    OutColor.a = MaskColor.a;
    
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

technique down
{
	pass p0
	{
		fvf = XYZ | Tex1;

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

		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 PixelShaderDown();
	}
}

technique over
{
	pass p0
	{
		fvf = XYZ | Tex1;

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

		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 PixelShaderOver();
	}
}

technique disable
{
	pass p0
	{
		fvf = XYZ | Tex1;

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

		VertexShader = compile vs_1_1 OurVertexShader();
		PixelShader = compile ps_2_0 PixelShaderDisable();
	}
}