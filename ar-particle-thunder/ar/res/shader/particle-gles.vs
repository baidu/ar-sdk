precision highp float;

attribute vec3 position;
attribute vec4 color;
attribute vec2 texcoord;
attribute vec4 trans;
attribute vec4 velocity;

varying vec2 texCoordOut;
varying vec4 colorOut;
varying float typeOut;

uniform mat4 View;
uniform mat4 Proj;
uniform mat4 World;

uniform vec3 CameraUp;
uniform vec3 CameraPosision;
uniform float BillboardType;
uniform float imuType;
// 当使用顶点粒子（画三角片）渲染时type为0.0，当使用GL_Points时type为1.0
uniform float type;

mat4 createMatrixWithRotation(vec3 axis_src, float angle)
{
    vec3 axis = normalize(axis_src);
    
    float x = axis.x;
    float y = axis.y;
    float z = axis.z;
    
    float c = cos(angle);
    float s = sin(angle);
    
    float t = 1.0 - c;
    float tx = t * x;
    float ty = t * y;
    float tz = t * z;
    float txy = tx * y;
    float txz = tx * z;
    float tyz = ty * z;
    float sx = s * x;
    float sy = s * y;
    float sz = s * z;
    
    mat4 dst;
    
    dst[0][0] = c + tx*x;
    dst[1][0] = txy + sz;
    dst[2][0] = txz - sy;
    dst[3][0] = 0.0;
    
    dst[0][1] = txy - sz;
    dst[1][1] = c + ty*y;
    dst[2][1] = tyz + sx;
    dst[3][1] = 0.0;
    
    dst[0][2] = txz + sy;
    dst[1][2] = tyz - sx;
    dst[2][2] = c + tz*z;
    dst[3][2] = 0.0;
    
    dst[0][3] = 0.0;
    dst[1][3] = 0.0;
    dst[2][3] = 0.0;
    dst[3][3] = 1.0;
    
    return dst;
}

void main() {
    
    if(BillboardType >0.01){
        
        vec3 right;
        vec3 up;
        vec3 look;
        mat4 billboardMatrix;

        if (BillboardType <= 1.01){  //ParticleModel::BILLBOARD
            
            look = normalize(CameraPosision - position);
            up = normalize(CameraUp);
            right = normalize(cross(up, look));
            up = cross(look, right);
            
        }else if (BillboardType <= 2.01){  //ParticleModel::HORIZONTAL_BILLBOARD
            
            //方向修正系数，当粒子在camera上方时让粒子朝下。即look为upcamera的反向
            highp float direction_fix = 1.0;
            look = normalize(CameraPosision - position);
            if (imuType < 0.01){
                up = normalize(vec3(look.x,look.y,0.0));
                if(position.z > CameraPosision.z){
                    direction_fix = -1.0;
                }
            }else if (imuType < 1.01){
                up = normalize(vec3(look.x,0.0,look.z));
                if(position.y > CameraPosision.y){
                    direction_fix = -1.0;
                }
            }
            look = CameraUp * direction_fix;
            right = cross(up, look);
            
        }else if (BillboardType <= 3.01){  //ParticleModel::VERTICAL_BILLBOARD
            
            look = normalize(CameraPosision - position);
            if (imuType < 0.01){
                look = normalize(vec3(look.x,look.y,0.0));
            }else if (imuType < 1.01){
                look = normalize(vec3(look.x,0.0,look.z));
            }
            up = CameraUp;
            right = cross(up, look);
        }
        
        float alignToSpeed = velocity.w;
        //如果粒子速度过小就不支持沿速度方向旋转
        if (alignToSpeed > 0.999){
            //让粒子与速度方向对齐，本质是把billboard旋转到一个速度的投影向量
            vec3 vel_part = velocity.xyz;
            //乘以系数，与1表示速度同向，-1表示反向
            vel_part = vel_part * alignToSpeed;
            //获取速度在billboard平面的投影向量reflect_vector
            float height = dot(look, vel_part);
            vec3 reflect_vector = vel_part - look * height;
            
            //reflect_vector长度极小，表示速度与billboard垂直了，此时不进行修正（先计算length，如果length不为0再normalize）
            if (length(reflect_vector) > 0.1){
                reflect_vector = normalize(reflect_vector);
                vec3 right_rot = cross(reflect_vector, look);
                //进行一次微调
                up = reflect_vector;
                right = right_rot;
            }
        }
        
        billboardMatrix[0] = vec4(right,0.0);
        billboardMatrix[1] = vec4(up,0.0);
        billboardMatrix[2] = vec4(look,0.0);
        billboardMatrix[3] = vec4(position,1.0);
        
        if(alignToSpeed < 0.0001)  //与粒子沿速度方向旋转互斥
        {
            //粒子自转
            if(trans.w < -0.0001 || trans.w > 0.0001){    //trans.w 粒子自转角度
                mat4 rotateMatrix = createMatrixWithRotation(vec3(0.0,0.0,1.0),radians(trans.w));
                billboardMatrix = billboardMatrix * rotateMatrix;
            }
        }
        
        
        gl_Position = Proj * View * World * billboardMatrix * vec4(trans.xyz, 1.0);
    }
    else{
        gl_Position = Proj * View * World * vec4(position + trans.xyz, 1.0);
        
    }
    
    if (type > 0.5){
        gl_PointSize = trans.w;    //点粒子大小
    }
    
    texCoordOut = texcoord;
    colorOut = color;
    typeOut = type;
    
}
