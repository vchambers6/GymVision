//
//  AWSS3Utils.swift
//  GymVision
//
//  Created by Vanessa Chambers on 4/29/24.
//

import Foundation
import AWSS3

class AWSS3GifLoader {
    let s3Bucket = "3605e390-a72e-480b-8435-19d7a740a2a9"
    let gifKey = "skills_videos/Arabian.gif"
    public func downloadGIFFromS3(bucket: String, key: String, completion: @escaping (Data?, Error?) -> Void) {
        let transferUtility = AWSS3TransferUtility.default()
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = { (task, progress) in
            // what do i put here
        }
        transferUtility.downloadData(
                fromBucket: bucket,
                key: key,
                expression: expression,
                completionHandler: { (task, url, data, error) in
                    if let error = error {
                        print("Error downloading GIF: \(error)")
                        completion(nil, error)
                        return
                    }

                    if let data = data {
                        // Successfully downloaded data
                        completion(data, nil)
                    } else {
                        // No data downloaded
                        completion(nil, NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data downloaded"]))
                    }
                }
            )
        
    }
//    let client = S3Client
//    
//    public init() async {
//            do {
//                client = try S3Client(region: "us-east-2")
//            } catch {
//                print("ERROR: ", dump(error, name: "Initializing S3 client"))
//                exit(1)
//            }
//        }
//
//    public func downloadFile(bucket: String, key: String, to: String) async throws {
//            let fileUrl = URL(fileURLWithPath: to).appendingPathComponent(key)
//
//            let input =
//        
//        (
//                bucket: bucket,
//                key: key
//            )
//            let output = try await client.getObject(input: input)
//
//            // Get the data stream object. Return immediately if there isn't one.
//            guard let body = output.body,
//                  let data = try await body.readData() else {
//                return
//            }
//            try data.write(to: fileUrl)
//        }
//

    
}
