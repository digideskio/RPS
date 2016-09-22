//
//  SelectionViewController.swift
//  RPS
//
//  Created by Donny Davis on 9/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {
    
    var numberOfPlayers: Int?
    var peerSessions: PeerSessions?
    var selectedChoice: Choices?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func selectionTapped(_ sender: UIButton) {
        // Create a choice type from the selected button
        selectedChoice = Choices(rawValue: sender.tag)
        
        performSegue(withIdentifier: "ResultsSegue", sender: nil)
    }
    
    @IBAction func changePlayersTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            // Create an instance of the results view controller and set the selected choice and number of players
            let resultsVC = segue.destination as! ResultsViewController
            resultsVC.selectedChoice = selectedChoice
            if numberOfPlayers == 1 {
                resultsVC.opponentsChoice = Choices.random()
            }
            if let peerSessions = peerSessions {
                resultsVC.peerSessions = peerSessions
            }
            
            // Check to see if we have a session and are connected to another device
            if let peerSessions = peerSessions, peerSessions.mcSession.connectedPeers.count > 0 {
                // Create a data pointer from our selected choice
                let dataPointer = withUnsafePointer(to: &selectedChoice) { p in
                    Data(bytes: p, count: MemoryLayout.size(ofValue: selectedChoice))
                }
                
                // Try to send the data to the connected device and display an error if unsuccessful
                do {
                    try peerSessions.mcSession.send(dataPointer, toPeers: peerSessions.mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(ac, animated: true, completion: nil)
                }
            }
        }
    }
}
