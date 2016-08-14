#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

//uniform mat4 colorEffect;
uniform vec4 colorEffect;

void main()
{
//    gl_FragColor = texture2D(CC_Texture0, v_texCoord) * colorEffect * v_fragmentColor;
    gl_FragColor = texture2D(CC_Texture0, v_texCoord) * colorEffect * v_fragmentColor;
}

