//
//  ViewController.swift
//  CombineExample
//
//  Created by Fernando Gomes on 24/11/19.
//  Copyright © 2019 Fernando Gomes. All rights reserved.
//
//  Tutorial from https://www.youtube.com/watch?v=RysM_XPNMTw

import UIKit
import Combine

extension Notification.Name {
    static let newMessage = Notification.Name("newMessage")
}

struct Message {
    var content: String
    var author: String
}

class ViewController: UIViewController {

    @IBOutlet weak var allowMessageSwitch: UISwitch!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @Published var canSendMessages: Bool = false
    
    private var switchSubscriber: AnyCancellable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupProcesscingChain()
    }
    
    func setupProcesscingChain() {
        switchSubscriber = $canSendMessages.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: sendButton)
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage)
        .map { notification -> String? in
            return(notification.object as? Message)?.content ?? ""
        }
        let messageSubscriber = Subscribers.Assign(object: messageLabel, keyPath: \.text)
        messagePublisher.receive(subscriber: messageSubscriber)
    }


    @IBAction func didSwitch(_ sender: UISwitch) {
        canSendMessages = sender.isOn
    }
    @IBAction func sendMessage(_ sender: Any) {
        let message = Message(content: "The current time is \(Date())", author: "Me")
        NotificationCenter.default.post(name: .newMessage, object:  message)
    }
}

