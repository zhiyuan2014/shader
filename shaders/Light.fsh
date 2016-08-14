#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
    vec4 color1 = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
    vec4 light = vec4(0.65, 0.65, 0.65, 0.0);
	gl_FragColor = color1 + light * color1.a;
}
