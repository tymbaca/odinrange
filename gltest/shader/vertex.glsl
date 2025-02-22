#version 410 core
in vec3 pos;
in float alter;

// out vec4 vertexColor;

void main()
{
    vec3 modPos = pos * 0.5;
    // vec3 modPos = pos * alter;
    gl_Position = vec4(modPos.x, modPos.y, modPos.z, 1.0);
    // vertexColor = vec4(0.5, 0, 0, 0);
}
