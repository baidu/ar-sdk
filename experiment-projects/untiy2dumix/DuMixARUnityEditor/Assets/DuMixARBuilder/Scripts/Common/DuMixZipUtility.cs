using System;
using System.Collections.Generic;
using ICSharpCode.SharpZipLib.Zip;
using System.IO;


namespace DuMixARInternal
{

    public class DuMixZipUtility
    {

        private const int BufferSize = 4096;

        private static Dictionary<string, string> GetAllFileSystemEntities(string source, string topDirectory)
        {
            Dictionary<string, string> entitiesDictionary = new Dictionary<string, string>();
            entitiesDictionary.Add(source, source.Replace(topDirectory, ""));

            if (Directory.Exists(source))
            {
                //一次性获取下级所有目录，避免递归
                string[] directories = Directory.GetDirectories(source, "*.*", SearchOption.AllDirectories);
                foreach (string directory in directories)
                {
                    entitiesDictionary.Add(directory, directory.Replace(topDirectory, ""));
                }

                string[] files = Directory.GetFiles(source, "*.*", SearchOption.AllDirectories);
                foreach (string file in files)
                {
                    entitiesDictionary.Add(file, file.Replace(topDirectory, ""));
                }
            }

            return entitiesDictionary;
        }


        private static Dictionary<string, string> PrepareFileSystementities(IEnumerable<string> sourceFileEntityPathList)
        {
            Dictionary<string, string> fileEntityDictionary = new Dictionary<string, string>();//文件字典
            string parentDirectoryPath = "";
            foreach (string fileEntityPath in sourceFileEntityPathList)
            {
                string path = fileEntityPath;

                if (path.EndsWith(@"/"))
                {
                    path = path.Remove(path.LastIndexOf(@"/"));
                }

                parentDirectoryPath = Path.GetDirectoryName(path) + @"/";
                //获取目录中所有的文件系统对象
                Dictionary<string, string> subDictionary = GetAllFileSystemEntities(path, parentDirectoryPath);

                //将文件系统对象添加到总的文件字典中
                foreach (string key in subDictionary.Keys)
                {
                    //Debug.Log("DIC  key: " + key + " Value: " + subDictionary[key]);
                    if (!fileEntityDictionary.ContainsKey(key))//检测重复项
                    {
                        fileEntityDictionary.Add(key, subDictionary[key]);
                    }
                }
            }
            return fileEntityDictionary;
        }



        public static bool Zip(string path, string zipFilePath, Action onFinished)
        {

            bool result = false;
            string [] sourceList = new string[] { path };
            try
            {
                //检测目标文件所属的文件夹是否存在，如果不存在则建立
                string zipFileDirectory = Path.GetDirectoryName(zipFilePath);
                if (!Directory.Exists(zipFileDirectory))
                {
                    Directory.CreateDirectory(zipFileDirectory);
                }


                Dictionary<string, string> dictionaryList = PrepareFileSystementities(sourceList);

                using (ZipOutputStream zipStream = new ZipOutputStream(File.Create(zipFilePath)))
                {
                   // zipStream.Password = password;//设置密码
                   // zipStream.SetComment(comment);//添加注释
                    zipStream.SetLevel(0);//设置压缩等级

                    foreach (string key in dictionaryList.Keys)//从字典取文件添加到压缩文件
                    {
                        if (File.Exists(key))//判断是文件还是文件夹
                        {
                            bool isMetaFile = Path.GetFileNameWithoutExtension(key).Equals("meta");
                            if (isMetaFile)
                                break;
                            
                            FileInfo fileItem = new FileInfo(key);

                            using (FileStream readStream = fileItem.Open(FileMode.Open,
                                FileAccess.Read, FileShare.Read))
                            {
                                ZipEntry zipEntry = new ZipEntry(dictionaryList[key]);
                                zipEntry.DateTime = fileItem.LastWriteTime;
                                zipEntry.Size = readStream.Length;
                                zipStream.PutNextEntry(zipEntry);
                                int readLength = 0;
                                byte[] buffer = new byte[BufferSize];

                                do
                                {
                                    readLength = readStream.Read(buffer, 0, BufferSize);
                                    zipStream.Write(buffer, 0, readLength);
                                } while (readLength == BufferSize);

                                readStream.Close();
                                readStream.Dispose();
                            }
                        }
                        else//对文件夹的处理
                        {

                            ZipEntry zipEntry = new ZipEntry(dictionaryList[key] + "/");
                            zipStream.PutNextEntry(zipEntry);
                        }
                    }

                    zipStream.Flush();
                    zipStream.Finish();
                    zipStream.Close();
                    if(onFinished != null)
                    onFinished.Invoke();
                }

                result = true;
            }
            catch (System.Exception ex)
            {
                throw new Exception("Zip File failed", ex);
            }

            return result;

        }
    }
}
