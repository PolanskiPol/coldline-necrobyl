# GODOT CRT SHADER

This is a simple CRT Shader that mimic old crt tvs for godot.

It's designed as a one file only shader. There's also a scene included as an example of how to use it.

## How to use

! CAUTION !
As of the day of this publication (02/07/2019), Godot 3.1, it's critical to set the ColorRect node as a child of a regular Control node,
otherwise, the shader parameters won't work.

- Create a control node
- Create a ColorRect node as its child
- Create a new ShaderMaterial for the ColorRect
- Assign the "OverlayShader.shader" for the new ShaderMaterial.

The Shader parameters should be available for tweaking in the material.

## Observations

The texture is the noise used for displacement. "Texture1.png" is sent with the package as a demonstration.