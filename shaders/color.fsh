#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
    vec4 color1 = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
    color1.r = color1.a * v_fragmentColor.r;
    color1.g = color1.a * v_fragmentColor.g;
    color1.b = color1.a * v_fragmentColor.b;
	gl_FragColor = color1;
}
