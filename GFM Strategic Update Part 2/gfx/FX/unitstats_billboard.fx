texture tex0 : DiffuseTex;
texture tex1 : MaskTex;

float4x4 WorldMatrix; 
float4x4 ViewProjectionMatrix;
float4 StatusColor;

sampler2D DiffuseTexture = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

sampler2D MaskTexture = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
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

VS_OUTPUT Billboard_VS( VS_INPUT In )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	float4x4 WorldViewProjectionMatrix = mul(WorldMatrix, ViewProjectionMatrix);
	Out.Position = mul( float4(In.Position.xyz, 1), WorldViewProjectionMatrix );
	Out.TexCoord = In.TexCoord;

	return Out;
}



float4 Billboard_PS( VS_OUTPUT In ) : COLOR
{
	//return float4(1, 0, 0, 1);
	//float3 StatColor = float3(0,1,0);
	float4 DiffuseColor = tex2D( DiffuseTexture, In.TexCoord );
	float4 MaskColor = tex2D( MaskTexture, In.TexCoord );
	DiffuseColor.rgb += StatusColor * MaskColor.g;
	DiffuseColor.a = MaskColor.r;
	return DiffuseColor;
}

technique standard
{
	pass p0
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
	
		VertexShader = compile vs_2_0 Billboard_VS();
		PixelShader = compile ps_2_0 Billboard_PS();
	}
}
