const fs = require('fs');
const { Document, NodeIO } = require('@gltf-transform/core');
const { KHRONOS_EXTENSIONS } = require('@gltf-transform/extensions');

// Create a new glTF document
async function createAstronaut() {
  const document = new Document();
  const buffer = document.createBuffer();
  
  // Create a scene and add it to the document
  const scene = document.createScene();
  
  // Create materials for the astronaut
  const whiteMaterial = document.createMaterial('white')
    .setBaseColorFactor([0.9, 0.9, 0.9, 1.0]);
  
  const visormaterial = document.createMaterial('visor')
    .setBaseColorFactor([0.2, 0.4, 0.8, 0.8])
    .setMetallicFactor(0.9)
    .setRoughnessFactor(0.1);
  
  const orangeMaterial = document.createMaterial('orange')
    .setBaseColorFactor([0.9, 0.5, 0.1, 1.0]);
  
  // Create a primitive for the astronaut's body - a capsule shape
  const bodyPrimitive = document.createPrimitive()
    .setMaterial(orangeMaterial);
  
  // Create body mesh (simplified as a cylinder)
  const bodyIndices = [
    0, 1, 2, 0, 2, 3,    // front face
    4, 5, 6, 4, 6, 7,    // back face
    0, 3, 7, 0, 7, 4,    // top face
    1, 5, 6, 1, 6, 2,    // bottom face
    0, 1, 5, 0, 5, 4,    // left face
    3, 2, 6, 3, 6, 7     // right face
  ];
  
  const bodyPositions = [
    // Front face
    -0.5, -1.0, 0.3,  // bottom left
     0.5, -1.0, 0.3,  // bottom right
     0.5,  0.7, 0.3,  // top right
    -0.5,  0.7, 0.3,  // top left
    // Back face
    -0.5, -1.0, -0.3,  // bottom left
     0.5, -1.0, -0.3,  // bottom right
     0.5,  0.7, -0.3,  // top right
    -0.5,  0.7, -0.3   // top left
  ];
  
  const bodyAccessorIndices = document.createAccessor('indices')
    .setArray(new Uint16Array(bodyIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const bodyAccessorPosition = document.createAccessor('positions')
    .setArray(new Float32Array(bodyPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  bodyPrimitive.setIndices(bodyAccessorIndices);
  bodyPrimitive.setAttribute('POSITION', bodyAccessorPosition);
  
  // Create helmet (a sphere)
  const helmetPrimitive = document.createPrimitive()
    .setMaterial(whiteMaterial);
  
  // Very simplified sphere for the helmet
  const helmetPositions = [];
  const helmetIndices = [];
  
  // Generate a simple sphere
  const segments = 12;
  const radius = 0.4;
  const yOffset = 1.0;
  
  for (let lat = 0; lat <= segments; lat++) {
    const theta = (lat * Math.PI) / segments;
    const sinTheta = Math.sin(theta);
    const cosTheta = Math.cos(theta);
    
    for (let lon = 0; lon <= segments; lon++) {
      const phi = (lon * 2 * Math.PI) / segments;
      const sinPhi = Math.sin(phi);
      const cosPhi = Math.cos(phi);
      
      const x = radius * sinTheta * cosPhi;
      const y = radius * cosTheta + yOffset;
      const z = radius * sinTheta * sinPhi;
      
      helmetPositions.push(x, y, z);
    }
  }
  
  // Create indices for the sphere
  for (let lat = 0; lat < segments; lat++) {
    for (let lon = 0; lon < segments; lon++) {
      const first = lat * (segments + 1) + lon;
      const second = first + segments + 1;
      
      helmetIndices.push(first, second, first + 1);
      helmetIndices.push(second, second + 1, first + 1);
    }
  }
  
  const helmetAccessorIndices = document.createAccessor('helmet_indices')
    .setArray(new Uint16Array(helmetIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const helmetAccessorPosition = document.createAccessor('helmet_positions')
    .setArray(new Float32Array(helmetPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  helmetPrimitive.setIndices(helmetAccessorIndices);
  helmetPrimitive.setAttribute('POSITION', helmetAccessorPosition);
  
  // Create visor (front part of helmet)
  const visorPrimitive = document.createPrimitive()
    .setMaterial(visormaterial);
    
  // A simplified visor as a partial sphere section
  const visorPositions = [];
  const visorIndices = [];
  
  // Generate visor points (front half of sphere)
  for (let lat = 3; lat <= segments/2; lat++) {
    const theta = (lat * Math.PI) / segments;
    const sinTheta = Math.sin(theta);
    const cosTheta = Math.cos(theta);
    
    for (let lon = segments/4; lon <= 3*segments/4; lon++) {
      const phi = (lon * 2 * Math.PI) / segments;
      const sinPhi = Math.sin(phi);
      const cosPhi = Math.cos(phi);
      
      const x = radius * 0.85 * sinTheta * cosPhi;
      const y = radius * 0.85 * cosTheta + yOffset;
      const z = radius * 0.85 * sinTheta * sinPhi + 0.1; // Push forward a bit
      
      visorPositions.push(x, y, z);
    }
  }
  
  // Create indices for the visor
  const visorRows = (segments/2) - 3 + 1;
  const visorCols = (3*segments/4) - (segments/4) + 1;
  
  for (let lat = 0; lat < visorRows - 1; lat++) {
    for (let lon = 0; lon < visorCols - 1; lon++) {
      const first = lat * visorCols + lon;
      const second = first + visorCols;
      
      visorIndices.push(first, second, first + 1);
      visorIndices.push(second, second + 1, first + 1);
    }
  }
  
  const visorAccessorIndices = document.createAccessor('visor_indices')
    .setArray(new Uint16Array(visorIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const visorAccessorPosition = document.createAccessor('visor_positions')
    .setArray(new Float32Array(visorPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  visorPrimitive.setIndices(visorAccessorIndices);
  visorPrimitive.setAttribute('POSITION', visorAccessorPosition);
  
  // Create mesh for body and helmet
  const bodyMesh = document.createMesh('body')
    .addPrimitive(bodyPrimitive);
    
  const helmetMesh = document.createMesh('helmet')
    .addPrimitive(helmetPrimitive);
    
  const visorMesh = document.createMesh('visor')
    .addPrimitive(visorPrimitive);
  
  // Create nodes
  const mainNode = document.createNode('astronaut')
    .setTranslation([0, 0, 0])
    .setScale([1, 1, 1]);
  
  // Body node
  const bodyNode = document.createNode('body')
    .setMesh(bodyMesh);
  
  // Helmet node  
  const helmetNode = document.createNode('helmet')
    .setMesh(helmetMesh);
    
  // Visor node
  const visorNode = document.createNode('visor')
    .setMesh(visorMesh);
  
  // Link the nodes in a hierarchy
  mainNode.addChild(bodyNode);
  mainNode.addChild(helmetNode);
  mainNode.addChild(visorNode);
  
  // Add the main node to the scene
  scene.addChild(mainNode);
  
  // Arms
  // Left arm
  const leftArmPositions = [
    -0.5, 0.3, 0.0,    // shoulder
    -0.9, -0.2, 0.3,   // elbow
    -0.8, -0.7, 0.3    // hand
  ];
  
  const leftArmIndices = [0, 1, 2];
  
  const leftArmAccessorIndices = document.createAccessor('left_arm_indices')
    .setArray(new Uint16Array(leftArmIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const leftArmAccessorPosition = document.createAccessor('left_arm_positions')
    .setArray(new Float32Array(leftArmPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  const leftArmPrimitive = document.createPrimitive()
    .setMaterial(orangeMaterial)
    .setIndices(leftArmAccessorIndices)
    .setAttribute('POSITION', leftArmAccessorPosition)
    .setMode(1); // LINE_STRIP
  
  const leftArmMesh = document.createMesh('left_arm')
    .addPrimitive(leftArmPrimitive);
  
  const leftArmNode = document.createNode('left_arm')
    .setMesh(leftArmMesh);
    
  // Right arm
  const rightArmPositions = [
    0.5, 0.3, 0.0,    // shoulder
    0.9, 0.1, 0.3,    // elbow
    0.8, -0.3, 0.4    // hand (raised in a wave)
  ];
  
  const rightArmIndices = [0, 1, 2];
  
  const rightArmAccessorIndices = document.createAccessor('right_arm_indices')
    .setArray(new Uint16Array(rightArmIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const rightArmAccessorPosition = document.createAccessor('right_arm_positions')
    .setArray(new Float32Array(rightArmPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  const rightArmPrimitive = document.createPrimitive()
    .setMaterial(orangeMaterial)
    .setIndices(rightArmAccessorIndices)
    .setAttribute('POSITION', rightArmAccessorPosition)
    .setMode(1); // LINE_STRIP
    
  const rightArmMesh = document.createMesh('right_arm')
    .addPrimitive(rightArmPrimitive);
  
  const rightArmNode = document.createNode('right_arm')
    .setMesh(rightArmMesh);
  
  // Legs
  // Left leg
  const leftLegPositions = [
    -0.2, -1.0, 0.0,    // hip
    -0.3, -1.5, 0.0,    // knee
    -0.2, -2.0, 0.2     // foot (slightly forward)
  ];
  
  const leftLegIndices = [0, 1, 2];
  
  const leftLegAccessorIndices = document.createAccessor('left_leg_indices')
    .setArray(new Uint16Array(leftLegIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const leftLegAccessorPosition = document.createAccessor('left_leg_positions')
    .setArray(new Float32Array(leftLegPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  const leftLegPrimitive = document.createPrimitive()
    .setMaterial(orangeMaterial)
    .setIndices(leftLegAccessorIndices)
    .setAttribute('POSITION', leftLegAccessorPosition)
    .setMode(1); // LINE_STRIP
    
  const leftLegMesh = document.createMesh('left_leg')
    .addPrimitive(leftLegPrimitive);
  
  const leftLegNode = document.createNode('left_leg')
    .setMesh(leftLegMesh);
  
  // Right leg
  const rightLegPositions = [
    0.2, -1.0, 0.0,     // hip
    0.3, -1.5, 0.0,     // knee
    0.4, -2.0, -0.2     // foot (slightly back)
  ];
  
  const rightLegIndices = [0, 1, 2];
  
  const rightLegAccessorIndices = document.createAccessor('right_leg_indices')
    .setArray(new Uint16Array(rightLegIndices))
    .setType('SCALAR')
    .setBuffer(buffer);
  
  const rightLegAccessorPosition = document.createAccessor('right_leg_positions')
    .setArray(new Float32Array(rightLegPositions))
    .setType('VEC3')
    .setBuffer(buffer);
  
  const rightLegPrimitive = document.createPrimitive()
    .setMaterial(orangeMaterial)
    .setIndices(rightLegAccessorIndices)
    .setAttribute('POSITION', rightLegAccessorPosition)
    .setMode(1); // LINE_STRIP
    
  const rightLegMesh = document.createMesh('right_leg')
    .addPrimitive(rightLegPrimitive);
  
  const rightLegNode = document.createNode('right_leg')
    .setMesh(rightLegMesh);
  
  // Add limbs to the main node
  mainNode.addChild(leftArmNode);
  mainNode.addChild(rightArmNode);
  mainNode.addChild(leftLegNode);
  mainNode.addChild(rightLegNode);
  
  // Export the document
  const io = new NodeIO().registerExtensions(KHRONOS_EXTENSIONS);
  await io.write('astronaut.gltf', document);
  
  console.log('Astronaut model created successfully!');
}

createAstronaut().catch(console.error);