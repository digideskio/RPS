//
//  ViewController.swift
//  RPS
//
//  Created by Donny Davis on 9/21/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var peerSessions: PeerSessions?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        peerSessions?.viewController = self
    }

    @IBAction func playerSelectionTapped(_ sender: UIButton) {
        if sender.tag == 2 {
            if let mcBrowser = peerSessions?.setupMCBrowser() {
                present(mcBrowser, animated: true, completion: nil)
            }
        } else {
            performSegue(withIdentifier: "PlayerOneSegue", sender: nil)
        }
    }
    
    func playerTwoSelected() {
        performSegue(withIdentifier: "PlayerTwoSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectionVC = segue.destination as? SelectionViewController else { return }
        
        if let peerSessions = peerSessions {
            selectionVC.peerSessions = peerSessions
        }
        
        switch segue.identifier! {
        case "PlayerOneSegue":
            selectionVC.numberOfPlayers = 1
            
        case "PlayerTwoSegue":
            selectionVC.numberOfPlayers = 2
            
        default:
            return
        }
    }

}

