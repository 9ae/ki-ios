//
//  layerhelper.swift
//  iOSKinkedIn
//
//  Created by alice on 5/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import Foundation
import LayerKit

enum LayerError: Error {
    case CLIENT_NO_SET
}

class LayerHelper {
    
    static var client: LYRClient?
    
    static func authCallback(_ client: LYRClient, _ nonce: String){
        print("layer to call kiapi with \(nonce)")
        KinkedInAPI.messageLogin(nonce, callback: { (token) in
            client.authenticate(withIdentityToken: token, completion: { (authenticatedUser, error) in
                if(authenticatedUser != nil){
                    print("Layer Auth as: \(authenticatedUser?.userID)")
                }
                
                if(error != nil){
                    print(error.debugDescription)
                }
            })
        })
    }
    
    static func auth(){
        guard let _client = LayerHelper.client else {
            print("client not set, can't authenticate")
            return
        }
        
        _client.requestAuthenticationNonce { (_nonce, _error) in
            if let error = _error {
                print(error.localizedDescription)
                return
            }
            if let nonce = _nonce {
                LayerHelper.authCallback(_client, nonce)
            }
        }
    }
    
    static func startConvo(withUser: String) throws -> LYRConversation {
        let people : Set<String> = [withUser]
        guard let _client = LayerHelper.client else {
            throw LayerError.CLIENT_NO_SET
        }
        let opts = LYRConversationOptions()
        opts.distinctByParticipants = true
        
        do {
         let convo = try _client.newConversation(withParticipants: people, options: opts)
         return convo
        }
        catch let error as NSError {
            if let convo = error.userInfo["Existing Conversation"] as? LYRConversation {
                return convo
            } else {
                throw error
            }
        }
    }
    
}
