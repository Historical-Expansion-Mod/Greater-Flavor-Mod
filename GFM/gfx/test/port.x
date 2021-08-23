xof 0303txt 0032
//
// DirectX file: G:\3d_projects\eu3dummies\direct_x\two_frame_dummy.x
//
// Converted by the PolyTrans geometry converter from Okino Computer Graphics, Inc.
// Date/time of export: 03/22/2006 11:37:15
//
// Bounding box of geometry = (-2.46002,-1,-2.42527) to (2.40985,1,2.47354).


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

Frame Frame_joint1 {
	FrameTransformMatrix {
		-0.999988, 0.0, 0.004831, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		-0.004831, 0.0, -0.999988, 0.0, 
		0.007723, 0.0, -0.004898, 1.000000;;
	}

// Note: The following matrix will be replaced by DirectX by the equivalent
//       concatenation of each keyframe's scale/rotate/translate values.
Frame Anim_MatrixFrame_joint2 {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}
} // End animation 'joint2' frame

// Note: The following matrix will be replaced by DirectX by the equivalent
//       concatenation of each keyframe's scale/rotate/translate values.
Frame Anim_MatrixFrame_joint3 {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}
} // End animation 'joint3' frame

// Note: The following matrix will be replaced by DirectX by the equivalent
//       concatenation of each keyframe's scale/rotate/translate values.
Frame Anim_MatrixFrame_joint4 {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}
} // End animation 'joint4' frame

// Note: The following matrix will be replaced by DirectX by the equivalent
//       concatenation of each keyframe's scale/rotate/translate values.
Frame Anim_MatrixFrame_joint5 {
	FrameTransformMatrix {
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}
} // End animation 'joint5' frame
} // End empty node 'joint1' frame

Frame Frame_pCube1 {
	FrameTransformMatrix {
		2.995061, 0.0, 0.0, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.0, 0.0, 2.995061, 0.0, 
		0.005638, 0.080434, -0.008702, 1.000000;;
	}

// Original object name = "pCube1"
Mesh pCube1 {
	42;		// 42 vertices
	-0.500000;-0.500000;0.500000;,
	-0.500000;-0.500000;0.500000;,
	-0.500000;-0.500000;0.500000;,
	0.500000;-0.500000;0.500000;,
	0.500000;-0.500000;0.500000;,
	0.500000;-0.500000;0.500000;,
	-0.500000;0.500000;0.500000;,
	-0.500000;0.500000;0.500000;,
	-0.500000;0.500000;0.500000;,
	0.500000;0.500000;0.500000;,
	0.500000;0.500000;0.500000;,
	0.500000;0.500000;0.500000;,
	-0.500000;0.500000;-0.500000;,
	-0.500000;0.500000;-0.500000;,
	-0.500000;0.500000;-0.500000;,
	0.500000;0.500000;-0.500000;,
	0.500000;0.500000;-0.500000;,
	0.500000;0.500000;-0.500000;,
	-0.500000;-0.500000;-0.500000;,
	-0.500000;-0.500000;-0.500000;,
	-0.500000;-0.500000;-0.500000;,
	0.500000;-0.500000;-0.500000;,
	0.500000;-0.500000;-0.500000;,
	0.500000;-0.500000;-0.500000;,
	-0.500000;0.500000;-0.001456;,
	-0.500000;0.500000;-0.001456;,
	0.500000;0.500000;-0.001456;,
	0.500000;0.500000;-0.001456;,
	-0.500000;-0.500000;-0.001456;,
	-0.500000;-0.500000;-0.001456;,
	0.500000;-0.500000;-0.001456;,
	0.500000;-0.500000;-0.001456;,
	0.003289;-0.500000;0.500000;,
	0.003289;-0.500000;0.500000;,
	0.003289;0.500000;0.500000;,
	0.003289;0.500000;0.500000;,
	0.003289;0.500000;-0.500000;,
	0.003289;0.500000;-0.500000;,
	0.003289;-0.500000;-0.500000;,
	0.003289;-0.500000;-0.500000;,
	0.003289;0.500000;-0.001456;,
	0.003289;-0.500000;-0.001456;;

	32;		// 32 faces
	3;35,33,2;,
	3;8,35,2;,
	3;40,34,7;,
	3;25,40,7;,
	3;39,37,14;,
	3;20,39,14;,
	3;41,38,19;,
	3;29,41,19;,
	3;27,31,5;,
	3;11,27,5;,
	3;24,28,18;,
	3;13,24,18;,
	3;36,40,25;,
	3;12,36,25;,
	3;32,41,29;,
	3;1,32,29;,
	3;23,31,27;,
	3;17,23,27;,
	3;0,28,24;,
	3;6,0,24;,
	3;4,33,35;,
	3;10,4,35;,
	3;9,34,40;,
	3;26,9,40;,
	3;16,37,39;,
	3;22,16,39;,
	3;21,38,41;,
	3;30,21,41;,
	3;26,40,36;,
	3;15,26,36;,
	3;30,41,32;,
	3;3,30,32;;

	MeshMaterialList {
		1;1;0;;
		{lambert1}
	}

	MeshNormals {
		42; // 42 normals
		-1.000000;0.000000;0.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		1.000000;0.000000;0.000000;,
		-1.000000;0.000000;0.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		1.000000;0.000000;0.000000;,
		0.000000;1.000000;0.000000;,
		-1.000000;0.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		1.000000;0.000000;0.000000;,
		-1.000000;0.000000;0.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		1.000000;0.000000;0.000000;,
		-1.000000;0.000000;0.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;1.000000;0.000000;,
		1.000000;0.000000;0.000000;,
		-1.000000;0.000000;0.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;-1.000000;0.000000;,
		1.000000;0.000000;0.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;0.000000;1.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		0.000000;-1.000000;0.000000;,
		0.000000;0.000000;-1.000000;,
		0.000000;1.000000;0.000000;,
		0.000000;-1.000000;0.000000;;

		32;		// 32 faces
		3;35,33,2;,
		3;8,35,2;,
		3;40,34,7;,
		3;25,40,7;,
		3;39,37,14;,
		3;20,39,14;,
		3;41,38,19;,
		3;29,41,19;,
		3;27,31,5;,
		3;11,27,5;,
		3;24,28,18;,
		3;13,24,18;,
		3;36,40,25;,
		3;12,36,25;,
		3;32,41,29;,
		3;1,32,29;,
		3;23,31,27;,
		3;17,23,27;,
		3;0,28,24;,
		3;6,0,24;,
		3;4,33,35;,
		3;10,4,35;,
		3;9,34,40;,
		3;26,9,40;,
		3;16,37,39;,
		3;22,16,39;,
		3;21,38,41;,
		3;30,21,41;,
		3;26,40,36;,
		3;15,26,36;,
		3;30,41,32;,
		3;3,30,32;;
	}  // End of Normals

	MeshTextureCoords {
		42; // 42 texture coords
		0.000000;1.000000;,
		0.000000;-3.000000;,
		0.000000;1.000000;,
		1.000000;-3.000000;,
		1.000000;1.000000;,
		1.000000;1.000000;,
		0.000000;0.000000;,
		0.000000;0.000000;,
		0.000000;0.000000;,
		1.000000;0.000000;,
		1.000000;0.000000;,
		1.000000;0.000000;,
		0.000000;-1.000000;,
		-1.000000;0.000000;,
		0.000000;-1.000000;,
		1.000000;-1.000000;,
		1.000000;-1.000000;,
		2.000000;0.000000;,
		-1.000000;1.000000;,
		0.000000;-2.000000;,
		0.000000;-2.000000;,
		1.000000;-2.000000;,
		1.000000;-2.000000;,
		2.000000;1.000000;,
		-0.501456;0.000000;,
		0.000000;-0.501456;,
		1.000000;-0.501456;,
		1.501456;0.000000;,
		-0.501456;1.000000;,
		0.000000;-2.498544;,
		1.000000;-2.498544;,
		1.501456;1.000000;,
		0.503289;-3.000000;,
		0.503289;1.000000;,
		0.503289;0.000000;,
		0.503289;0.000000;,
		0.503289;-1.000000;,
		0.503289;-1.000000;,
		0.503289;-2.000000;,
		0.503289;-2.000000;,
		0.503289;-0.501456;,
		0.503289;-2.498544;;
	}  // End of texture coords

	XSkinMeshHeader {
		4; // nMaxSkinWeightsPerVertex
		6; // nMaxSkinWeightsPerFace
		6; // nBones
	}  // End of XSkinMeshHeader

//	NOTE: This is an 'extra' bone that has been added to the mesh by this exporter. The original mesh
//	had some vertices whose weights did not add up to 1.0. This extra bone is locked to the coordinate
//	system of this mesh, and has extra vertices and weights which ensure that all weights on every
//	vertex sums up to 1.0.


	SkinWeights {
		"Frame_pCube1";
		10; // nWeights
		24,25,28,29,30,31,32,33,34,35;;
		0.000054,0.000054,0.000003,0.000003,0.000047,0.000047,
		0.000006,0.000006,0.000003,0.000003;;
		1.000000, 0.0, 0.0, 0.0, 
		0.0, 1.000000, 0.0, 0.0, 
		0.0, 0.0, 1.000000, 0.0, 
		0.0, 0.0, 0.0, 1.000000;;
	}  // End of SkinWeights

	SkinWeights {
		"Frame_joint1";
		30; // nWeights
		0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,
		23,26,27,36,37,40,41;;
		1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,
		1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,
		1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,
		1.000000,1.000000,1.000000,1.000000,1.000000,1.000000,
		0.000258,0.000258,0.000374,0.000374,1.000000,1.000000;;
		-2.995026, 0.0, -0.014469, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.014469, 0.0, -2.995026, 0.0, 
		0.002067, 0.080434, 0.003814, 1.000000;;
	}  // End of SkinWeights

	SkinWeights {
		"Anim_MatrixFrame_joint2";
		4; // nWeights
		24,25,28,29;;
		0.999946,0.999946,0.999997,0.999997;;
		2.995061, 0.0, 0.0, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.0, 0.0, 2.995061, 0.0, 
		1.465663, 0.080434, -0.010895, 1.000000;;
	}  // End of SkinWeights

	SkinWeights {
		"Anim_MatrixFrame_joint4";
		4; // nWeights
		26,27,30,31;;
		0.999742,0.999742,0.999953,0.999953;;
		-2.995026, 0.0, -0.014469, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.014469, 0.0, -2.995026, 0.0, 
		1.399349, 0.080434, 0.011683, 1.000000;;
	}  // End of SkinWeights

	SkinWeights {
		"Anim_MatrixFrame_joint5";
		4; // nWeights
		32,33,34,35;;
		0.999994,0.999994,0.999997,0.999997;;
		-2.995026, 0.0, -0.014469, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.014469, 0.0, -2.995026, 0.0, 
		-0.003486, 0.080434, 1.477426, 1.000000;;
	}  // End of SkinWeights

	SkinWeights {
		"Anim_MatrixFrame_joint3";
		4; // nWeights
		36,37,38,39;;
		0.999626,0.999626,1.000000,1.000000;;
		-2.995026, 0.0, -0.014469, 0.0, 
		0.0, 0.537706, 0.0, 0.0, 
		0.014469, 0.0, -2.995026, 0.0, 
		0.003493, 0.080434, -1.411750, 1.000000;;
	}  // End of SkinWeights
} // End of Mesh
} // End of frame for 'pCube1'
} // End of "World" frame

AnimationSet AnimationSet0 {
	// Original object 'joint2'
	Animation Animation0 {
		{Anim_MatrixFrame_joint2}
		AnimationKey {
			0;  // Rotation
			2;           
			150;4;-0.002415,0.000000,0.999997,0.000000;;	// Axis = (0, 1, 0), angle = 179.723 degrees.,
			300;4;-0.002415,0.000000,0.999997,0.000000;;	// Axis = (0, 1, 0), angle = 179.723 degrees.;
		}
		AnimationKey {
			1;  // Scale
			2;           
			150;3;1.000000,1.000000,1.000000;;,
			300;3;1.000000,1.000000,1.000000;;;
		}
		AnimationKey {
			2;  // Position
			2;           
			150;3;1.467765,0.000000,0.000000;;,
			300;3;2.174131,0.000000,0.003412;;;
		}
		// Param1 = Repeat(0)/NoRepeat(1), param2 = Spline(0)/Linear(1) 
		AnimationOptions { 0; 0; }
	}
	// Original object 'joint3'
	Animation Animation1 {
		{Anim_MatrixFrame_joint3}
		AnimationKey {
			0;  // Rotation
			2;           
			150;4;-1.0,0.0,0.0,0.0;;,
			300;4;-1.0,0.0,0.0,0.0;;;
		}
		AnimationKey {
			1;  // Scale
			2;           
			150;3;1.000000,1.000000,1.000000;;,
			300;3;1.000000,1.000000,1.000000;;;
		}
		AnimationKey {
			2;  // Position
			2;           
			150;3;-0.001426,0.000000,1.415564;;,
			300;3;-0.001426,0.000000,2.170758;;;
		}
		// Param1 = Repeat(0)/NoRepeat(1), param2 = Spline(0)/Linear(1) 
		AnimationOptions { 0; 0; }
	}
	// Original object 'joint4'
	Animation Animation2 {
		{Anim_MatrixFrame_joint4}
		AnimationKey {
			0;  // Rotation
			2;           
			150;4;-1.0,0.0,0.0,0.0;;,
			300;4;-1.0,0.0,0.0,0.0;;;
		}
		AnimationKey {
			1;  // Scale
			2;           
			150;3;1.000000,1.000000,1.000000;;,
			300;3;1.000000,1.000000,1.000000;;;
		}
		AnimationKey {
			2;  // Position
			2;           
			150;3;-1.397282,0.000000,-0.007869;;,
			300;3;-2.125341,0.000000,-0.007869;;;
		}
		// Param1 = Repeat(0)/NoRepeat(1), param2 = Spline(0)/Linear(1) 
		AnimationOptions { 0; 0; }
	}
	// Original object 'joint5'
	Animation Animation3 {
		{Anim_MatrixFrame_joint5}
		AnimationKey {
			0;  // Rotation
			2;           
			150;4;-1.0,0.0,0.0,0.0;;,
			300;4;-1.0,0.0,0.0,0.0;;;
		}
		AnimationKey {
			1;  // Scale
			2;           
			150;3;1.000000,1.000000,1.000000;;,
			300;3;1.000000,1.000000,1.000000;;;
		}
		AnimationKey {
			2;  // Position
			2;           
			150;3;0.005553,0.000000,-1.473612;;,
			300;3;0.005553,0.000000,-2.137765;;;
		}
		// Param1 = Repeat(0)/NoRepeat(1), param2 = Spline(0)/Linear(1) 
		AnimationOptions { 0; 0; }
	}
}
