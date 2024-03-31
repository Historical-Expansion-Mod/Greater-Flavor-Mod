texture tex0 < string ResourceName = "C:\\diplomacy\\Executable\\gfx\\map\\default\\water.tga"; >;
texture tex1 < string ResourceName = "C:\\diplomacy\\Executable\\gfx\\map\\default\\water_normal.tga"; >;
string XFile = "C:\\diplomacy\\Executable\\gfx\\map\\default\\water.x";   // Model to load

// Here is a vector parameter representing the direction
// vector from a light source.  The UIDirectional annotation
// tells EffectEdit to create a user interface element that can
// be used to interactively change the light direction.
float4 LightDirection = {1.0, 1.0, 1.0, 1.0};
float4 lightDir2 = {1.0, 1.0, 1.0, 1.0};

int VectorToRgb(float4 Pos : POSITION) 
{
    DWORD r = (DWORD)( 127.0f * Pos.x + 128.0f );
    DWORD g = (DWORD)( 127.0f * Pos.y + 128.0f );
    DWORD b = (DWORD)( 127.0f * Pos.z + 128.0f );
    DWORD a = (DWORD)( 255.0f * 1.0f );
    
    DWORD ReturnValue = 0xff000000 + (r*65536L) + (g*256L) + (b) ;
    return ReturnValue;
}

technique tec0
{
    pass p0
    {
        // Set up reasonable material defaults
// Set up reasonable material defaults
        MaterialAmbient = {0, 0, 0, 0}; 
        MaterialDiffuse = {0.8, 0.8, 0.8, 1.0}; 
        MaterialSpecular = {0.5, 0.5, 0.5, 1.0}; 
        MaterialPower = 10.0f;
        
        // Set up one directional light
        LightType[0]      = DIRECTIONAL;
        LightDiffuse[0]   = {0.5, 0.5, 0.5, 1.0};
        LightSpecular[0]  = {1.0, 1.0, 1.0, 1.0}; 
        LightAmbient[0]   = {0.5, 0.5, 0.5, 1.0};
        LightDirection[0] = <LightDirection>; // Use the vector parameter defined above
        LightRange[0]     = 100000.0;
        
        // Turn lighting on and use light 0
        LightEnable[0] = True;
        Lighting = True;
        SpecularEnable = True;
        
        // enable alpha blending
        AlphaBlendEnable = TRUE;
        SrcBlend         = ONE;
        DestBlend        = ONE;

        LightType[1]      = DIRECTIONAL;
        LightDiffuse[1]   = {1.0, 1.0, 1.0, 1.0};
        LightSpecular[1]  = {1.0, 1.0, 1.0, 1.0}; 
        LightAmbient[1]   = {1.0, 1.0, 1.0, 1.0};
        LightDirection[1] = <lightDir2>; // Use the vector parameter defined above
        LightRange[1]     = 100000.0;
        
        // Turn lighting on and use light 1
        LightEnable[0] = True;
        Lighting = True;
        SpecularEnable = True;
		FOGENABLE = FALSE;

        // Set up texture stage 0
        Texture[0] = <tex1>; // Use the texture parameter defined above
        Texture[1] = <tex0>; // Use the texture parameter defined above

        TEXTUREFACTOR = VectorToRgb( LightDirection );
        TexCoordIndex[0] = 0;
        ColorOp[0] = Dotproduct3;
        ColorArg1[0] = Texture;
        ColorArg2[0] = TFactor;

        AlphaOp[0] = Selectarg1;
        AlphaArg1[0] = Texture;
        AlphaArg2[0] = Diffuse;

        TexCoordIndex[1] = 0;
        ColorOp[1] = Modulate;
        ColorArg1[1] = Texture;
        ColorArg2[1] = current;
  
        AlphaOp[1] = SelectArg1;
        AlphaArg1[1] = Texture;
        AlphaArg2[1] = Diffuse;

        // Disable texture stage 1
        ColorOp[2] = Disable;
        AlphaOp[2] = Disable;
    }
}
