//
//  ResultsViewController.swift
//  RPS
//
//  Created by Donny Davis on 9/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var resultsTitle: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    
    var selectedChoice: Choices?
    var opponentsChoice: Choices?
    var peerSessions: PeerSessions?

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTitle.text = "Waiting..."
        
        checkResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        peerSessions?.viewController = self
    }

    @IBAction func playAgainTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func checkResults() {
        if let selectedChoice = selectedChoice, let opponentsChoice = opponentsChoice {
            if let result = selectedChoice.compare(withOpponentsChoice: opponentsChoice) {
                resultsLabel.text = "Beats"
                switch result {
                case true:
                    resultsTitle.text = "You Win!"
                    image1.image = selectedChoice.image
                    image2.image = opponentsChoice.image
                case false:
                    resultsTitle.text = "You Loose!"
                    image1.image = opponentsChoice.image
                    image2.image = selectedChoice.image
                }
            } else {
                resultsLabel.text = ""
                resultsTitle.text = "It's A Tie!"
                image1.image = selectedChoice.image
                image2.image = opponentsChoice.image
            }
        }
    }
    
}
