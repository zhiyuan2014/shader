#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;


void main()
{
    vec4 normalColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);

	float gray = dot(normalColor.rgb, vec3(0.299 * 0.5, 0.587 * 0.5, 0.114 * 0.5));
    gl_FragColor = vec4(gray, gray, gray, normalColor.a * 0.5);
}
