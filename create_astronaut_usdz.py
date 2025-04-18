#!/usr/bin/env python3

from pxr import Usd, UsdGeom, UsdShade, Sdf, Gf, Vt

# Create a new USD stage
stage = Usd.Stage.CreateNew("astronaut.usda")

# Define up-axis
UsdGeom.SetStageUpAxis(stage, UsdGeom.Tokens.y)

# Create the root astronaut
astronaut = UsdGeom.Xform.Define(stage, "/Astronaut")
astronaut.AddTranslateOp().Set((0, 0, 0))

# Add a cute body shape
body = UsdGeom.Capsule.Define(stage, "/Astronaut/Body")
body.GetRadiusAttr().Set(0.4)
body.GetHeightAttr().Set(1.5)
body.GetAxisAttr().Set("Y")
body.AddTranslateOp().Set((0.0, 0.0, 0.0))

# Add a head (helmet)
helmet = UsdGeom.Sphere.Define(stage, "/Astronaut/Helmet")
helmet.GetRadiusAttr().Set(0.4)
helmet.AddTranslateOp().Set((0.0, 1.0, 0.0))

# Add visor
visor = UsdGeom.Sphere.Define(stage, "/Astronaut/Visor")
visor.GetRadiusAttr().Set(0.35)
visor.AddTranslateOp().Set((0.0, 1.0, 0.25))

# Add left arm - cute stubby arm
leftArm = UsdGeom.Cylinder.Define(stage, "/Astronaut/LeftArm")
leftArm.GetRadiusAttr().Set(0.15)
leftArm.GetHeightAttr().Set(0.6)
leftArm.AddTranslateOp().Set((-0.55, 0.4, 0.0))
leftArm.AddRotateXYZOp().Set((0, 0, -30))

# Add right arm - waving
rightArm = UsdGeom.Cylinder.Define(stage, "/Astronaut/RightArm")
rightArm.GetRadiusAttr().Set(0.15)
rightArm.GetHeightAttr().Set(0.6)
rightArm.AddTranslateOp().Set((0.55, 0.4, 0.0))
rightArm.AddRotateXYZOp().Set((30, 20, 30))

# Add left leg
leftLeg = UsdGeom.Cylinder.Define(stage, "/Astronaut/LeftLeg")
leftLeg.GetRadiusAttr().Set(0.18)
leftLeg.GetHeightAttr().Set(0.8)
leftLeg.AddTranslateOp().Set((-0.2, -0.7, 0.0))
leftLeg.AddRotateXYZOp().Set((0, 0, -5))

# Add right leg
rightLeg = UsdGeom.Cylinder.Define(stage, "/Astronaut/RightLeg")
rightLeg.GetRadiusAttr().Set(0.18)
rightLeg.GetHeightAttr().Set(0.8)
rightLeg.AddTranslateOp().Set((0.2, -0.7, 0.0))
rightLeg.AddRotateXYZOp().Set((0, 0, 5))

# Create materials using simplified approach with direct relationships
# Create material library scope
materialScope = UsdGeom.Scope.Define(stage, "/Astronaut/Materials")

# Add material and shader definitions directly
materialRoot = "/Astronaut/Materials"

# Spacesuit Material
stage.DefinePrim(f"{materialRoot}/SuitMaterial", "Material")
stage.DefinePrim(f"{materialRoot}/SuitMaterial/PBRShader", "Shader")

shader = stage.GetPrimAtPath(f"{materialRoot}/SuitMaterial/PBRShader")
shader.CreateAttribute("info:id", Sdf.ValueTypeNames.Token).Set("UsdPreviewSurface")
shader.CreateAttribute("inputs:diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(1.0, 0.5, 0.2))  # Bright orange
shader.CreateAttribute("inputs:roughness", Sdf.ValueTypeNames.Float).Set(0.4)
shader.CreateAttribute("inputs:metallic", Sdf.ValueTypeNames.Float).Set(0.1)

material = stage.GetPrimAtPath(f"{materialRoot}/SuitMaterial")
material.CreateAttribute("outputs:surface", Sdf.ValueTypeNames.Token).Set("outputs:surface")

# White helmet
helmetMaterial = UsdShade.Material.Define(stage, materialPaths["helmet"])
helmetShader = UsdShade.Shader.Define(stage, materialPaths["helmet"] + "/PBRShader")
helmetShader.CreateIdAttr("UsdPreviewSurface")
helmetShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.95, 0.95, 0.95))  # White
helmetShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.3)
helmetShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.2)
helmetMaterial.CreateSurfaceOutput().ConnectToSource(helmetShader, "surface")

# Blue visor
visorMaterial = UsdShade.Material.Define(stage, materialPaths["visor"])
visorShader = UsdShade.Shader.Define(stage, materialPaths["visor"] + "/PBRShader")
visorShader.CreateIdAttr("UsdPreviewSurface")
visorShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.2, 0.4, 0.8))  # Blue
visorShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.1)
visorShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.9)
visorShader.CreateInput("opacity", Sdf.ValueTypeNames.Float).Set(0.7)  # Slightly transparent
visorMaterial.CreateSurfaceOutput().ConnectToSource(visorShader, "surface")

# Bind materials to geometries
UsdShade.MaterialBindingAPI(body).Bind(suitMaterial)
UsdShade.MaterialBindingAPI(helmet).Bind(helmetMaterial)
UsdShade.MaterialBindingAPI(visor).Bind(visorMaterial)
UsdShade.MaterialBindingAPI(leftArm).Bind(suitMaterial)
UsdShade.MaterialBindingAPI(rightArm).Bind(suitMaterial)
UsdShade.MaterialBindingAPI(leftLeg).Bind(suitMaterial)
UsdShade.MaterialBindingAPI(rightLeg).Bind(suitMaterial)

# Set the default prim
stage.SetDefaultPrim(astronaut.GetPrim())

# Save the stage
stage.Save()

# Now we'll create the usdz file by "packing" the usda
import os
os.system("python3 -m pxr.usdutils.usdzip astronaut.usda -o astronaut.usdz")

print("Created astronaut.usda and astronaut.usdz")

# Now, let's create a Mars terrain USDZ
terrain_stage = Usd.Stage.CreateNew("mars_terrain.usda")
UsdGeom.SetStageUpAxis(terrain_stage, UsdGeom.Tokens.y)

# Create the Mars terrain
mars = UsdGeom.Xform.Define(terrain_stage, "/MarsGround")

# Create a simple terrain mesh
terrain = UsdGeom.Mesh.Define(terrain_stage, "/MarsGround/Terrain")

# Create a grid of points for the Mars terrain surface
size = 20.0
divisions = 20
points = []
for i in range(divisions + 1):
    for j in range(divisions + 1):
        x = (i / divisions - 0.5) * size
        z = (j / divisions - 0.5) * size
        
        # Create some random heights for natural-looking terrain
        import math
        y = 0.0
        # Add different frequency noise for more natural terrain
        y += math.sin(x * 0.5) * math.cos(z * 0.4) * 0.5
        y += math.sin(x * 1.0 + 0.5) * math.cos(z * 1.2 + 0.3) * 0.25
        y += math.sin(x * 2.0 + 1.0) * math.cos(z * 1.8 + 0.8) * 0.125
        
        # Make the center higher for a small plateau/hill
        dist_from_center = math.sqrt(x*x + z*z)
        y += max(0, 1.0 - dist_from_center/6.0)
        
        points.append((x, y, z))

# Create faces (indices)
face_vertex_counts = []
face_vertex_indices = []
for i in range(divisions):
    for j in range(divisions):
        # Get the four corner vertices of this grid cell
        v0 = i * (divisions + 1) + j
        v1 = i * (divisions + 1) + (j + 1)
        v2 = (i + 1) * (divisions + 1) + (j + 1)
        v3 = (i + 1) * (divisions + 1) + j
        
        # Add a quad (4-sided polygon)
        face_vertex_counts.append(4)
        face_vertex_indices.extend([v0, v1, v2, v3])

# Set the mesh attributes
terrain.GetPointsAttr().Set(points)
terrain.GetFaceVertexCountsAttr().Set(face_vertex_counts)
terrain.GetFaceVertexIndicesAttr().Set(face_vertex_indices)

# Create Mars terrain material
marsMaterial = UsdShade.Material.Define(terrain_stage, "/MarsGround/Materials/MarsSurfaceMaterial")
marsShader = UsdShade.Shader.Define(terrain_stage, "/MarsGround/Materials/MarsSurfaceMaterial/PBRShader")
marsShader.CreateIdAttr("UsdPreviewSurface")
marsShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.85, 0.45, 0.25))  # Martian red
marsShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.9)
marsShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.0)
marsMaterial.CreateSurfaceOutput().ConnectToSource(marsShader, "surface")

# Bind material to terrain
UsdShade.MaterialBindingAPI(terrain).Bind(marsMaterial)

# Add some rocks for visual interest
import random
for i in range(10):
    rock = UsdGeom.Sphere.Define(terrain_stage, f"/MarsGround/Rock{i}")
    # Random size between 0.3 and 1.2
    radius = random.uniform(0.3, 1.2)
    rock.GetRadiusAttr().Set(radius)
    
    # Random position
    x = random.uniform(-8, 8)
    z = random.uniform(-8, 8)
    # Find approximate height at this position
    y = 0.0
    y += math.sin(x * 0.5) * math.cos(z * 0.4) * 0.5
    y += math.sin(x * 1.0 + 0.5) * math.cos(z * 1.2 + 0.3) * 0.25
    y += math.sin(x * 2.0 + 1.0) * math.cos(z * 1.8 + 0.8) * 0.125
    dist_from_center = math.sqrt(x*x + z*z)
    y += max(0, 1.0 - dist_from_center/6.0)
    
    # Position on surface
    rock.AddTranslateOp().Set((x, y + radius * 0.5, z))
    
    # Create rock material
    rockMaterial = UsdShade.Material.Define(terrain_stage, f"/MarsGround/Materials/RockMaterial{i}")
    rockShader = UsdShade.Shader.Define(terrain_stage, f"/MarsGround/Materials/RockMaterial{i}/PBRShader")
    rockShader.CreateIdAttr("UsdPreviewSurface")
    
    # Slightly different colors for variety
    red = random.uniform(0.6, 0.7)
    green = random.uniform(0.3, 0.4)
    blue = random.uniform(0.18, 0.25)
    rockShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(red, green, blue))
    rockShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(random.uniform(0.7, 0.9))
    rockShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(random.uniform(0.0, 0.15))
    rockMaterial.CreateSurfaceOutput().ConnectToSource(rockShader, "surface")
    
    # Bind material
    UsdShade.MaterialBindingAPI(rock).Bind(rockMaterial)

# Set the default prim for Mars terrain
terrain_stage.SetDefaultPrim(mars.GetPrim())

# Save the stage
terrain_stage.Save()

# Now create the USDZ file for Mars terrain
os.system("python3 -m pxr.usdutils.usdzip mars_terrain.usda -o mars_terrain.usdz")

print("Created mars_terrain.usda and mars_terrain.usdz")

# Finally, let's create a scientific station USDZ
station_stage = Usd.Stage.CreateNew("station.usda")
UsdGeom.SetStageUpAxis(station_stage, UsdGeom.Tokens.y)

# Create the science station
station = UsdGeom.Xform.Define(station_stage, "/Station")

# Create the main station module (a dome)
module = UsdGeom.Sphere.Define(station_stage, "/Station/MainModule")
module.GetRadiusAttr().Set(2.0)
# Cut the bottom half off by scaling Y
module.AddScaleOp().Set((1.0, 0.5, 1.0))
module.AddTranslateOp().Set((0.0, 1.0, 0.0))

# Base/platform
base = UsdGeom.Cylinder.Define(station_stage, "/Station/Base")
base.GetRadiusAttr().Set(2.2)
base.GetHeightAttr().Set(0.2)
base.AddTranslateOp().Set((0.0, 0.1, 0.0))

# Add solar panels
solarPanel1 = UsdGeom.Cube.Define(station_stage, "/Station/SolarPanel1")
solarPanel1.GetSizeAttr().Set((3.0, 0.1, 1.5))
solarPanel1.AddTranslateOp().Set((2.0, 1.5, 0.0))
solarPanel1.AddRotateXYZOp().Set((0.0, 0.0, 15.0))

solarPanel2 = UsdGeom.Cube.Define(station_stage, "/Station/SolarPanel2")
solarPanel2.GetSizeAttr().Set((3.0, 0.1, 1.5))
solarPanel2.AddTranslateOp().Set((-2.0, 1.5, 0.0))
solarPanel2.AddRotateXYZOp().Set((0.0, 0.0, -15.0))

# Add communication dish
dishBase = UsdGeom.Cylinder.Define(station_stage, "/Station/DishBase")
dishBase.GetRadiusAttr().Set(0.15)
dishBase.GetHeightAttr().Set(1.0)
dishBase.AddTranslateOp().Set((1.5, 2.0, 1.5))

dish = UsdGeom.Cone.Define(station_stage, "/Station/Dish")
dish.GetRadiusAttr().Set(0.5)
dish.GetHeightAttr().Set(0.3)
dish.AddTranslateOp().Set((1.5, 2.5, 1.5))
dish.AddRotateXYZOp().Set((180.0, 0.0, 0.0))  # Flip upside down

# Add some entrance tubes/airlocks
entrance = UsdGeom.Cylinder.Define(station_stage, "/Station/Entrance")
entrance.GetRadiusAttr().Set(0.5)
entrance.GetHeightAttr().Set(1.5)
entrance.GetAxisAttr().Set("Z")  # Z axis to extend horizontally
entrance.AddTranslateOp().Set((0.0, 0.8, 2.0))

sideEntrance = UsdGeom.Cylinder.Define(station_stage, "/Station/SideEntrance")
sideEntrance.GetRadiusAttr().Set(0.5)
sideEntrance.GetHeightAttr().Set(1.5)
sideEntrance.GetAxisAttr().Set("X")  # X axis to extend horizontally
sideEntrance.AddTranslateOp().Set((2.0, 0.8, 0.0))

# Create materials for the station
# Module material (white/metallic)
moduleMaterial = UsdShade.Material.Define(station_stage, "/Station/Materials/ModuleMaterial")
moduleShader = UsdShade.Shader.Define(station_stage, "/Station/Materials/ModuleMaterial/PBRShader")
moduleShader.CreateIdAttr("UsdPreviewSurface")
moduleShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.9, 0.9, 0.9))  # White
moduleShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.3)
moduleShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.6)
moduleMaterial.CreateSurfaceOutput().ConnectToSource(moduleShader, "surface")

# Solar panel material (blue with metallic)
solarMaterial = UsdShade.Material.Define(station_stage, "/Station/Materials/SolarMaterial")
solarShader = UsdShade.Shader.Define(station_stage, "/Station/Materials/SolarMaterial/PBRShader")
solarShader.CreateIdAttr("UsdPreviewSurface")
solarShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.2, 0.2, 0.8))  # Blue
solarShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.1)
solarShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.8)
solarMaterial.CreateSurfaceOutput().ConnectToSource(solarShader, "surface")

# Communication dish material (gray metallic)
dishMaterial = UsdShade.Material.Define(station_stage, "/Station/Materials/DishMaterial")
dishShader = UsdShade.Shader.Define(station_stage, "/Station/Materials/DishMaterial/PBRShader")
dishShader.CreateIdAttr("UsdPreviewSurface")
dishShader.CreateInput("diffuseColor", Sdf.ValueTypeNames.Color3f).Set(Gf.Vec3f(0.7, 0.7, 0.7))  # Gray
dishShader.CreateInput("roughness", Sdf.ValueTypeNames.Float).Set(0.2)
dishShader.CreateInput("metallic", Sdf.ValueTypeNames.Float).Set(0.9)
dishMaterial.CreateSurfaceOutput().ConnectToSource(dishShader, "surface")

# Bind materials
UsdShade.MaterialBindingAPI(module).Bind(moduleMaterial)
UsdShade.MaterialBindingAPI(base).Bind(moduleMaterial)
UsdShade.MaterialBindingAPI(solarPanel1).Bind(solarMaterial)
UsdShade.MaterialBindingAPI(solarPanel2).Bind(solarMaterial)
UsdShade.MaterialBindingAPI(dishBase).Bind(moduleMaterial)
UsdShade.MaterialBindingAPI(dish).Bind(dishMaterial)
UsdShade.MaterialBindingAPI(entrance).Bind(moduleMaterial)
UsdShade.MaterialBindingAPI(sideEntrance).Bind(moduleMaterial)

# Set the default prim
station_stage.SetDefaultPrim(station.GetPrim())

# Save the stage
station_stage.Save()

# Create the USDZ file
os.system("python3 -m pxr.usdutils.usdzip station.usda -o station.usdz")

print("Created station.usda and station.usdz")