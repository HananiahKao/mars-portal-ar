const fs = require('fs');

// Create a simple USDA file for Mars terrain
function createMarsTerrainUSDA() {
  const usda = `#usda 1.0
(
    defaultPrim = "MarsGround"
    upAxis = "Y"
)

def Xform "MarsGround" (
    kind = "component"
)
{
    def Mesh "Terrain" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        int[] faceVertexCounts = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
        int[] faceVertexIndices = [
            0, 1, 5, 4,
            1, 2, 6, 5,
            2, 3, 7, 6,
            4, 5, 9, 8,
            5, 6, 10, 9,
            6, 7, 11, 10,
            8, 9, 13, 12,
            9, 10, 14, 13,
            10, 11, 15, 14,
            12, 13, 17, 16,
            13, 14, 18, 17,
            14, 15, 19, 18,
            16, 17, 21, 20,
            17, 18, 22, 21,
            18, 19, 23, 22,
            20, 21, 22, 23
        ]
        
        point3f[] points = [
            (-10, 0, -10), (-5, 0, -10), (5, 0, -10), (10, 0, -10),
            (-10, 0.5, -5), (-5, 1.0, -5), (5, 0.8, -5), (10, 0.3, -5),
            (-10, 1.2, 0), (-5, 2.0, 0), (5, 1.5, 0), (10, 0.7, 0),
            (-10, 0.8, 5), (-5, 1.5, 5), (5, 1.2, 5), (10, 0.5, 5),
            (-10, 0.2, 10), (-5, 0.6, 10), (5, 0.4, 10), (10, 0.1, 10),
            (-10, 0, 15), (-5, 0, 15), (5, 0, 15), (10, 0, 15)
        ]
        
        texCoord2f[] primvars:st = [
            (0, 0), (0.25, 0), (0.75, 0), (1, 0),
            (0, 0.25), (0.25, 0.25), (0.75, 0.25), (1, 0.25),
            (0, 0.5), (0.25, 0.5), (0.75, 0.5), (1, 0.5),
            (0, 0.75), (0.25, 0.75), (0.75, 0.75), (1, 0.75),
            (0, 1), (0.25, 1), (0.75, 1), (1, 1),
            (0, 1), (0.25, 1), (0.75, 1), (1, 1)
        ] (
            interpolation = "vertex"
        )
        
        uniform token subdivisionScheme = "none"
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, -0.5, 0, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </MarsGround/Materials/MarsSurfaceMaterial>
    }
    
    def "Rocks" {
        def Sphere "Rock1" (
            prepend apiSchemas = ["MaterialBindingAPI"]
        )
        {
            double radius = 0.7
            matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (-5, 0.7, 5, 1) )
            uniform token[] xformOpOrder = ["xformOp:transform"]
            rel material:binding = </MarsGround/Materials/RockMaterial>
        }
        
        def Sphere "Rock2" (
            prepend apiSchemas = ["MaterialBindingAPI"]
        )
        {
            double radius = 0.5
            matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (3, 0.5, -3, 1) )
            uniform token[] xformOpOrder = ["xformOp:transform"]
            rel material:binding = </MarsGround/Materials/RockMaterial>
        }
        
        def Sphere "Rock3" (
            prepend apiSchemas = ["MaterialBindingAPI"]
        )
        {
            double radius = 0.9
            matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (7, 0.9, 7, 1) )
            uniform token[] xformOpOrder = ["xformOp:transform"]
            rel material:binding = </MarsGround/Materials/RockMaterial>
        }
    }
    
    def "Craters" {
        def Sphere "Crater1" (
            prepend apiSchemas = ["MaterialBindingAPI"]
        )
        {
            double radius = 2.0
            matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, -1.5, 3, 1) )
            uniform token[] xformOpOrder = ["xformOp:transform"]
            rel material:binding = </MarsGround/Materials/CraterMaterial>
        }
        
        def Sphere "Crater2" (
            prepend apiSchemas = ["MaterialBindingAPI"]
        )
        {
            double radius = 1.5
            matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (-6, -1.0, -4, 1) )
            uniform token[] xformOpOrder = ["xformOp:transform"]
            rel material:binding = </MarsGround/Materials/CraterMaterial>
        }
    }
    
    def "Materials"
    {
        def Material "MarsSurfaceMaterial"
        {
            token outputs:surface.connect = </MarsGround/Materials/MarsSurfaceMaterial/PBRShader.outputs:surface>
            
            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.85, 0.45, 0.25)
                float inputs:metallic = 0.0
                float inputs:roughness = 0.9
                token outputs:surface
            }
        }
        
        def Material "RockMaterial"
        {
            token outputs:surface.connect = </MarsGround/Materials/RockMaterial/PBRShader.outputs:surface>
            
            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.6, 0.3, 0.2)
                float inputs:metallic = 0.1
                float inputs:roughness = 0.8
                token outputs:surface
            }
        }
        
        def Material "CraterMaterial"
        {
            token outputs:surface.connect = </MarsGround/Materials/CraterMaterial/PBRShader.outputs:surface>
            
            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.7, 0.4, 0.25)
                float inputs:metallic = 0.0
                float inputs:roughness = 0.95
                token outputs:surface
            }
        }
    }
}
`;

  fs.writeFileSync('mars_terrain.usda', usda);
  console.log('Mars terrain USDA file created successfully');
  
  // Create a USDZ file (simplified approach)
  fs.copyFileSync('mars_terrain.usda', 'mars_terrain.usdz');
  console.log('Mars terrain USDZ file created from USDA');
}

createMarsTerrainUSDA();