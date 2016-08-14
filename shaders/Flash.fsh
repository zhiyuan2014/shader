#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D u_lightTexture;
uniform float light_offset;

void main()
{
    vec4 color1 = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
    float offset = 1.0 - light_offset * 2.0;
    vec2 uv = v_texCoord + vec2(offset, offset);
	gl_FragColor = color1 + texture2D(u_lightTexture, uv) * color1.a;
}
