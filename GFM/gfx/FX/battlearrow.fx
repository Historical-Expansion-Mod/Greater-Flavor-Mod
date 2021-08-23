float4x4	WorldViewProjectionMatrix; 
float2		CameraPosition;
float4		ArrowColorAlpha;
float 		ArrowTransparency;
bool 		NoFade;

texture tex0 : BodyTexture;
sampler2D BodyMap = 
sampler_state 
{
    texture = <tex0>;
    AddressU  = Wrap;        
    AddressV  = Clamp;
    AddressW  = Clamp;
    MipFilter = Point;
    MagFilter = Point;
	MinFilter = Point;
};

texture tex1 : HeadTexture;
sampler2D HeadMap = 
sampler_state 
{
    texture = <tex1>;
    AddressU  = Clamp;        
    AddressV  = Clamp;
    AddressW  = Clamp;
    MipFilter = Linear;
    MagFilter = Linear;
	MinFilter = Linear;
};

struct VS_INPUT_BATTLEARROW
{
    float2 vPosition	: POSITION;
	float3 vUV_IsHead	: TEXCOORD0;
};

struct VS_OUTPUT_BATTLEARROW
{
    float4 vPosition	: POSITION;
	float3 vUV_IsHead	: TEXCOORD0;
};


VS_OUTPUT_BATTLEARROW VertexBattleArrow( const VS_INPUT_BATTLEARROW v )
{
  	VS_OUTPUT_BATTLEARROW Out;
	float4 vPosition = float4( v.vPosition.x - CameraPosition.x, 0.5f, v.vPosition.y - CameraPosition.y, 1.0f );
   	Out.vPosition = mul( vPosition, WorldViewProjectionMatrix );
	Out.vUV_IsHead = v.vUV_IsHead;
	return Out;
}


void CalcCommon( VS_OUTPUT_BATTLEARROW In, out float vAlpha, out float4 vColor )
{
	// To tile: float2( In.vUV_IsHead.x * In.vUV_IsHead.x * 15.0f, In.vUV_IsHead.y )
	vColor = lerp( tex2D( BodyMap, In.vUV_IsHead.xy ), tex2D( HeadMap, In.vUV_IsHead.xy ), In.vUV_IsHead.z );
	clip( vColor.a <= 0.0f ? -1.0f : 1.0f );
	if( NoFade )
		vAlpha = vColor.a;
	else
	{
		vAlpha = saturate( lerp( vColor.a, vColor.a * 1.3f, In.vUV_IsHead.z ) );
		vAlpha *= In.vUV_IsHead.z + ( 1.0f - In.vUV_IsHead.z ) * max( saturate( ( In.vUV_IsHead.x - 0.05f ) * 5.0f ), 0.1f );
	}
}


float4 PixelBattleArrow( VS_OUTPUT_BATTLEARROW In ) : COLOR
{
	float4 vColor;
	float vAlpha;
	CalcCommon( In, vAlpha, vColor );

	clip( vColor.g <= 0.0f ? -1.0f : 1.0f );

	return float4( ArrowColorAlpha.rgb * ( vColor.r + vColor.g ), vAlpha * ArrowColorAlpha.a * ArrowTransparency );
}

float4 PixelBattleArrowOutline( VS_OUTPUT_BATTLEARROW In ) : COLOR
{
	float4 vColor;
	float vAlpha;
	CalcCommon( In, vAlpha, vColor );

	clip( vColor.r <= 0.0f ? -1.0f : 1.0f );

	return float4( ArrowColorAlpha.rgb * ( vColor.r + vColor.g ), vAlpha * ArrowTransparency );
}


technique BattleArrow
{
	pass p0
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		CULLMODE = None;

		STENCILREF = 0;
		STENCILMASK = 255;
		STENCILWRITEMASK = 255;
		
		STENCILENABLE = True;
		STENCILFUNC = Equal;
		
		STENCILFAIL = Keep;
		STENCILZFAIL = Keep;
		STENCILPASS = Incr;
				
		VertexShader = compile vs_2_0 VertexBattleArrow();
		PixelShader = compile ps_2_0 PixelBattleArrow();
	}

	pass p1
	{
		ZENABLE = True;
		ZWRITEENABLE = False;
		ALPHABLENDENABLE = True;
		ALPHATESTENABLE = False;
		CULLMODE = None;

		STENCILREF = 0;
		STENCILMASK = 255;
		STENCILWRITEMASK = 255;
		
		STENCILENABLE = True;
		STENCILFUNC = Equal;
		
		STENCILFAIL = Keep;
		STENCILZFAIL = Keep;
		STENCILPASS = Incr;
				
		VertexShader = compile vs_2_0 VertexBattleArrow();
		PixelShader = compile ps_2_0 PixelBattleArrowOutline();
	}
}
