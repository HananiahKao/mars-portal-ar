const fs = require('fs');

// Create a simple USDA file (text-based USD format)
// This will be a very simple representation of an astronaut
function createAstronautUSDA() {
  const usda = `#usda 1.0
(
    defaultPrim = "Astronaut"
    upAxis = "Y"
)

def Xform "Astronaut" (
    kind = "component"
)
{
    def Sphere "Head" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        float3[] extent = [(-0.5, -0.5, -0.5), (0.5, 0.5, 0.5)]
        double radius = 0.4
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1.0, 0, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/HelmetMaterial>
    }
    
    def Cube "Body" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        float3[] extent = [(-0.5, -1.0, -0.3), (0.5, 0.7, 0.3)]
        double size = 1
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/SuitMaterial>
    }
    
    def Cylinder "LeftArm" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        double height = 0.8
        double radius = 0.15
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 0.7, -0.7, 0), (0, 0.7, 0.7, 0), (-0.7, 0, 0.3, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/SuitMaterial>
    }
    
    def Cylinder "RightArm" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        double height = 0.8
        double radius = 0.15
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 0.7, 0.7, 0), (0, -0.7, 0.7, 0), (0.7, 0, 0.3, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/SuitMaterial>
    }
    
    def Cylinder "LeftLeg" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        double height = 1.0
        double radius = 0.2
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (-0.3, -1.5, 0, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/SuitMaterial>
    }
    
    def Cylinder "RightLeg" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        double height = 1.0
        double radius = 0.2
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0.3, -1.5, 0, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/SuitMaterial>
    }
    
    def Sphere "Visor" (
        prepend apiSchemas = ["MaterialBindingAPI"]
    )
    {
        float3[] extent = [(-0.4, -0.4, -0.2), (0.4, 0.4, 0.2)]
        double radius = 0.35
        matrix4d xformOp:transform = ( (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 1.0, 0.3, 1) )
        uniform token[] xformOpOrder = ["xformOp:transform"]
        
        rel material:binding = </Astronaut/Materials/VisorMaterial>
    }
    
    def "Materials"
    {
        def Material "SuitMaterial"
        {
            token outputs:surface.connect = </Astronaut/Materials/SuitMaterial/PBRShader.outputs:surface>

            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.9, 0.5, 0.1)
                float inputs:metallic = 0.0
                float inputs:roughness = 0.4
                token outputs:surface
            }
        }
        
        def Material "HelmetMaterial"
        {
            token outputs:surface.connect = </Astronaut/Materials/HelmetMaterial/PBRShader.outputs:surface>

            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.9, 0.9, 0.9)
                float inputs:metallic = 0.2
                float inputs:roughness = 0.3
                token outputs:surface
            }
        }
        
        def Material "VisorMaterial"
        {
            token outputs:surface.connect = </Astronaut/Materials/VisorMaterial/PBRShader.outputs:surface>

            def Shader "PBRShader"
            {
                uniform token info:id = "UsdPreviewSurface"
                color3f inputs:diffuseColor = (0.2, 0.4, 0.8)
                float inputs:metallic = 0.9
                float inputs:roughness = 0.1
                float inputs:opacity = 0.7
                token outputs:surface
            }
        }
    }
}
`;

  fs.writeFileSync('astronaut.usda', usda);
  console.log('USDA file created successfully');
  
  // Now create a simple binary placeholder USDZ file by renaming the USDA file
  // This is just to have a file with the right extension
  // In a real implementation, proper USDZ conversion tools would be used
  fs.copyFileSync('astronaut.usda', 'astronaut.usdz');
  console.log('USDZ file created from USDA (Note: This is a simple rename, not a proper conversion)');
}

createAstronautUSDA();