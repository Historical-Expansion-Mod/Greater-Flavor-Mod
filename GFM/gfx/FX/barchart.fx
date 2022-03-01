float4x4 InverseView;

float4 vColorBarheight[20];
float4 vScreenPosWidthHeight;

struct VS_INPUT
{
    float2 vPosition : POSITION;
    int2 nOffset : TEXCOORD0; 
};

struct VS_OUTPUT
{
    float4 vPosition : POSITION;
    float3 vColor	 : TEXCOORD0;
};


void VSBar( const VS_INPUT v, out VS_OUTPUT Out )
{	
	float4 vColorHeight = vColorBarheight[v.nOffset[0]];
	float2 pos = vScreenPosWidthHeight.xy // screenpos of widget
		+ float2( 0.0f, vScreenPosWidthHeight.w ) // add height
		+ v.vPosition * vScreenPosWidthHeight.zw * float2(1.0f, -vColorHeight.w); // vertexbuffer is in [0,0 -> 1,1], scale with width/height
	Out.vPosition = mul( float4( pos, 0, 1 ), InverseView );
	Out.vColor = vColorHeight.xyz;
}


float4 PSBar( VS_OUTPUT v2p ) : COLOR
{
	return float4( v2p.vColor, 1.0f );
}

technique BarShader
{
	pass p0
	{
		VertexShader = compile vs_1_1 VSBar();
		PixelShader  = compile ps_2_0 PSBar();
	}
}
