# Ray-Marching Template
This is a basic Ray-Marcher written in GLSL. Currently, if you set it up the `gl_FragColor` will output: `vec4(normal.x, normal.y, normal.z, depth)`
If the ray does not hit anything, the `gl_FragColor` will output: `vec4(0.0)`
I have not tested it, but I am very certain it would work when given an environment to work with.
It requires the Resolution, `vec2(x, y)` the Camera FOV, `float fov` the Camera Position, `vec3(x, y, z)` and the Rotation Matrix.
The first `vec3` of the rotation matrix matches the right and left sides of the screen.
The second `vec3` of the rotation matrix matches the top and bottom of the screen.
The third `vec3` of the rotation matrix matches the forward and backwards direction of the screen.
For example, you could use `mat3(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0)` which will result in the right side of the screen being +X, the top side of the screen being +Y, and the forward direction of the screen +Z.