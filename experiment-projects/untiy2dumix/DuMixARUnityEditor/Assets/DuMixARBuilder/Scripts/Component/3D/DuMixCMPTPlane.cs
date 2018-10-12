using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DuMixARInternal
{
    public class DuMixCMPTPlane : DuMixCMPT3DObject
    {

        public override DuMixNode ToDuMixNode(DuMixNodeConvertor convertor)
        {
            var duMixNode = convertor.Convert3DPlane(this);
            foreach (Transform child in this.gameObject.transform)
            {
                var node = child.gameObject.GetComponent<DuMixCMPT3DObject>();
                if (node != null)
                {
                    var childDuMixNode = node.ToDuMixNode(convertor);
                    duMixNode.children.Add(childDuMixNode);
                }
            }
            return duMixNode;
        }

        public override void UpdateDuMixTransform()
        {
            var position = CoordinateUtil.Convert3DPosition(this.gameObject.transform.localPosition);
            var rotation = CoordinateUtil.Convert3DEuler(this.gameObject.transform.localEulerAngles);
            var scale = this.gameObject.transform.localScale * 10;

            transformData.position = string.Format("{0},{1},{2}", position.x, position.y, position.z);
            transformData.rotation = string.Format("{0},{1},{2}", rotation.x, rotation.y, rotation.z);
            transformData.scale = string.Format("{0},{1},{2}", scale.x, scale.y, scale.z);
        }
    }
}
