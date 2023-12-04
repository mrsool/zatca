using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SDKNETFrameWorkLib;
using SDKNETFrameWorkLib.GeneralLogic;
namespace SDKNETFrameworkTest
{
    class Program
    {
        static int selectedOption = 0;
        static void Main(string[] args)
        {
            var _IHashingValidator = new SDKNETFrameWorkLib.BLL.HashingValidator();
            var _IQRValidator = new SDKNETFrameWorkLib.BLL.QRValidator();
            var _IEInvoiceValidator = new SDKNETFrameWorkLib.BLL.EInvoiceValidator();
            var _IEInvoiceSigningLogic = new SDKNETFrameWorkLib.BLL.EInvoiceSigningLogic();


            string privateKeyContent = "MHQCAQEEIDyLDaWIn/1/g3PGLrwupV4nTiiLKM59UEqUch1vDfhpoAcGBSuBBAAKoUQDQgAEYYMMoOaFYAhMO/steotfZyavr6p11SSlwsK9azmsLY7b1b+FLhqMArhB2dqHKboxqKNfvkKDePhpqjui5hcn0Q==";//
            string certificateContent = "MIID6jCCA5CgAwIBAgITbwAAfsboAdNVNKd+1wABAAB+xjAKBggqhkjOPQQDAjBjMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNnb3YxFzAVBgoJkiaJk/IsZAEZFgdleHRnYXp0MRwwGgYDVQQDExNUU1pFSU5WT0lDRS1TdWJDQS0xMB4XDTIyMDgxNjE0MjU0OFoXDTI0MDgxNTE0MjU0OFowTjELMAkGA1UEBhMCU0ExEzARBgNVBAoTCjMxMDIzMzM3NDYxDDAKBgNVBAsTA1RTVDEcMBoGA1UEAxMTVFNULTMxMDIzMzM3NDYwMDAwMzBWMBAGByqGSM49AgEGBSuBBAAKA0IABGGDDKDmhWAITDv7LXqLX2cmr6+qddUkpcLCvWs5rC2O29W/hS4ajAK4Qdnahym6MaijX75Cg3j4aao7ouYXJ9GjggI5MIICNTCBmgYDVR0RBIGSMIGPpIGMMIGJMTswOQYDVQQEDDIxLVRTVHwyLVRTVHwzLTBiZTk2ZTI3LWI5MTgtNDliYy05N2RiLTMzOWY1OWMyMzA0ZDEfMB0GCgmSJomT8ixkAQEMDzMxMDIzMzM3NDYwMDAwMzENMAsGA1UEDAwEMTEwMDEMMAoGA1UEGgwDVFNUMQwwCgYDVQQPDANUU1QwHQYDVR0OBBYEFDuWYlOzWpFN3no1WtyNktQdrA8JMB8GA1UdIwQYMBaAFHZgjPsGoKxnVzWdz5qspyuZNbUvME4GA1UdHwRHMEUwQ6BBoD+GPWh0dHA6Ly90c3RjcmwuemF0Y2EuZ292LnNhL0NlcnRFbnJvbGwvVFNaRUlOVk9JQ0UtU3ViQ0EtMS5jcmwwga0GCCsGAQUFBwEBBIGgMIGdMG4GCCsGAQUFBzABhmJodHRwOi8vdHN0Y3JsLnphdGNhLmdvdi5zYS9DZXJ0RW5yb2xsL1RTWkVpbnZvaWNlU0NBMS5leHRnYXp0Lmdvdi5sb2NhbF9UU1pFSU5WT0lDRS1TdWJDQS0xKDEpLmNydDArBggrBgEFBQcwAYYfaHR0cDovL3RzdGNybC56YXRjYS5nb3Yuc2Evb2NzcDAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMCcGCSsGAQQBgjcVCgQaMBgwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwMwCgYIKoZIzj0EAwIDSAAwRQIhAMWDOI67/kAqLSDMGeUDUettoh+1dRGNHppri9d7y02vAiAtfnOLHuJBlO8QqNxXOdeQZphNYai0DDzQXmESb+6FZA==";
            //string privateKeyContent = "MIGNAgEAMBAGByqGSM49AgEGBSuBBAAKBHYwdAIBAQQgBC/V+e1bYCyQ2RjgkC0VnhGOEn9aYMlUNC+x/Bxqh1ugBwYFK4EEAAqhRANCAASxorBRZSPU9SBYmsWY1ORtSLCEskbVJQuvKp2EThxqnyrZ4d48VAAKIh706QUzUkb/KsGE58vA9AeNVEE/Vn1X";
            //string certificateContent = "TUlJRUxqQ0NBOVNnQXdJQkFnSVRGd0FBQUtCeHozbERXb2dXTlFBQkFBQUFvREFLQmdncWhrak9QUVFEQWpCaU1SVXdFd1lLQ1pJbWlaUHlMR1FCR1JZRmJHOWpZV3d4RXpBUkJnb0praWFKay9Jc1pBRVpGZ05uYjNZeEZ6QVZCZ29Ka2lhSmsvSXNaQUVaRmdkbGVIUm5ZWHAwTVJzd0dRWURWUVFERXhKUVVscEZTVTVXVDBsRFJWTkRRVEV0UTBFd0hoY05Nakl3T0RNd01EZ3hOREl3V2hjTk1qY3dPREk1TURneE5ESXdXakJTTVFzd0NRWURWUVFHRXdKVFFURVdNQlFHQTFVRUNoTU5RMmxuWVd4aGFDQkhjbTkxY0RFV01CUUdBMVVFQ3hNTlNtVmtaR0ZvSUVKeVlXNWphREVUTUJFR0ExVUVBeE1LTVRNd0xqRXVNVEF1TkRCV01CQUdCeXFHU000OUFnRUdCU3VCQkFBS0EwSUFCTEdpc0ZGbEk5VDFJRmlheFpqVTVHMUlzSVN5UnRVbEM2OHFuWVJPSEdxZkt0bmgzanhVQUFvaUh2VHBCVE5TUnY4cXdZVG55OEQwQjQxVVFUOVdmVmVqZ2dKNk1JSUNkakNCb2dZRFZSMFJCSUdhTUlHWHBJR1VNSUdSTVM0d0xBWURWUVFFRENVeExVaDFZWGRsYVh3eUxVVTVNREF3ZkRNdE1qRXdNak13TVRBeU9ERXdUVE13TURJNE1SOHdIUVlLQ1pJbWlaUHlMR1FCQVF3UE16QXdNVFV5TnpneE16QXdNREF6TVEwd0N3WURWUVFNREFReE1UQXdNUmN3RlFZRFZRUWFEQTVCYzJnZ1UyaGhjbUZtYVhsaGFERVdNQlFHQTFVRUR3d05VR2hoY20xaElITmxZM1J2Y2pBZEJnTlZIUTRFRmdRVWdQSXMyT00zbzdROWdmMkUvcVhYWVBra3d5VXdId1lEVlIwakJCZ3dGb0FVY3BQUkRtdjZKRnNUaGVyQkZmTzRGZnNiQlkwd1RnWURWUjBmQkVjd1JUQkRvRUdnUDRZOWFIUjBjRG92TDJOeWJERXVlbUYwWTJFdVoyOTJMbk5oTDBObGNuUkZibkp2Ykd3dlVGSmFSVWxPVms5SlEwVlRRMEV4TFVOQktERXBMbU55YkRDQnFBWUlLd1lCQlFVSEFRRUVnWnN3Z1pnd2F3WUlLd1lCQlFVSE1BS0dYMmgwZEhBNkx5OWhhV0V4TG5waGRHTmhMbWR2ZGk1ellTOURaWEowUlc1eWIyeHNMMUJTV2tWcGJuWnZhV05sVTBOQk1TNWxlSFJuWVhwMExtZHZkaTVzYjJOaGJGOVFVbHBGU1U1V1QwbERSVk5EUVRFdFEwRW9NU2t1WTNKME1Da0dDQ3NHQVFVRkJ6QUJoaDFvZEhSd09pOHZZM0pzTVM1NllYUmpZUzVuYjNZdWMyRXZiMk56Y0RBT0JnTlZIUThCQWY4RUJBTUNCNEF3UEFZSkt3WUJCQUdDTnhVSEJDOHdMUVlsS3dZQkJBR0NOeFVJZ1lhb0hZVFEreEtHN1owa2g4NzdHZFBBVldhSCtxVmxoZG1FUGdJQlpBSUJEakFkQmdOVkhTVUVGakFVQmdnckJnRUZCUWNEQXdZSUt3WUJCUVVIQXdJd0p3WUpLd1lCQkFHQ054VUtCQm93R0RBS0JnZ3JCZ0VGQlFjREF6QUtCZ2dyQmdFRkJRY0RBakFLQmdncWhrak9QUVFEQWdOSUFEQkZBaUVBaGdnQTA5aUtzYXB6N0RCSW13RGNrazJMbGpnZHIyZlZsdEIwOTBlbk1GOENJQlRYdnZubEFTNEF5czJkcm5CemlLTWN0Q1RzN3k2U1JNZW5zWmFLM3J6Rg==";
            string pihContent = "NWZlY2ViNjZmZmM4NmYzOGQ5NTI3ODZjNmQ2OTZjNzljMmRiYzIzOWRkNGU5MWI0NjcyOWQ3M2EyN2ZiNTdlOQ==";
            //=============================================================
            Console.WriteLine("********** Welcome to ZATCA E-Invoice .NET SDK 1.0.0 **********");
            Console.WriteLine("Sample for private key : ");
            Console.WriteLine("MHQCAQEEIDyLDaWIn/1/g3PGLrwupV4nTiiLKM59UEqUch1vDfhpoAcGBSuBBAAKoUQDQgAEYYMMoOaFYAhMO/steotfZyavr6p11SSlwsK9azmsLY7b1b+FLhqMArhB2dqHKboxqKNfvkKDePhpqjui5hcn0Q==");
            Console.WriteLine("---------------------------------------------------------------------");
            Console.WriteLine("Sample for certificate : ");
            Console.WriteLine("MIID6jCCA5CgAwIBAgITbwAAfsboAdNVNKd+1wABAAB+xjAKBggqhkjOPQQDAjBjMRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxEzARBgoJkiaJk/IsZAEZFgNnb3YxFzAVBgoJkiaJk/IsZAEZFgdleHRnYXp0MRwwGgYDVQQDExNUU1pFSU5WT0lDRS1TdWJDQS0xMB4XDTIyMDgxNjE0MjU0OFoXDTI0MDgxNTE0MjU0OFowTjELMAkGA1UEBhMCU0ExEzARBgNVBAoTCjMxMDIzMzM3NDYxDDAKBgNVBAsTA1RTVDEcMBoGA1UEAxMTVFNULTMxMDIzMzM3NDYwMDAwMzBWMBAGByqGSM49AgEGBSuBBAAKA0IABGGDDKDmhWAITDv7LXqLX2cmr6+qddUkpcLCvWs5rC2O29W/hS4ajAK4Qdnahym6MaijX75Cg3j4aao7ouYXJ9GjggI5MIICNTCBmgYDVR0RBIGSMIGPpIGMMIGJMTswOQYDVQQEDDIxLVRTVHwyLVRTVHwzLTBiZTk2ZTI3LWI5MTgtNDliYy05N2RiLTMzOWY1OWMyMzA0ZDEfMB0GCgmSJomT8ixkAQEMDzMxMDIzMzM3NDYwMDAwMzENMAsGA1UEDAwEMTEwMDEMMAoGA1UEGgwDVFNUMQwwCgYDVQQPDANUU1QwHQYDVR0OBBYEFDuWYlOzWpFN3no1WtyNktQdrA8JMB8GA1UdIwQYMBaAFHZgjPsGoKxnVzWdz5qspyuZNbUvME4GA1UdHwRHMEUwQ6BBoD+GPWh0dHA6Ly90c3RjcmwuemF0Y2EuZ292LnNhL0NlcnRFbnJvbGwvVFNaRUlOVk9JQ0UtU3ViQ0EtMS5jcmwwga0GCCsGAQUFBwEBBIGgMIGdMG4GCCsGAQUFBzABhmJodHRwOi8vdHN0Y3JsLnphdGNhLmdvdi5zYS9DZXJ0RW5yb2xsL1RTWkVpbnZvaWNlU0NBMS5leHRnYXp0Lmdvdi5sb2NhbF9UU1pFSU5WT0lDRS1TdWJDQS0xKDEpLmNydDArBggrBgEFBQcwAYYfaHR0cDovL3RzdGNybC56YXRjYS5nb3Yuc2Evb2NzcDAOBgNVHQ8BAf8EBAMCB4AwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMCcGCSsGAQQBgjcVCgQaMBgwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwMwCgYIKoZIzj0EAwIDSAAwRQIhAMWDOI67/kAqLSDMGeUDUettoh+1dRGNHppri9d7y02vAiAtfnOLHuJBlO8QqNxXOdeQZphNYai0DDzQXmESb+6FZA==");
            Console.WriteLine("---------------------------------------------------------------------");
            Console.WriteLine("Please write the number of the option you want : ");
            Console.WriteLine("1- Generating E-Invoice Hashing (Need E-Invoice XML file path)");
            Console.WriteLine("2- Validating E-Invoice Hashing  (Need E-Invoice XML file path)");
            Console.WriteLine("3- Generating E-Invoice QR Code  (Need E-Invoice XML file path)");
            Console.WriteLine("4- Validating E-Invoice QR Code  (Need E-Invoice XML file path)");
            Console.WriteLine("5- Validating E-Invoice  (Need E-Invoice XML file path)");
            Console.WriteLine("6- Signing E-Invoice ");
            Console.WriteLine("7- Generate CSR ");
            Console.WriteLine("8- Exit Application");
            while (true)
            {
                try
                {
                    privateKeyContent = File.ReadAllText("privateKey.txt");
                }
                catch(Exception ex)
                {
                    Console.WriteLine("In setup location a file privateKey.txt should be exist");
                    return;
                }
                try
                {
                    certificateContent = File.ReadAllText("certificate.txt");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("In setup location a file certificate.txt should be exist");
                    return;
                }
                try
                {
                    pihContent = File.ReadAllText("pih.txt");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("In setup location a file pih.txt should be exist");
                    return;
                }
                Console.Write(" Please Enter you choice :  ");
                string option = Console.ReadLine();
                if (!string.IsNullOrEmpty(option) && int.TryParse(option.Trim(), out selectedOption) && selectedOption >= 1 && selectedOption <= 7)
                {
                    string filePath = "";
                    if (selectedOption < 7)
                    {
                        Console.Write(" Please Enter XML file path :  ");
                        filePath = Console.ReadLine();
                        if (string.IsNullOrEmpty(filePath))
                        {
                            continue;
                        }
                    }
                    Result objResult = new Result();
                    if (selectedOption == 1)
                    {
                        objResult = _IHashingValidator.GenerateEInvoiceHashing(filePath);
                    }
                    else if (selectedOption == 2)
                    {
                        objResult = _IHashingValidator.ValidateEInvoiceHashing(filePath);
                    }
                    else if (selectedOption == 3)
                    {
                        objResult = _IQRValidator.GenerateEInvoiceQRCode(filePath);
                    }
                    else if (selectedOption == 4)
                    {
                        objResult = _IQRValidator.ValidateEInvoiceQRCode(filePath);
                    }
                    else if (selectedOption == 5)
                    {
                        objResult = _IEInvoiceValidator.ValidateEInvoice(filePath, certificateContent, pihContent);
                    }
                    else if (selectedOption == 6)
                    {
                        objResult = _IEInvoiceSigningLogic.SignDocument(filePath, certificateContent, privateKeyContent);
                    }
                    else if (selectedOption == 7)
                    {
                        string errorMessage = "";
                        CSRGeneratorOpenSSL cSRGeneratorOpenSSL = new CSRGeneratorOpenSSL();
                        cSRGeneratorOpenSSL.GenerateCSRUsingOpenSSLComand(ref errorMessage);
                        Console.WriteLine("CSR Generating Operation has been Finished.");
                    }
                    if (selectedOption != 7)
                    {
                        DisplayResult(objResult);
                    }
                }
                else if (selectedOption == 8)
                {
                    Console.WriteLine("Thanks for using ZATCA SDK.");
                    return;
                }
                else
                {
                    Console.WriteLine("Please write the number of the option you want : ");
                    Console.WriteLine("1- Generating E-Invoice Hashing (Need E-Invoice XML file path)");
                    Console.WriteLine("2- Validate E-Invoice Hashing  (Need E-Invoice XML file path)");
                    Console.WriteLine("3- Generate E-Invoice QR Code  (Need E-Invoice XML file path)");
                    Console.WriteLine("4- Validate E-Invoice QR Code  (Need E-Invoice XML file path)");
                    Console.WriteLine("5- Validate E-Invoice  (Need E-Invoice XML file path)");
                    Console.WriteLine("6- Signing E-Invoice ");
                    Console.WriteLine("7- Generate CSR ");
                    Console.WriteLine("8- Exit Application");
                }
                Console.WriteLine(" PLEASE ENTER YOUR NEXT OPTION ");
            }
        }
        static void DisplayResult(Result objResult)
        {
            Console.WriteLine(" OPERATION : " + objResult.Operation);
            if (objResult.lstSteps != null && objResult.lstSteps.Count > 0)
            {
                foreach (Result currentStep in objResult.lstSteps)
                {
                    Console.WriteLine("         CURRENT STEP : " + currentStep.Operation);
                    if (currentStep.IsValid)
                    {
                        if (!string.IsNullOrEmpty(currentStep.ResultedValue))
                        {
                            Console.WriteLine("         RESULT : " + currentStep.ResultedValue);
                        }
                        else
                        {
                            Console.WriteLine("         RESULT : Successeded");
                        }
                    }
                    else
                    {
                        Console.WriteLine("         RESULT : Failed");
                        if (!string.IsNullOrEmpty(currentStep.ErrorMessage))
                        {
                            Console.WriteLine("         FAILED REASON : " + currentStep.ErrorMessage);
                        }
                    }
                }
            }
            //=====================================================
            if (objResult.IsValid)
            {
                Console.WriteLine(" FINAL RESULT : Successeded");
                if (!string.IsNullOrEmpty(objResult.ResultedValue) && selectedOption != 6)
                {
                    Console.WriteLine(" Result : " + objResult.ResultedValue);
                }
            }
            else
            {
                Console.WriteLine(" FINAL RESULT : Failed");
                if (!string.IsNullOrEmpty(objResult.ErrorMessage))
                {
                    Console.WriteLine("FAILED REASON : " + objResult.ErrorMessage);
                }
            }
        }
        
    }
}
