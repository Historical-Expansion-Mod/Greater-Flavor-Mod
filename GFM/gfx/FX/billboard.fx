texture tex0 : Diffuse < string ResourceName = "Diffuse.tga"; >;

float vXOffset;
float vFlip;
float4x4 WorldMatrix; 
float4x4 ViewProjectionMatrix;
float vMultiplier;
float vScale;

sampler2D DiffuseTexture = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
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
	Out.Position = mul( float4(In.Position.xyz * vScale, 1), WorldViewProjectionMatrix );
	Out.TexCoord = In.TexCoord;

	return Out;
}

float4 Billboard_PS( VS_OUTPUT In ) : COLOR
{
	float4 DiffuseColor = tex2D( DiffuseTexture, In.TexCoord + float2(vXOffset, 0.0) );
	return DiffuseColor * vMultiplier;
}

technique standard
{
	pass p0
	{
		ZENABLE = False;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
	
		VertexShader = compile vs_2_0 Billboard_VS();
		PixelShader = compile ps_2_0 Billboard_PS();
	}
}
