using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace BaiduARInternal
{
    public class PaticleDestroy : MonoBehaviour
    {

        private ParticleSystem thisParticle;
        // Use this for initialization
        void OnEnable()
        {
            thisParticle = this.GetComponent<ParticleSystem>();
            if (!thisParticle.main.loop)
            {
                //Destroy(this.gameObject, 3);
               
            }
            StartCoroutine(HideObejct(3));
        }
        IEnumerator HideObejct(float time)
        {
            float nowTime = Time.time;
            while (nowTime > Time.time - time)
            {
                yield return 1;
            }
            FindObjectOfType<CollideManage>().HideEffect(gameObject);
        }

        // Update is called once per frame
        void Update()
        {

        }
    }
}
