texture tex0 < string name = "gfx/anims/railroad.dds"; >;

float4x4	ViewProjectionMatrix;
float4		ControlPoints[2];
float4		TotalVertices_Length_Pos;

sampler BaseTexture  =
sampler_state
{
    Texture = <tex0>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    MipMapLodBias = -1;
    AddressU = Wrap;
    AddressV = Wrap;
	AddressW = Wrap;
};

struct VS_INPUT
{
    float2 vPosition  : POSITION;
};

struct VS_OUTPUT
{
    float4  vPosition : POSITION;
    float2	vUV		  : TEXCOORD0;
};

VS_OUTPUT RailroadVS( const VS_INPUT v )
{
	VS_OUTPUT Out = (VS_OUTPUT)0;
   	
   	float t = v.vPosition.x / TotalVertices_Length_Pos.x;
   	
   	float2 p0 = ControlPoints[0].xy;
   	float2 p1 = ControlPoints[0].zw;
   	float2 p2 = ControlPoints[1].xy;
   	float2 p3 = ControlPoints[1].zw;
   	
   	// simple catmull-rom
   	float4 vPowers = float4( 1.0f, t, t*t, t*t*t ) * 0.5f;
   	
   	float4 vXTransform = float4( 
   		2*p1.x, 
   		p2.x - p0.x, 
   		2*p0.x - 5*p1.x + 4*p2.x - p3.x,
   		-p0.x + 3*p1.x - 3*p2.x + p3.x );
   		
   	float4 vYTransform = float4( 
   		2*p1.y, 
   		p2.y - p0.y, 
   		2*p0.y - 5*p1.y + 4*p2.y - p3.y,
   		-p0.y + 3*p1.y - 3*p2.y + p3.y );
   	
   	float4 vPos = float4( dot( vPowers, vXTransform ), 0.38f, dot( vPowers, vYTransform ), 1.0f );
   	
   	// find out the normal
   	float t2 = t + 0.005f;
	float4 vPowers2 = float4( 1.0f, t2, t2*t2, t2*t2*t2 ) * 0.5f;
	
	// perp
	float2 vPos2 = float2( vPos.z - dot( vPowers2, vYTransform ), dot( vPowers2, vXTransform ) - vPos.x );

   	vPos.xz += normalize( vPos2 ) * v.vPosition.y * 0.8f;
   	vPos.xz -= TotalVertices_Length_Pos.zw;
   	Out.vPosition = mul( vPos, ViewProjectionMatrix );
   	Out.vUV = float2( t * TotalVertices_Length_Pos.y, v.vPosition.y + 0.5f );
	return Out;
}

float4 RailroadPS( VS_OUTPUT v ) : COLOR
{
	return tex2D( BaseTexture, v.vUV );
	//return float4( 1.0f, 1.0f, 1.0f, 1.0f );
}

technique railroad
{
	

	pass p0
	{
		ALPHABLENDENABLE = True;
		VertexShader = compile vs_2_0 RailroadVS();
		PixelShader = compile ps_2_0 RailroadPS();
	}
}
