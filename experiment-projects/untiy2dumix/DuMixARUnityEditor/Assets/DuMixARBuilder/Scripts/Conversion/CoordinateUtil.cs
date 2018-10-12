using UnityEngine;
using System.Collections;

namespace DuMixARInternal
{
    /**
     * 集中处理因Unity坐标系与DuMix坐标系不同所需的转换操作
     * DuMix坐标系为右手系，欧拉角应用顺序为 X Y Z
     */
    public class CoordinateUtil
    {

        /**
         * Unity ==> DuMix 坐标系对应关系为 X ==> -X, Y ==> Y, Z ==> Z
         */
        public static Vector3 Convert3DPosition(Vector3 position)
        {
            return new Vector3(-position.x, position.y, position.z);
        }


        /**
         * Unity坐标系下，欧拉角应用顺序为 Z X Y, 右手坐标系下 矩阵计算方式为 my * mx * mz
         * DuMix坐标系下，欧拉角应用顺序为 X Y Z, 左手坐标系下 矩阵计算方式为 mx * my * mz
         **/
        public static Vector3 Convert3DEuler(Vector3 eulerAngles)
        {
            var qx = Quaternion.Euler(eulerAngles.x, 0, 0);
            var qy = Quaternion.Euler(0, -eulerAngles.y, 0);
            var qz = Quaternion.Euler(0, 0, -eulerAngles.z);

            var mx = Matrix4x4.Rotate(qx);
            var my = Matrix4x4.Rotate(qy);
            var mz = Matrix4x4.Rotate(qz);
            var rotMat = my * mx * mz;

            var R11 = rotMat[0, 0];
            var R12 = rotMat[0, 1];
            var R13 = rotMat[0, 2];
            var R21 = rotMat[1, 0];
            var R22 = rotMat[1, 1];
            var R23 = rotMat[1, 2];
            var R31 = rotMat[2, 0];
            var R32 = rotMat[2, 1];
            var R33 = rotMat[2, 2];

            float eX, eY, eZ;
            if (R13 >= -1.02 && R13 <= -0.98)
            {
                Debug.Log("R13 == -1");
                eZ = 0;
                eY = -Mathf.PI / 2;
                eX = -Mathf.Atan2(R21, R31);
            }
            else if (R13 >= 0.98 && R13 <= 1.02)
            {
                Debug.Log("R13 == 1");
                eZ = 0;
                eY = Mathf.PI / 2;
                eX = -Mathf.Atan2(R21, R31);
            }
            else
            {
                eY = Mathf.Asin(R13);
                var cosy = Mathf.Cos(eY);
                eX = -Mathf.Atan2(R23 / cosy, R33 / cosy);
                eZ = -Mathf.Atan2(R12 / cosy, R11 / cosy);
            }

            return new Vector3(eX / Mathf.PI * 180, eY / Mathf.PI * 180, eZ / Mathf.PI * 180);
        }

        public static Vector2 ConvertUIPosition(Vector3 position, Vector2 canvasSize) {
            var marginLeft = (position.x + canvasSize.x/2) / canvasSize.x;
            var marginTop = 1 - (position.y + canvasSize.y/2) / canvasSize.y;
            return new Vector2(marginLeft, marginTop);
            
        }

        public static Vector2 ConvertUIScale(Vector3 scale, Vector2 canvasSize) {
            var rWidth = scale.x / canvasSize.x;
            var rHeight = scale.y / canvasSize.y;
            return new Vector2(rWidth, rHeight);
        }

    }
}