#version 410 core
layout (location = 0) in vec3 pos;
layout (location = 1) in vec4 aColor;
layout (location = 2) in vec2 aUV;
layout (location = 3) in float scale;

uniform float globalScale;

out vec4 color;
out vec2 uv;

void main()
{
    vec3 modPos = pos * scale * globalScale;
    gl_Position = vec4(modPos.x, modPos.y, modPos.z, 1.0);
    color = aColor;
    uv = aUV;
}
