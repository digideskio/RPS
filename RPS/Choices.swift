//
//  Choices.swift
//  RPS
//
//  Created by Donny Davis on 9/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

enum Choices: Int {
    case Rock
    case Paper
    case Scissors
    
    var image: UIImage {
        switch self {
        case .Rock:
            return #imageLiteral(resourceName: "rock")
        case .Paper:
            return #imageLiteral(resourceName: "sheet_of_paper")
        case .Scissors:
            return #imageLiteral(resourceName: "scissors")
        }
    }
    
    static func random() -> Choices {
        let randomIndex = Int(arc4random_uniform(2))
        guard let choice = Choices(rawValue: randomIndex) else {
            return Choices(rawValue: 0)!
        }
        return choice
    }
    
    func compare(withOpponentsChoice opponentsChoice: Choices) -> Bool? {
        switch (self, opponentsChoice) {
        case (.Rock, .Paper):
            return false
        case (.Rock, .Scissors):
            return true
        case (.Paper, .Rock):
            return true
        case (.Paper, .Scissors):
            return false
        case (.Scissors, .Rock):
            return false
        case (.Scissors, .Paper):
            return true
        default:
            return nil
        }
    }
}
