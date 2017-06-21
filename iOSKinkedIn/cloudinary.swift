//
//  cloudinary.swift
//  iOSKinkedIn
//
//  Created by alice on 3/6/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//
import Foundation
import Cloudinary

struct KiSignature {
    var signature: String
    var api_key: String
    var public_id: String
    var upload_present: String?
    var timestamp: NSNumber
    
    init?(json: [String: Any]){
        
        guard let _sign = json["signature"] as? String,
        let _key = json["api_key"] as? String,
        let _id = json["public_id"] as? String,
        let _time = json["timestamp"] as? NSNumber else {
            return nil
        }
        
        self.signature = _sign
        self.api_key = _key
        self.public_id = _id
        self.timestamp = _time
        
        self.upload_present = json["upload_preset"] as? String
    }
}

class CloudNine {
    
    var imageData: Data
    
    init(_ data: Data){
        self.imageData = data
    }
    
    private func confirmUpload(_ public_id: String, url: String){
        KinkedInAPI.post("self/picture", parameters: ["public_id": public_id, "url": url]){ json in
            print(json)
        }
    }
    
    private func performUpload(json: [String:Any]){
        guard let sign = KiSignature(json: json) else {
            print("unble to parse signature")
            return
        }
        // let signature = CLDSignature(signature: sign.signature, timestamp: sign.timestamp)
        print("signature created")
        print(sign)
        let config = CLDConfiguration(cloudName: "i99", apiKey: sign.api_key, apiSecret: nil)
        let cloudinary = CLDCloudinary(configuration: config)
        let params = CLDUploadRequestParams()
        params.setParam("api_key", value: sign.api_key)
        params.setPublicId(sign.public_id)
        params.setParam("signature", value: sign.signature)
        params.setParam("timestamp", value: sign.timestamp.stringValue)
        print("params set")
        cloudinary.createUploader().upload(
            data: self.imageData,
            uploadPreset: sign.upload_present ?? "baqslzqd",
            params: params,
            progress: self.progressReporter,
            completionHandler: self.completionHandler)

    }
    
    func startUpload(){

        KinkedInAPI.get("self/picture", callback: self.performUpload)
    }
    
    private func completionHandler(_ response: CLDUploadResult?, _ error: NSError?){
        print("At completion handler")
        if let errorMessage = error?.localizedDescription {
            print("Cloudinary Error")
            print(errorMessage)
            print(error)
        }
        
        if let publicId = response?.publicId,
            let url = response?.url {
            print("Cloudinary Response")
            confirmUpload(publicId, url: url)
        }
    }
    
    private func progressReporter(progress: Progress) {
        let status = "Uploading... \(progress.fractionCompleted)"
        print(status)
    }

}
