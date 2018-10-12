using System;
using UnityEngine;

namespace DuMixARInternal
{
    public class DuMixGlobalStringDefs
	{

        public static string CasePath() {
            string path = Application.dataPath + "/DuMixARCase/";
            return path;
        }

        public static string SourcePath()
        {
            string path = Application.dataPath + "/DuMixARBuilder/";
            return path;
        }

		public static string TemplatePath()
		{
            string path = CasePath() + "Templates/";
			return path;
		}

		public static string ResourcePath()
		{
            string path = CasePath() + "Resource/";
			return path;
		}

        public static string ToolPath() {
            string path = SourcePath() + "Plugins/";
            return path;
        }

        public static string LuaFilePath() {
            string path = SourcePath() + "LuaFiles/";
            return path;
        }

        public static string BuildPath() {
            string path = CasePath() + "Build/";
            return path;
        }

        public static string CachePath() {
            string path = SourcePath() + "Cache/";
            return path;
        }
	}
}

