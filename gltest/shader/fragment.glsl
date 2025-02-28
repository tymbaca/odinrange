#version 410 core

in vec4 color;
in vec2 uv;
in float factor;

out vec4 FragColor;

uniform sampler2D ourTexture1;
uniform sampler2D ourTexture2;

void main()
{
    if (factor < 0.5) 
    {
        FragColor = texture(ourTexture1, uv);
    } 
    else 
    {
        FragColor = texture(ourTexture2, uv);
    }
}
