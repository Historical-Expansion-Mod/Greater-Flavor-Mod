texture tex0 : Diffuse < string ResourceName = "Diffuse.tga"; >;
texture tex1 : Diffuse < string ResourceName = "Diffuse.tga"; >;

float vXOffset;
float vFlip;
float vTime;

float4x4 WorldMatrix; 
float4x4 ViewProjectionMatrix;

sampler2D TopTexture = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = WRAP;        
    AddressV  = WRAP;
    AddressW  = WRAP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

sampler2D BottomTexture = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = WRAP;        
    AddressV  = WRAP;
    AddressW  = WRAP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

struct VS_INPUT 
{
   float3 Position : POSITION;
   float2 TexCoord : TEXCOORD0;
};

struct VS_OUTPUT 
{
   float4 Position :        POSITION;
   float2 TexCoord :        TEXCOORD0;
};

VS_OUTPUT WeatherBillboard_VS( VS_INPUT In )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4x4 WorldViewProjectionMatrix = mul(WorldMatrix, ViewProjectionMatrix);
	
	Out.Position = mul( float4(In.Position, 1), WorldViewProjectionMatrix );
	Out.TexCoord = In.TexCoord;
	return Out;
}



float4 Rain_PS( VS_OUTPUT In ) : COLOR
{
	float vATime = -vTime * 0.00005f;
	float4 DiffuseColor = tex2D( TopTexture, In.TexCoord + float2(vXOffset, 0.0) );
	float4 AnimatedAlpha = tex2D( TopTexture, In.TexCoord + float2(vXOffset-(vATime/2.0), vATime) );

	DiffuseColor.rgb = AnimatedAlpha.rgb;
	return DiffuseColor;
}

float4 Snow_PS( VS_OUTPUT In ) : COLOR
{
	float vATime = -vTime * 0.00001f;

	float4 AnimatedAlpha = tex2D( TopTexture, In.TexCoord + float2(vXOffset+(sin(vATime *3.0 * 3.14)/100.0), vATime) );
	return AnimatedAlpha;
	
//	return DiffuseColor;
}

technique RainTech
{
	pass p0
	{
		ZENABLE = False;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		
	
		VertexShader = compile vs_2_0 WeatherBillboard_VS();
		PixelShader = compile ps_2_0 Rain_PS();
	}
}

technique SnowTech
{
	pass p0
	{
		ZENABLE = False;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
	
		VertexShader = compile vs_2_0 WeatherBillboard_VS();
		PixelShader = compile ps_2_0 Snow_PS();
	}
}
