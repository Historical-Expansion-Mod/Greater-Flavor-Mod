
float4x4 WorldMatrix; 
float4x4 ViewProjectionMatrix;

float SizeOffset = 0.0;
float SizeFrame = 5;
float4 CountryColor = float4(0.8, 0, 0, 1);
float4 SelectionColor = float4(0, 1, 0, 0);
float Time;
float Selected;

texture BackgroundTex;
sampler2D BackgroundSampler = 
sampler_state 
{
    texture = <BackgroundTex>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

texture MaskTex;
sampler2D MaskSampler = 
sampler_state 
{
    texture = <MaskTex>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

texture SizeTex;
sampler2D SizeSampler = 
sampler_state 
{
    texture = <SizeTex>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

texture CounterTex;
sampler2D CounterSampler = 
sampler_state 
{
    texture = <CounterTex>;
    AddressU  = CLAMP;       
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    //MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
	MinFilter = Anisotropic;
    
    MaxAnisotropy = 4;
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

VS_OUTPUT Counter_VS( VS_INPUT In )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4x4 WorldViewProjectionMatrix = mul(WorldMatrix, ViewProjectionMatrix);
	Out.Position = mul( float4(In.Position.xyz, 1), WorldViewProjectionMatrix );
	Out.TexCoord = In.TexCoord;

	return Out;
}



float4 Counter_PS( VS_OUTPUT In ) : COLOR
{
	//float2 CounterTex = float2( (In.TexCoord.x - 0.18) / (0.67 - 0.18), 
	//                            (In.TexCoord.y - 0.25) / (0.72 - 0.25) );
	float4 CounterColor = tex2D( CounterSampler, In.TexCoord);//CounterTex );

	//if (In.TexCoord.x < 0.18)
	//	CounterColor.a = 0;
	//if (In.TexCoord.x > 0.67)
	//	CounterColor.a = 0;
	//if (In.TexCoord.y < 0.25)
	//	CounterColor.a = 0;	
	//if (In.TexCoord.y > 0.6)
	//	CounterColor.a = 0;
		
	
	float4 BgColor = tex2D( BackgroundSampler, In.TexCoord );
	float4 SizeColor = tex2D( SizeSampler, 
	                          float2( (In.TexCoord.x + SizeFrame) * SizeOffset, 
							         In.TexCoord.y ));
	float4 MaskColor = tex2D( MaskSampler, In.TexCoord );
	float vMask = MaskColor.r;
	float SelectionAlpha = MaskColor.b * Selected;
	float SelectionIntensity = lerp(0.5, 1, abs(sin(Time*2)));
	
	float4 FinalColor = float4(vMask * CountryColor.rgb, vMask);
	FinalColor = float4(FinalColor.rgb * BgColor.rgb, BgColor.a);
	//FinalColor = float4(FinalColor.rgb + BgColor.rgb * (BgColor.a), vMask + BgColor.a);
	FinalColor.rgb = lerp(FinalColor.rgb, CounterColor.rgb, CounterColor.a);
	return FinalColor; //vista gets sad if it needs to build a shader longer than this
	FinalColor.rgb = lerp(FinalColor.rgb, SizeColor.rgb, SizeColor.a);
	FinalColor.rgb = FinalColor.rgb * (1- SelectionAlpha) + 
	                 ( MaskColor.g * SelectionColor.rgb * SelectionAlpha * SelectionIntensity );
	FinalColor.a += SelectionAlpha * Selected;

	return FinalColor;
}

technique Standard
{
	pass p0
	{
		ZENABLE = False;
		ZWRITEENABLE = False;
		ALPHATESTENABLE = False;
		ALPHABLENDENABLE = True;
	
		VertexShader = compile vs_2_0 Counter_VS();
		PixelShader = compile ps_2_0 Counter_PS();
	}
}
