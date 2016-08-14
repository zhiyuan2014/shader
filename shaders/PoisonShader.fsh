#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main()
{
	float pct = abs(sin(CC_Time[1] * 3.0));
    gl_FragColor = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
	gl_FragColor.r *= 0.5 + (1.0 - pct) * 0.5;
	gl_FragColor.r += 0.08 * gl_FragColor.a * pct;
	gl_FragColor.g *= 0.5 + (1.0 - pct) * 0.5;
	gl_FragColor.b *= 0.3 + (1.0 - pct) * 0.7;
	gl_FragColor.b += 0.5 * gl_FragColor.a * pct;
}
