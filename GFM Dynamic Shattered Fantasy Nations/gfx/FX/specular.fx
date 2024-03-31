texture tex0 : Diffuse < string ResourceName = "Diffuse.tga"; >;
texture tex1 : Diffuse < string ResourceName = "Colors.tga"; >;

float4x4 WorldViewProjectionMatrix	: WorldViewProjection;
float4x4 WorldMatrix			: World;
float4x4 WorldViewMatrix		: WorldView;

float4 LightDirection;
float4 LightAmbient;
float4 LightColor;
float3 CameraPosition;

float4 Color1;
float4 Color2;
float4 Color3;

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

sampler2D ColorTexture = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = CLAMP;        
    AddressV  = CLAMP;
    AddressW  = CLAMP;
    MIPFILTER = LINEAR;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};


struct VS_INPUT 
{
   float4 Position : POSITION;
   float2 TexCoord : TEXCOORD0;
   float3 Normal   : NORMAL;
};

struct VS_OUTPUT 
{
   float4 Position :        POSITION;
   float2 TexCoord :        TEXCOORD0;
   float3 LightDirection :  TEXCOORD1;
   float3 ViewDirection :   TEXCOORD2;
   float3 Normal :          TEXCOORD3;
   float3 Diffuse  :	    COLOR;
};



VS_OUTPUT Object_VertexShader( VS_INPUT In )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
	Out.Position = mul( float4(In.Position.xyz, 1.0f), WorldViewProjectionMatrix );
	Out.Normal = mul( In.Normal, WorldMatrix );
	Out.LightDirection = LightDirection;
	Out.TexCoord = In.TexCoord;

	float3 P = mul(In.Position, WorldViewMatrix);
	Out.ViewDirection = normalize( P - CameraPosition );
	return Out;
}



float4 Object_PixelShader( VS_OUTPUT In ) : COLOR
{
	float3 LightDirection = -In.LightDirection;
	float3 Normal = normalize(In.Normal.xyz);
	float3 ViewDirection = normalize(In.ViewDirection.xyz);
	float3 diff = dot( Normal, LightDirection ).xxx;

	diff *= LightColor.rgb;
	float4 Diffuse = tex2D( DiffuseTexture, In.TexCoord );
	float3 ColorOut = Diffuse * LightAmbient + Diffuse * diff;

	float3 H = normalize( ViewDirection + LightDirection );
	float spec = saturate( dot( Normal, H ) );

	float specValue = pow( spec, 64 );
	specValue *= Diffuse.a;
	return float4( ColorOut + specValue.xxx, 1.0f);
}

float4 Object_PixelShader_Color( VS_OUTPUT In ) : COLOR
{
	float3 LightDirection = -In.LightDirection;
	float3 Normal = normalize(In.Normal.xyz);
	float3 ViewDirection = normalize(In.ViewDirection.xyz);
	float3 diff = dot( Normal, LightDirection ).xxx;

	diff *= LightColor.rgb;

	float4 Diffuse = tex2D( DiffuseTexture, In.TexCoord );
	float4 Colors = tex2D( ColorTexture, In.TexCoord );
	Diffuse.rgb += Colors.r * Color1.rgb;
	Diffuse.rgb += Colors.g * Color2.rgb;
	Diffuse.rgb += Colors.b * Color3.rgb;

	float3 ColorOut = Diffuse * LightAmbient + Diffuse * diff;

	float3 H = normalize( ViewDirection + LightDirection );
	float spec = saturate( dot( Normal, H ) );

	float specValue = pow( spec, 64 );
	specValue *= Diffuse.a;
	return float4( ColorOut + specValue.xxx, 1.0f);
}


technique spec
{
	pass p0
	{
		VertexShader = compile vs_1_1 Object_VertexShader();
		PixelShader = compile ps_2_0 Object_PixelShader();
	}
}

technique spec_color
{
	pass p0
	{
		VertexShader = compile vs_1_1 Object_VertexShader();
		PixelShader = compile ps_2_0 Object_PixelShader_Color();
	}
}
