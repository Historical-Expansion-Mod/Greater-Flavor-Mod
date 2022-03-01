float4x4 InverseView;

float4 vColorHeight[40];
float4 vScreenPosWidthHeight;
float2 vHalfLineWidthScale;

struct VS_INPUT
{
    int4 nOffset     : POSITION; 
};

struct VS_OUTPUT
{
    float4 vPosition : POSITION;
    float3 vColor	 : TEXCOORD0;
};


void VSLine( const VS_INPUT v, out VS_OUTPUT Out )
{	
	float  vHeight = vColorHeight[v.nOffset.x].w;
	float  vOtherHeight = vColorHeight[ v.nOffset.x + v.nOffset.y ].w;
	
	float2 vLineVec = float2( vHalfLineWidthScale.y * v.nOffset.y, vScreenPosWidthHeight.w * ( vHeight - vOtherHeight ) );
	vLineVec = normalize( vLineVec );
	vLineVec = float2( -vLineVec.y, vLineVec.x );
	
	float2 vCenterPoint = vScreenPosWidthHeight.xy; // screenpos of widget
	vCenterPoint.x += v.nOffset.x * vHalfLineWidthScale.y;
	vCenterPoint.y += vScreenPosWidthHeight.w * (1.0f - vHeight);
	
	vLineVec.xy  *= vHalfLineWidthScale.x * v.nOffset.z;
	vCenterPoint += vLineVec;
	
	Out.vPosition = mul( float4( vCenterPoint, 0, 1 ), InverseView );
	Out.vColor = vColorHeight[v.nOffset[0]].xyz;
}


float4 PSLine( VS_OUTPUT v2p ) : COLOR
{
	return float4( v2p.vColor, 1.0f );
}

technique BarShader
{
	pass p0
	{
		VertexShader = compile vs_1_1 VSLine();
		PixelShader  = compile ps_2_0 PSLine();
	}
}
