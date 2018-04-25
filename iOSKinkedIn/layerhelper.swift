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
        if (KinkedInAPI.token == ""){
            print("Kiapi token not ready yet, can't auth with Layer yet")
            return
        }
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
    
    static func startConvo(withUser: String, distinct: Bool = true, metadata: [String:Any] = [:] ) throws -> LYRConversation {
        let people : Set<String> = [withUser]
        guard let _client = LayerHelper.client else {
            throw LayerError.CLIENT_NO_SET
        }
        let opts = LYRConversationOptions()
        opts.distinctByParticipants = distinct
        opts.metadata = metadata

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
    
    static func makeAftercareVC(userInfo: [AnyHashable : Any]) -> CareConvoVC {
        let convo = CareConvoVC(layerClient: LayerHelper.client!)
        do{
            convo.conversation = try LayerHelper.startConvo(
                withUser: "aftercare",
                distinct: false,
                metadata: [
                    "about_user_id": userInfo["with_user_id"] as! String,
                    "case_type": "checkin"
                ]
            )
            try convo.conversation.synchronizeAllMessages(.toFirstUnread)
            convo.hidesBottomBarWhenPushed = true
        } catch {
            print("failed to start aftercare convo")
        }
        return convo
    }
    
    static func makeConvoVC(_ profile: Profile) -> ConvoVC? {
        do {
        let convo = ConvoVC(layerClient: LayerHelper.client!)
        convo.title = profile.name
        convo.displaysAddressBar = false
        convo.conversation = try LayerHelper.startConvo(withUser: profile.uuid)
        convo.profile = profile
            return convo
        } catch {
            return nil
        }
    }
    
}
