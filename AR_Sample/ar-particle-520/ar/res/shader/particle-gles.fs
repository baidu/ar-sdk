precision highp float;

varying vec2 texCoordOut;
varying vec4 colorOut;
varying float typeOut;

uniform sampler2D uDiffuseTexture;

void main() {
    if (typeOut > 0.5){
        // 当使用GL_Points时直接贴上纹理
        gl_FragColor =  colorOut * texture2D(uDiffuseTexture,gl_PointCoord);
    }else{
        highp vec4 textureColor = texture2D(uDiffuseTexture, texCoordOut);
        gl_FragColor = colorOut * textureColor;
    }

}
