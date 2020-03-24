//
//  File.swift
//  NetworkLayer
//
//  Created by Valeriy Kutuzov on 24.03.2020.
//  Copyright © 2020 Valeriy Kutuzov. All rights reserved.
//

import Foundation

class NSURLSessionPinningDelegate: NSObject, URLSessionDelegate {

func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void)
{
	if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
		{
            if let serverTrust = challenge.protectionSpace.serverTrust
			{
				if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
				{
					let serverCertificateData = SecCertificateCopyData(serverCertificate)
					let data = CFDataGetBytePtr(serverCertificateData)
					let size = CFDataGetLength(serverCertificateData)
					let cert1 = NSData(bytes: data, length: size)
					let file_der = Bundle.main.path(forResource: "si2", ofType: "cer")

					if let file = file_der
					{
						if let cert2 = NSData(contentsOfFile: file)
						{
							if cert1.isEqual(to: cert2 as Data)
							{								completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:serverTrust))
								return
							}
						}
					}
				}
            }
        }

	// Pinning failed
	completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }

}
