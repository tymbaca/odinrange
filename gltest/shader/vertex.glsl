#version 410 core
layout (location = 0) in vec3 pos;
// layout (location = 1) in float alter;

void main()
{
    vec3 modPos = pos * 0.5;
    // vec3 modPos = pos * alter;
    gl_Position = vec4(modPos.x, modPos.y, modPos.z, 1.0);
}
