using Microsoft.VisualBasic;
using SDKNETFrameWorkLib.GeneralLogic;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace SDKNETFrameworkTest
{
    public class CSRGeneratorOpenSSL
    {
        public void ExecuteCommandSync(object command)
        {
            try
            {
                // create the ProcessStartInfo using "cmd" as the program to be run,
                // and "/c " as the parameters.
                // Incidentally, /c tells cmd that we want it to execute the command that follows,
                // and then exit.
                System.Diagnostics.ProcessStartInfo procStartInfo =
                    new System.Diagnostics.ProcessStartInfo("cmd", "/c " + command);

                // The following commands are needed to redirect the standard output.
                // This means that it will be redirected to the Process.StandardOutput StreamReader.
                procStartInfo.RedirectStandardOutput = true;
                procStartInfo.UseShellExecute = false;
                // Do not create the black window.
                procStartInfo.CreateNoWindow = true;
                // Now we create a process, assign its ProcessStartInfo and start it
                System.Diagnostics.Process proc = new System.Diagnostics.Process();
                proc.StartInfo = procStartInfo;
                proc.Start();
                // Get the output into a string
                string result = proc.StandardOutput.ReadToEnd();
                // Display the command output.
                Console.WriteLine(result);
            }
            catch (Exception objException)
            {
                Console.WriteLine(objException.InnerException);
            }
        }
        public void GenerateCSRUsingOpenSSLComand(ref string errorMessage)
        {
            string path = System.Reflection.Assembly.GetExecutingAssembly().Location;
            var directory = System.IO.Path.GetDirectoryName(path);
            ExecuteCommandSync(@"openssl ecparam -name secp256k1 -genkey -noout -out " + directory + @"\generatedPrivateKey.pem");
            Thread.Sleep(1000);
            ExecuteCommandSync(@"openssl ec -in " + directory + @"\generatedPrivateKey.pem -pubout > " + directory + @"\generatedPublicKey.pem");
            Thread.Sleep(1000);
            ExecuteCommandSync(@"openssl req -new -sha256 -key " + directory + @"\generatedPrivateKey.pem -extensions v3_req  -config " + directory + @"\config.cnf -out " + directory + @"\generatedCSR.csr");
        }
    }
}
