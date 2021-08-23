xof 0303txt 0032
//
// DirectX file: G:\3d_projects\eu3dummies\direct_x\legal_dummy.x
//
// Converted by the PolyTrans geometry converter from Okino Computer Graphics, Inc.
// Date/time of export: 03/22/2006 13:53:53
//
// Bounding box of geometry = (-1.26803,-0.218829,-1.36916) to (1.28264,0.218829,0.131738).


template Header {
 <3D82AB43-62DA-11cf-AB39-0020AF71E433>
 WORD major;
 WORD minor;
 DWORD flags;
}

template Vector {
  <3D82AB5E-62DA-11cf-AB39-0020AF71E433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template Coords2d {
  <F6F23F44-7686-11cf-8F52-0040333594A3>
 FLOAT u;
 FLOAT v;
}

template Matrix4x4 {
  <F6F23F45-7686-11cf-8F52-0040333594A3>
 array FLOAT matrix[16];
}

template ColorRGBA {
  <35FF44E0-6C7C-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <D3E16E81-7835-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template IndexedColor {
 <1630B820-7842-11cf-8F52-0040333594A3>
DWORD index;
 ColorRGBA indexColor;
}

template Boolean {
 <4885AE61-78E8-11cf-8F52-0040333594A3>
WORD truefalse;
}

template Boolean2d {
 <4885AE63-78E8-11cf-8F52-0040333594A3>
Boolean u;
 Boolean v;
}

template MaterialWrap {
 <4885AE60-78E8-11cf-8F52-0040333594A3>
Boolean u;
 Boolean v;
}

template TextureFilename {
 <A42790E1-7810-11cf-8F52-0040333594A3>
 STRING filename;
}

template Material {
 <3D82AB4D-62DA-11cf-AB39-0020AF71E433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template MeshFace {
 <3D82AB5F-62DA-11cf-AB39-0020AF71E433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template MeshFaceWraps {
 <4885AE62-78E8-11cf-8F52-0040333594A3>
 DWORD nFaceWrapValues;
 Boolean2d faceWrapValues;
}

template MeshTextureCoords {
 <F6F23F40-7686-11cf-8F52-0040333594A3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}

template MeshMaterialList {
 <F6F23F42-7686-11cf-8F52-0040333594A3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material]
}

template MeshNormals {
 <F6F23F43-7686-11cf-8F52-0040333594A3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template MeshVertexColors {
 <1630B821-7842-11cf-8F52-0040333594A3>
 DWORD nVertexColors;
 array IndexedColor vertexColors[nVertexColors];
}

template Mesh {
 <3D82AB44-62DA-11cf-AB39-0020AF71E433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template FrameTransformMatrix {
 <F6F23F41-7686-11cf-8F52-0040333594A3>
 Matrix4x4 frameMatrix;
}

template Frame {
 <3D82AB46-62DA-11cf-AB39-0020AF71E433>
 [...]
}

template FloatKeys {
 <10DD46A9-775B-11cf-8F52-0040333594A3>
 DWORD nValues;
 array FLOAT values[nValues];
}

template TimedFloatKeys {
 <F406B180-7B3B-11cf-8F52-0040333594A3>
 DWORD time;
 FloatKeys tfkeys;
}

template AnimationKey {
 <10DD46A8-775B-11cf-8F52-0040333594A3>
 DWORD keyType;
 DWORD nKeys;
 array TimedFloatKeys keys[nKeys];
}

template AnimationOptions {
 <E2BF56C0-840F-11cf-8F52-0040333594A3>
 DWORD openclosed;
 DWORD positionquality;
}

template Animation {
 <3D82AB4F-62DA-11cf-AB39-0020AF71E433>
 [...]
}

template AnimationSet {
 <3D82AB50-62DA-11cf-AB39-0020AF71E433>
 [Animation]
}

template XSkinMeshHeader {
 <3CF169CE-FF7C-44ab-93C0-F78F62D172E2>
 WORD nMaxSkinWeightsPerVertex; 
 WORD nMaxSkinWeightsPerFace; 
 WORD nBones; 
}

template VertexDuplicationIndices {
 <B8D65549-D7C9-4995-89CF-53A9A8B031E3>
 DWORD nIndices; 
 DWORD nOriginalVertices; 
 array DWORD indices[nIndices]; 
}

template SkinWeights {
 <6F0D123B-BAD2-4167-A0D0-80224F25FABB>
 STRING transformNodeName;
 DWORD nWeights; 
 array DWORD vertexIndices[nWeights]; 
 array float weights[nWeights]; 
 Matrix4x4 matrixOffset; 
}

Header {
	1; // Major version
	0; // Minor version
	1; // Flags
}

Material xof_default {
	0.400000;0.400000;0.400000;1.000000;;
	32.000000;
	0.700000;0.700000;0.700000;;
	0.000000;0.000000;0.000000;;
}

Material lambert1 {
	1.0;1.0;1.0;1.000000;;
	0.000000;
	0.000000;0.000000;0.000000;;
	0.000000;0.000000;0.000000;;
	TextureFilename {
		"dummy_texture.tga";
	}
}

// Top-most frame encompassing the 'World'
Frame Frame_World {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, -1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}

Frame Frame_polySurface1 {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 0.437657, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.010171, 0.0, 0.0, 1.000000;;
	}

// Original object name = "polySurface1"
Mesh polySurface1 {
	48;		// 48 vertices
	-0.008000;-0.500000;0.129809;,
	-0.008000;-0.500000;0.129809;,
	-0.008000;-0.500000;0.129809;,
	1.272467;-0.500000;-1.148834;,
	1.272467;-0.500000;-1.148834;,
	1.272467;-0.500000;-1.148834;,
	-0.008000;0.500000;0.129809;,
	-0.008000;0.500000;0.129809;,
	-0.008000;0.500000;0.129809;,
	1.272467;0.500000;-1.148834;,
	1.272467;0.500000;-1.148834;,
	1.272467;0.500000;-1.148834;,
	-0.223046;0.500000;-0.087446;,
	-0.223046;0.500000;-0.087446;,
	-0.223046;0.500000;-0.087446;,
	1.057421;0.500000;-1.366089;,
	1.057421;0.500000;-1.366089;,
	1.057421;0.500000;-1.366089;,
	-0.223046;-0.500000;-0.087446;,
	-0.223046;-0.500000;-0.087446;,
	-0.223046;-0.500000;-0.087446;,
	1.057421;-0.500000;-1.366089;,
	1.057421;-0.500000;-1.366089;,
	1.057421;-0.500000;-1.366089;,
	0.212255;-0.500000;-0.082200;,
	0.212255;-0.500000;-0.082200;,
	0.212255;-0.500000;-0.082200;,
	-1.059855;-0.500000;-1.369158;,
	-1.059855;-0.500000;-1.369158;,
	-1.059855;-0.500000;-1.369158;,
	0.212255;0.500000;-0.082200;,
	0.212255;0.500000;-0.082200;,
	0.212255;0.500000;-0.082200;,
	-1.059855;0.500000;-1.369158;,
	-1.059855;0.500000;-1.369158;,
	-1.059855;0.500000;-1.369158;,
	-0.006091;0.500000;0.131738;,
	-0.006091;0.500000;0.131738;,
	-0.006091;0.500000;0.131738;,
	-1.278201;0.500000;-1.155221;,
	-1.278201;0.500000;-1.155221;,
	-1.278201;0.500000;-1.155221;,
	-0.006091;-0.500000;0.131738;,
	-0.006091;-0.500000;0.131738;,
	-0.006091;-0.500000;0.131738;,
	-1.278201;-0.500000;-1.155221;,
	-1.278201;-0.500000;-1.155221;,
	-1.278201;-0.500000;-1.155221;;

	24;		// 24 faces
	3;11,5,2;,
	3;8,11,2;,
	3;17,10,7;,
	3;14,17,7;,
	3;23,16,13;,
	3;20,23,13;,
	3;4,22,19;,
	3;1,4,19;,
	3;15,21,3;,
	3;9,15,3;,
	3;6,0,18;,
	3;12,6,18;,
	3;35,29,26;,
	3;32,35,26;,
	3;41,34,31;,
	3;38,41,31;,
	3;47,40,37;,
	3;44,47,37;,
	3;28,46,43;,
	3;25,28,43;,
	3;39,45,27;,
	3;33,39,27;,
	3;30,24,42;,
	3;36,30,42;;

	MeshMaterialList {
		1;1;0;;
		{lambert1}
	}

	MeshNormals {
		10; // 10 normals
		-0.711197;0.000000;0.702992;,
		-0.710712;0.000000;0.703483;,
		-0.706603;0.000000;-0.707611;,
		-0.699857;0.000000;-0.714283;,
		0.000000;-1.000000;0.000000;,
		0.000000;1.000000;0.000000;,
		0.699857;0.000000;0.714283;,
		0.706603;0.000000;0.707611;,
		0.710712;0.000000;-0.703483;,
		0.711197;0.000000;-0.702992;;

		24;		// 24 faces
		3;7,7,7;,
		3;7,7,7;,
		3;5,5,5;,
		3;5,5,5;,
		3;2,2,2;,
		3;2,2,2;,
		3;4,4,4;,
		3;4,4,4;,
		3;8,8,8;,
		3;8,8,8;,
		3;1,1,1;,
		3;1,1,1;,
		3;9,9,9;,
		3;9,9,9;,
		3;5,5,5;,
		3;5,5,5;,
		3;0,0,0;,
		3;0,0,0;,
		3;4,4,4;,
		3;4,4,4;,
		3;3,3,3;,
		3;3,3,3;,
		3;6,6,6;,
		3;6,6,6;;
	}  // End of Normals

	MeshTextureCoords {
		48; // 48 texture coords
		0.497988;0.793460;,
		0.497988;0.793460;,
		0.497988;0.793460;,
		1.000000;0.292163;,
		1.000000;0.292163;,
		1.000000;0.292163;,
		0.497988;0.793460;,
		0.497988;0.793460;,
		0.497988;0.793460;,
		1.000000;0.292163;,
		1.000000;0.292163;,
		1.000000;0.292163;,
		0.413678;0.708284;,
		0.413678;0.708284;,
		0.413678;0.708284;,
		0.915691;0.206987;,
		0.915691;0.206987;,
		0.915691;0.206987;,
		0.413678;0.708284;,
		0.413678;0.708284;,
		0.413678;0.708284;,
		0.915691;0.206987;,
		0.915691;0.206987;,
		0.915691;0.206987;,
		0.584340;0.710341;,
		0.584340;0.710341;,
		0.584340;0.710341;,
		0.085604;0.205784;,
		0.085604;0.205784;,
		0.085604;0.205784;,
		0.584340;0.710341;,
		0.584340;0.710341;,
		0.584340;0.710341;,
		0.085604;0.205784;,
		0.085604;0.205784;,
		0.085604;0.205784;,
		0.498736;0.794216;,
		0.498736;0.794216;,
		0.498736;0.794216;,
		0.000000;0.289659;,
		0.000000;0.289659;,
		0.000000;0.289659;,
		0.498736;0.794216;,
		0.498736;0.794216;,
		0.498736;0.794216;,
		0.000000;0.289659;,
		0.000000;0.289659;,
		0.000000;0.289659;;
	}  // End of texture coords
} // End of Mesh
} // End of frame for 'polySurface1'
} // End of "World" frame

