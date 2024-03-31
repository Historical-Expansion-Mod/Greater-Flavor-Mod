float4x4 WorldViewMatrix;
float4x4 ProjectionMatrix;
float4x4 ViewToLightProjectionMatrix;  // Transform from view space to light projection space
texture  ShadowTexture;
//int	   nShadowMapSize;

sampler2D SamplerShadow =
sampler_state
{
    Texture = <ShadowTexture>;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    AddressU = Clamp;
    AddressV = Clamp;
};


void VertShadow( float4 Pos : POSITION,
                 float3 Normal : NORMAL,
                 out float4 oPos : POSITION )
{
    //
    // Compute the projected coordinates
    //
    oPos = mul( Pos, WorldViewMatrix );
    oPos = mul( oPos, ProjectionMatrix );
}


float4 PixShadow( float2 Depth : TEXCOORD0 ) : COLOR
{
	return float4( 0, 0, 0, 0 );
}



// Generates the shadow map
technique RenderShadow
{
    pass p0
    {
        VertexShader = compile vs_2_0 VertShadow();
        PixelShader = compile ps_2_0 PixShadow();
    }
}

//------------------------------------------------------------------
//------------------------------------------------------------------
//------------------------------------------------------------------


void VertShadowToScene( float4 Pos : POSITION,
                 float3 Normal : NORMAL,
                 out float4 oPos : POSITION,
		 out float4 vPos : TEXCOORD0,
		 out float4 vPosLight : TEXCOORD1 )
{
    //
    // Compute the projected coordinates
    //
    vPos = mul( Pos, WorldViewMatrix );
    oPos = mul( vPos, ProjectionMatrix );
    vPosLight = mul( vPos, ViewToLightProjectionMatrix );
}


float4 PixShadowToScene( float4 vPos : TEXCOORD0,
		         float4 vPosLight : TEXCOORD1 ) : COLOR
{
    float2 ShadowTexC = 0.5 * vPosLight.xy / vPosLight.w + float2( 0.5, 0.5 );
    ShadowTexC.y = 1.0f - ShadowTexC.y;

    // Is it in shadow?
    float4 Shadow = ((tex2D( SamplerShadow, ShadowTexC ).x > 0 )? 0.0f: 0.6f ).xxxx;

    return Shadow;
}


// Projects the shadow into the scene
technique RenderShadowToScene
{
    pass p0
    {
        VertexShader = compile vs_2_0 VertShadowToScene();
        PixelShader = compile ps_2_0 PixShadowToScene();
    }
}
