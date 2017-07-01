//
//  CaseList.swift
//  iOSKinkedIn
//
//  Created by alice on 6/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class CaseList: ATLConversationListViewController,
    ATLConversationListViewControllerDataSource,
    ATLConversationListViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftItemsSupplementBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func conversationListViewController(_ viewController: ATLConversationListViewController, willLoadWith defaultQuery: LYRQuery) -> LYRQuery {
        defaultQuery.predicate = LYRPredicate(property: "participants", predicateOperator: .isEqualTo, value: "aftercare")
        return defaultQuery
    }
    
    public func conversationListViewController(_ conversationListViewController: ATLConversationListViewController, titleFor conversation: LYRConversation) -> String {
        if let dtdescript = conversation.createdAt?.description {
            return dtdescript
        } else {
            return "some convo"
        }
    }
    
    public func conversationListViewController(_ conversationListViewController: ATLConversationListViewController, didSelect conversation: LYRConversation) {
        let readConvo = ReadCaseVC(layerClient: self.layerClient)
        readConvo.conversation = conversation
        self.navigationController?.pushViewController(readConvo, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
