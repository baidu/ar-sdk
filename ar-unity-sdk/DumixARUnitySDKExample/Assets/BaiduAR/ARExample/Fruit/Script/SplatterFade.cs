using UnityEngine;
using System.Collections;

/// <summary>
/// The SplatterFade Class handles the Background Splatters of the Ball.  We instantiate the splatter quads based on the direction
/// of the swipe that cut the ball.  All of the splatter quads have been aligned/oriented so that the face vec3.up and then we face
/// them using quaternion.lookrotation (in another script). This Class just handles their fade out, and destruction.  So this script
/// is already on the "splatter" prefab with a "timeBeforeFadeStarts" of 4... 
/// 
/// </summary>
namespace BaiduARInternal
{
    public class SplatterFade : MonoBehaviour
    {
        public Renderer splatterQuadRenderer;               //
        public float timeBeforeFadeStarts;                  //

        // Use this for initialization
        void OnEnable()
        {
            // our splatterQuadRenderer holds the reference to the renderer...
            splatterQuadRenderer = GetComponentInChildren<Renderer>();
           
            Color tempColor = splatterQuadRenderer.material.color;
            //then we create a float named "alpha" and give it tempColor's alpha (which was splatterQuadRenderers alpha)
            tempColor.a = 1;
            splatterQuadRenderer.material.color = tempColor;

            //we use the overloaded Unity Destroy() Method to Destroy this object in "timeBeforeFadeStarts" + 2f(giving extra time for the fade to finish).
            //Destroy(gameObject, timeBeforeFadeStarts + 2f);
            StartCoroutine(HideObejct(timeBeforeFadeStarts + 2f));
            //we start the coroutine to Fade, and pass it our "timeBeforeFadeStarts", 0f(the val the alpha should go to), and 1f(the amount of time it should
            //take to get there.
            StartCoroutine(Fade(timeBeforeFadeStarts, 0f, 1f));
        }

        IEnumerator HideObejct(float time)
        {
            
            float nowTime = Time.time;
            while(nowTime > Time.time - time) 
            {
                yield return 1;
            }
         
            FindObjectOfType<CollideManage>().HideEffect(gameObject);
        }


        /// <summary>
        /// Fade Method (One that is very similar to the one I have used probably 5 times in this project.. Should have made a hefty static extension method
        /// just passed it the necessary references and been done with it... It's a bit silly that I didn't... BUT to keep the classes separate and dealing
        /// with their respective tasks/objects... here they are duplicated!  **NOTE: in your own projects several of the UI components can use Unity's
        /// Graphic.CrossFadeAlpha function... there is also a Graphic.CrossFadeColor.
        /// </summary>
        /// <param name="initFadeDelay"></param>
        /// <param name="aValue"></param>
        /// <param name="aTime"></param>
        /// <returns>null when finished</returns>
        IEnumerator Fade(float initFadeDelay, float aValue, float aTime)
        {
            //the first thing we do is wait for the "timeBeforeFadeStarts" var we passed in
            yield return new WaitForSeconds(initFadeDelay);
            //the we create a new Color var named "tempColor" and we assign it the splatterQuadRenderer's material.color.
            Color tempColor = splatterQuadRenderer.material.color;
            //then we create a float named "alpha" and give it tempColor's alpha (which was splatterQuadRenderers alpha)
            float alpha = tempColor.a;
            //then we loop from 0 to 1 and the rate of Time.deltaTime divided by aTime(the time var we passed in (in our case 1f))
            for (float t = 0.0f; t < 1.0f; t += Time.deltaTime / aTime)
            {
                //each iteration of the loop we Lerp tempColor's alpha in between current "alpha" var, and the value we passed in ("aValue")that it should 
                //be changing to , by rate of t (our incremented loop value).
                tempColor.a = Mathf.Lerp(alpha, aValue, t);
                //then splatterQuadRenderer.material.color is assigned the new value of "tempColor"
                splatterQuadRenderer.material.color = tempColor;
                //yield return null after we are done
                yield return null;
            }
        }
    }
}
