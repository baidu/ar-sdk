using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
namespace BaiduARInternal
{
    public class ARHumanBodyDataParse
    {
        public static float lengthShoulder;  //以肩膀到大腿的距离来做距离运算
        #region 实时跟踪
        public static Vector3 GetElectricVet(Vector3 firstVet, Vector3 secVet)
        {
            float length = (float)Math.Sqrt(Math.Pow((secVet.y - firstVet.y), 2) + Math.Pow((secVet.x - firstVet.x), 2));
            float z = 40 * 200/length;

            Vector3 retVetInit = Vector2.zero;
            retVetInit.x = (firstVet.x + secVet.x) / 2;
            retVetInit.y = (firstVet.y + secVet.y) / 2;
            retVetInit.z = z;

            float xPer = retVetInit.x / Screen.width;
            float yPer = retVetInit.y / Screen.height;

            Vector3 retVet = Vector3.zero;

            retVet00 = Camera.main.ScreenToWorldPoint(new Vector3(Screen.width, Screen.height, z));
            retVet11 = Camera.main.ScreenToWorldPoint(new Vector3(0, 0, z));

            retVet.x = Mathf.Lerp(retVet11.x, retVet00.x, xPer);
            retVet.y = Mathf.Lerp(retVet11.y, retVet00.y, yPer);
            retVet.z = z;

            return retVet;
        }

        public static float GetAngleBetweenPos(Vector3 firstVet, Vector3 secVet)
        {
            float angle = (float)System.Math.Atan2((secVet.y - firstVet.y), (secVet.x - firstVet.x)); //弧度  0.6435011087932844
            float theta = (float)(angle * (180 / System.Math.PI)); //角度  36.86989764584402
            return theta;
        }

        #endregion

        #region 抬脚轨迹
        public static Queue<float>[] foots = new Queue<float>[2];
        public static int footsize = 4;

        //index = 0表示左脚   index = 1表示右脚
        public static bool FootLift(Vector3 firstVet,int index)
        { 
            if (foots[index].Count < footsize)
            {
                return false;
            }

            float firstFiveFrame = 0;
            float endFiveFrame = 0;
            float[] footArray = foots[index].ToArray();
          
            for (int i = 0; i < footArray.Length;i++)
            {
                if (i < footsize/2)
                {
                    endFiveFrame += footArray[i];
                }else
                {
                    firstFiveFrame += footArray[i];
                }
            }
            firstFiveFrame = firstFiveFrame*2 / footsize;
            endFiveFrame = endFiveFrame*2 /footsize;
      
            float adjust = lengthShoulder / 8;
            if(ARGlobalDefs.IsIosPlatform())
            {
                adjust = lengthShoulder / 12;
            }
            ARDebug.Log("LiftUp adjust == "+adjust );
            ARDebug.Log("LiftUp endFiveFrame == " + endFiveFrame);
            ARDebug.Log("dowaLiftUpfff firstFiveFrame == " + firstFiveFrame);
            ARDebug.Log("dowaLiftDown ffffirstVet.y == " + firstVet.y);
            if ((endFiveFrame - firstFiveFrame) > adjust)
            {
                ARDebug.Log("dowaddLiftUpfff datas footLift Dwon i = "+index);
                return true;
            }
            return false;
        }
        //public static Queue<float>[] footDowns = new Queue<float>[2];
        public static bool FootDown(Vector3 firstVet,int index,Vector3 secondVet)
        {
 
            if (foots[index].Count < footsize)
            {
                return false;
            }

            float firstFiveFrame = 0;
            float endFiveFrame = 0;
            float[] footArray = foots[index].ToArray();

            for (int i = 0; i < footArray.Length; i++)
            {
                if (i < footsize/2)
                {
                    endFiveFrame += footArray[i];
                }
                else
                {
                    firstFiveFrame += footArray[i];
                }
            }

            firstFiveFrame = firstFiveFrame*2 / footsize;
            endFiveFrame = endFiveFrame*2 / footsize;
         
            float adjust = lengthShoulder / 12;
            if (ARGlobalDefs.IsIosPlatform())
            {
                adjust = lengthShoulder / 18;
            }
            ARDebug.Log("LiftDown adjust == " + adjust);
            ARDebug.Log("LiftDown endFiveFrame == " + endFiveFrame);
            ARDebug.Log("LiftDown firstFiveFrame == " + firstFiveFrame);
            ARDebug.Log("dowaLiftDown ffffirstVet.y == " + firstVet.y);
            float AdjustHeight = adjust * 2;
            if (ARGlobalDefs.IsIosPlatform())
            {
                AdjustHeight = adjust * 3;
            }
            if ((endFiveFrame - firstFiveFrame ) > adjust && Math.Abs(firstVet.y -secondVet.y) < AdjustHeight)
            {
                ARDebug.Log("dowaddLiftDownfff datas footDown Dwon i = " + index);
                return true;
            }
            return false;
        }
   
        private static Vector3 retVet00 = Vector3.zero;
        private static Vector3 retVet11 = Vector3.zero;

        public static Vector3 GetGroundVet(Vector3 firstVet,int xAdjust,int yAdjust,float z = 10)
        {
            Vector3 retVetInit = Vector2.zero;
            retVetInit.x = firstVet.x+xAdjust;
            retVetInit.y = firstVet.y+yAdjust;
            retVetInit.z = z;

            float xPer = retVetInit.x / Screen.width;
            float yPer = retVetInit.y / Screen.height;

            Vector3 retVet = Vector3.zero;

            retVet00 = Camera.main.ScreenToWorldPoint(new Vector3(Screen.width, Screen.height, z));
            retVet11 = Camera.main.ScreenToWorldPoint(new Vector3(0, 0, z));
          
            retVet.x = Mathf.Lerp(retVet11.x, retVet00.x, xPer);
            retVet.y = Mathf.Lerp(retVet11.y, retVet00.y, yPer);
            retVet.z = z;

            return retVet;
        }

        #endregion

        #region  静态动作
       

        /// <summary>
        /// 手下垂的动作
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool StaticPose(Vector3 Wrist, Vector3 elbow, Vector3 shoulder,Vector3 hip)
        {
            //int xAdjust = (int)lengthShoulder/5;
            //int yAdjust = (int)lengthShoulder/4;
            //if (Math.Abs(shoulder.x - Wrist.x) > xAdjust || Math.Abs(shoulder.x - elbow.x) > xAdjust)
            //{
            //    return false;
            //}
            //if (Math.Abs(shoulder.y - elbow.y) < yAdjust ||Math.Abs(elbow.y - Wrist.y) < yAdjust )
            //{
            //    return false;
            //}
            //if (shoulder.y >elbow.y &&elbow.y > Wrist.y)
            //{
            //    return true;
            //}
            //return false;
            int yAdjust = (int)lengthShoulder / 6;
            if (Math.Abs(Wrist.y - hip.y) < yAdjust)
            {
                return true;
            }
            return false;

        }

        /// <summary>
        /// 检测左拳卧于腰间
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistInWaistLeft(Vector3 Wrist, Vector3 elbow,Vector3 shoulder,Vector3 lHip)
        {
            float lLength = shoulder.y - lHip.y;
            if ((Wrist.y - lHip.y) >lLength/6 && (Wrist.y - lHip.y) < lLength / 2)
            {
                if (Wrist.y < elbow.y)
                {
                    if ((Wrist.x - elbow.x) < lLength / 3 && (Wrist.x - elbow.x) > -lLength / 3)
                    {
                        //Debug.Log("fistRInit");
                        return true;
                    }
                }
            }
            return false;
        }
        /// <summary>
        /// 检测右拳卧于腰间
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistInWaistRight(Vector3 Wrist, Vector3 elbow, Vector3 shoulder,Vector3 RHip)
        {
            float lLength = shoulder.y - RHip.y;
            if ((Wrist.y - RHip.y) > lLength / 6 && (Wrist.y - RHip.y) < lLength / 2)
            {
                if (Wrist.y < elbow.y)
                {
                    if ((Wrist.x - elbow.x) < lLength / 3 && (Wrist.x - elbow.x) > -lLength / 3)
                    {
                        //Debug.Log("fistLInit");
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// 检测双掌合十
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistTogether(Vector3 lWrist, Vector3 rWrist)
        {
           
            int xAdjust = (int)((lengthShoulder/2) );
            int yAdjust = (int)((lengthShoulder / 4));
            if (Math.Abs(lWrist.y - rWrist.y) < yAdjust)
            {
                ARDebug.Log("fistInchayao front no Checking");
                if (Math.Abs(lWrist.x - rWrist.x) < xAdjust)
                {
                    ARDebug.Log("fistInchayao front no Check");
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 检测双掌在胸前左手
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistFrontChestLeft(Vector3 Wrist, Vector3 elbow, Vector3 shoulder,Vector3 lHip)
        {
            bool ret = false;

            int yAdjust = (int)(lengthShoulder / 18);

            float xDis = shoulder.x - elbow.x;
            if (ARGlobalDefs.IsIosPlatform())
            {
                if (ARScreen.Instance.IsFrontCamera)
                {
                    xDis = -xDis;
                }
            }
            //shoulder和Elbow不在一条直线上
            if (xDis < yAdjust)
            {
                ARDebug.Log("lashen  error");
                return false;
            }
            //shoulder和elbow不在一起
            if (Math.Abs(shoulder.y - Wrist.y) < yAdjust/2)
            {
                ARDebug.Log("lashen chayao front no Check");
                return false;
            }
           
            float lLength = shoulder.y - lHip.y;
            if ((Wrist.y - lHip.y) < lLength / 1.7)
            {
                ARDebug.Log("Mydatasl Wrist 太低");
                return false;
            }
          
            if (fistFrontToLeft(Wrist, elbow, shoulder,lHip))
            {
                ARDebug.Log("lashenqqq Wrist 太高");
                return false;
            }
            float angle = GetAngle(Wrist, elbow, shoulder);
           
            if (angle < 180)
            {
                return true;
            }

            return ret;
        }
        /// <summary>
        /// 检测双掌在胸前左手
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistFrontChestRight(Vector3 Wrist, Vector3 elbow, Vector3 shoulder, Vector3 lHip)
        {
            bool ret = false;

            int yAdjust = (int)(lengthShoulder / 18);
            float xDis = elbow.x - shoulder.x;
            if (ARGlobalDefs.IsIosPlatform())
            {
                if (ARScreen.Instance.IsFrontCamera)
                {
					xDis = -xDis;
                }
            }
            if (xDis < yAdjust)
            {
                ARDebug.Log(" xDis = "+xDis);
                ARDebug.Log("lashenl error");
                return false;
            }
           
            if (Math.Abs(shoulder.y - Wrist.y) < yAdjust/2)
            {
                ARDebug.Log("lashenl chayao front no Check");
                return false;
            }
         
            float lLength = shoulder.y - lHip.y;
            if ((Wrist.y - lHip.y) < lLength / 1.7)
            {
                ARDebug.Log("Mydatasl Wrist 太低");
                return false;
            }
          
            if(fistFrontToRight(Wrist,  elbow,  shoulder,lHip))
            {
                ARDebug.Log("lashenlqqq Wrist 太高");
                return false;
            }
            float angle = GetAngle(Wrist, elbow, shoulder);

            if (angle < 180)
            {
                return true;
            }

            return ret;
        }

        public static bool LeftHandToExtern(Vector3 Wrist, Vector3 elbow, Vector3 shoulder)
        {
            if (Wrist.y < elbow.y && elbow.y < shoulder.y)
            {
                if (ARGlobalDefs.IsAndroidPlatform())
                {
                    if (Wrist.x < elbow.x && elbow.x < shoulder.x)
                    {
                        return true;
                    }
                }else
                {
                    if (Wrist.x > elbow.x && elbow.x > shoulder.x)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        public static bool RightHandToExtern(Vector3 Wrist, Vector3 elbow, Vector3 shoulder)
        {
            if (Wrist.y < elbow.y && elbow.y < shoulder.y)
            {
                if (ARGlobalDefs.IsAndroidPlatform())
                {
					if (Wrist.x > elbow.x && elbow.x > shoulder.x)
					{
						return true;
					}
                }else
                {
                    if (Wrist.x < elbow.x && elbow.x < shoulder.x)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        /// <summary>
        /// 双掌向前推，左手
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistFrontToLeft(Vector3 Wrist, Vector3 elbow, Vector3 shoulder,Vector3 lHip)
        {
            int yAdjust = (int)(lengthShoulder / 2);
            if ((shoulder.y - elbow.y) > yAdjust)
            {
                ARDebug.Log("RistL is too back");
                return false;
            }

           //判断左手向外插
            if (LeftHandToExtern(Wrist,  elbow,  shoulder))
            {
                return false;
            }
            float lLength = shoulder.y - lHip.y;
            if ((Wrist.y - lHip.y) < lLength / 2)
            {
                ARDebug.Log("Mydatasl Wrist 太低");
                return false;
            }
            if ((elbow.y - lHip.y) < lLength / 1.7)
            {
                ARDebug.Log("Mydatasl elbow 太低");
                return false;
            }
            int disAdjust = (int)(lengthShoulder/2);
         
            //肩膀和肘的距离比较近
            float distance = (float)Math.Sqrt(Math.Pow((shoulder.y - elbow.y), 2) + Math.Pow((shoulder.x - elbow.x), 2));
            float dist = (float)Math.Sqrt(Math.Pow((Wrist.y - elbow.y), 2) + Math.Pow((Wrist.x - elbow.x), 2));
            float alldistance = distance + dist;
            ARDebug.Log("alldistance = " + alldistance);
            ARDebug.Log("alldistance disAdjust = " + disAdjust);

            if (alldistance < disAdjust)
            {
                return true;
            }

            if (Wrist.y > shoulder.y && (alldistance < (100+disAdjust) ))
            {
                return true;
            }

            //下推掌
            int xAdjust = (int)(lengthShoulder/15);
            if (Math.Abs(elbow.x - shoulder.x) < xAdjust && (alldistance < (200 + disAdjust)))
            {
                ARDebug.Log("lashenl error");
                return true;
            }

            return false;
        }
       
        /// <summary>
        /// 双掌向前推，右手
        /// </summary>
        /// <returns><c>true</c>, if in waist was fisted, <c>false</c> otherwise.</returns>
        public static bool fistFrontToRight(Vector3 Wrist, Vector3 elbow, Vector3 shoulder, Vector3 lHip)
        {
            int yAdjust = (int)(lengthShoulder / 2);
            if ((shoulder.y - elbow.y) > yAdjust)
            {
                ARDebug.Log("RistR is too back");
                return false;
            }
            //判断左手向外插
            if (RightHandToExtern(Wrist, elbow, shoulder))
            {
                return false;
            }
            float lLength = shoulder.y - lHip.y;
            if ((Wrist.y - lHip.y) < lLength / 2)
            {
                ARDebug.Log("Mydatasl Wrist 太低");
                return false;
            }
            if ((elbow.y - lHip.y) < lLength / 1.7)
            {
                ARDebug.Log("Mydatasl elbow 太低");
                return false;
            }
            int disAdjust =  (int)(lengthShoulder / 2);
            //肩膀和肘的距离比较近
            float distance = (float)Math.Sqrt(Math.Pow((shoulder.y - elbow.y), 2) + Math.Pow((shoulder.x - elbow.x), 2));
            float dist = (float)Math.Sqrt(Math.Pow((Wrist.y - elbow.y), 2) + Math.Pow((Wrist.x - elbow.x), 2));
            ARDebug.Log("chayao dis2 = " + dist);
            float alldistance = distance + dist;
            ARDebug.Log("alldistance = " + alldistance);
            ARDebug.Log("alldistance disAdjust = " + disAdjust);
          
            if (alldistance < disAdjust)
            {
                return true;
            }
            if (Wrist.y > shoulder.y && (alldistance < (100 + disAdjust)))
            {
                return true;
            }

            //下推掌
            int xAdjust = (int)(lengthShoulder/15);
            if (Math.Abs(elbow.x - shoulder.x) < xAdjust && (alldistance < (200 + disAdjust)))
            {
                ARDebug.Log("lashenl error");
                return true;
            }
            return false;
        }
        //手在里面
        public static bool FistIntenal(Vector3 first, Vector3 end)
        {
            float xAdjust = lengthShoulder / 4 ;
            if ((first.x - end.x)>xAdjust)
            {
                return true;
            }
            return false;
        }


        public static float GetAngle(Vector3 firstVet, Vector3 centerVet, Vector3 endVet)
        {
            Vector3 fromVet = firstVet - centerVet;
            Vector3 toVet = endVet - centerVet;
            float angle = Vector3.Angle(fromVet, toVet);
            ARDebug.LogWarning("angles = " + angle);
            return angle;

        }

        #endregion
    }
}
