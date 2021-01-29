#version 460 core

// Input Screen Resolution
uniform vec2 resolution;

// Input Camera FOV
uniform float camFOV;

// Input Camera Position
uniform vec3 camPos;

// Input Rotation Matrix
uniform mat3 rotMat;

// Ray-Marching Settings
// Maximum Ray-Marches
#define maxmarches 128

// Collision Distance
#define collisiondist 0.01

// Maximum Distance
#define maxdist 32.0

// Sphere Distance-Estimator
float DE(vec3 raypos){
    return length(raypos)-0.5;
}

// Ray-Marching
vec4 raymarch(vec3 raydir, vec3 rayori){
    // Make the Ray Position the Ray Origin, in this case the Camera
    vec3 raypos = rayori;

    // Define the distance estimate and then define the distance travelled which starts at 0.0
    float distest, disttrav = 0.0;

    // The loop with the Ray-Marching
    for(int i = 0; i < maxmarches; i++){
        // Find the distance to the scene
        distest = DE(raypos);

        // If we hit the scene return the position we hit and the distance we travelled
        if(distest < collisiondist){return vec4(raypos, disttrav);}

        // Add the distance we are going to travel first so that we save time if the ray escapes the scene
        disttrav += distest;

        // Check if we escaped the scene
        if(disttrav > maxdist){break;}

        // If all is good, we can safely march our ray forward
        raypos += raydir*distest;
    }

    // If our ray never hit anything return vec4(0.0)
    return vec4(0.0);
}

// Forward-Central Differences SDF Normal Calculation
// https://www.iquilezles.org/www/articles/normalsSDF/normalsSDF.htm
vec3 calcNormal(vec3 pos){
    vec2 diff = vec2(collisiondist, 0.0);
    return normalize(vec3(DE(pos+diff.xyy)-DE(pos-diff.xyy),
                          DE(pos+diff.yxy)-DE(pos-diff.yxy),
                          DE(pos+diff.yyx)-DE(pos-diff.yyx)));
}

// Main Function
void main(){
    // Screen UV Coordinates Centered on [0.0, 0.0]
    vec2 uv = 2.0*(gl_FragCoord.xy-0.5*resolution.xy)/max(resolution.x, resolution.y);

    // The Output Color
    vec3 color = vec3(0.0);

    // The Direction of the Ray
    vec3 raydir = normalize(camfov*(uv.y*rotMat[0]+uv.y*rotMat[1])+rotMat[2]);

    // Perform the Ray-Marching
    vec4 raymarched = raymarch(raydir, camPos);

    // If the ray hit something, make the output the normal of that point
    if(raymarched != vec3(0.0){
        vec3 normal = calcNormal(raymarched.xyz);
        color = normal;
    }

    // Output the Color and Depth (Depth is 0.0 if there was no collision)
    gl_FragColor = vec4(color, raymarched.w);
}