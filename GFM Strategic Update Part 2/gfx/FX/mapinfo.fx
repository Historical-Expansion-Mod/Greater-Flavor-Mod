float4x4	WorldViewProjectionMatrix; 
float2		CameraPosition;
float4		ArrowColorAlpha;
float			IconTransparency;
float			IconRotation;
float2		IconPosition;

texture tex0 : BodyTexture;
sampler2D BodyMap = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = Clamp;        
    AddressV  = Clamp;
    AddressW  = Clamp;
    MipFilter = Linear;
    MagFilter = Linear;
	MinFilter = Linear;
};

struct VS_INPUT_MAPINFO
{
    float2 vPosition	: POSITION;
	float2 vUV			: TEXCOORD0;
};

struct VS_OUTPUT_MAPINFO
{
    float4 vPosition	: POSITION;
	float2 vUV			: TEXCOORD0;
};


 
VS_OUTPUT_MAPINFO VertexMapInfo( const VS_INPUT_MAPINFO v )
{
	VS_OUTPUT_MAPINFO Out;
	float vX, vY;
	if( IconRotation != 0 )
	{
		float vLocalX = v.vPosition.x - IconPosition.x;
		float vLocalY = v.vPosition.y - IconPosition.y;
		vX = ( vLocalX * cos( IconRotation ) ) - ( vLocalY * sin( IconRotation ) );
		vY = ( vLocalY * cos( IconRotation ) ) + ( vLocalX * sin( IconRotation ) );
		vX += IconPosition.x;
		vY += IconPosition.y;
	}
	else
	{
		vX = v.vPosition.x;
		vY = v.vPosition.y;
	}
	float4 vPosition = float4( vX - CameraPosition.x, 0.5f, vY - CameraPosition.y, 1.0f );
	Out.vPosition = mul( vPosition, WorldViewProjectionMatrix );
	Out.vUV = v.vUV;
	return Out;
}

float4 PixelMapInfo( VS_OUTPUT_MAPINFO In ) : COLOR
{
	float4 col = tex2D( BodyMap, In.vUV ) * ArrowColorAlpha;
  col.a = col.a * IconTransparency;
	return col;
}


technique MapInfo
{
	pass p0
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		CULLMODE = None;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
				
		VertexShader = compile vs_2_0 VertexMapInfo();
		PixelShader = compile ps_2_0 PixelMapInfo();
	}
}




struct VS_INPUT_MAPINFOTEXT
{
    float3 vPosition	: POSITION;
	float2 vUV			: TEXCOORD0;
};

VS_OUTPUT_MAPINFO VertexMapInfoText( const VS_INPUT_MAPINFOTEXT v )
{
	VS_OUTPUT_MAPINFO Out;
	float vX, vY;
	if( IconRotation != 0 )
	{
		float vLocalX = v.vPosition.x - IconPosition.x;
		float vLocalY = v.vPosition.z - IconPosition.y;
		vX = ( vLocalX * cos( IconRotation ) ) - ( vLocalY * sin( IconRotation ) );
		vY = ( vLocalY * cos( IconRotation ) ) + ( vLocalX * sin( IconRotation ) );
		vX += IconPosition.x;
		vY += IconPosition.y;
	}
	else
	{
		vX = v.vPosition.x;
		vY = v.vPosition.z;
	}
	float4 vPosition = float4( vX - CameraPosition.x, 0.5f, vY - CameraPosition.y, 1.0f );
	Out.vPosition = mul( vPosition, WorldViewProjectionMatrix );
	Out.vUV = v.vUV;
	return Out;
}

float4 PixelMapInfoText( VS_OUTPUT_MAPINFO In ) : COLOR
{
  float4 col = tex2D( BodyMap, In.vUV ) * ArrowColorAlpha;
  col.a = col.a * IconTransparency;
	return col;
}

technique MapInfoText
{
	pass p0
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		CULLMODE = None;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
				
		VertexShader = compile vs_2_0 VertexMapInfoText();
		PixelShader = compile ps_2_0 PixelMapInfoText();
	}
}
