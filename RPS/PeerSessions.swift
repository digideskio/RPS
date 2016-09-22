//
//  PeerSessions.swift
//  RPS
//
//  Created by Donny Davis on 9/21/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PeerSessions: NSObject {
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var choice: Choices?
    
    var viewController: UIViewController? {
        didSet {
            if choice != nil {
                sendResult()
            }
        }
    }
    
    override init() {
        super.init()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func setupMCBrowser() -> MCBrowserViewController {
        let mcBrowser = MCBrowserViewController(serviceType: "tiy-rps2016", session: mcSession)
        mcBrowser.delegate = self
        return mcBrowser
    }
    
    func startSession() {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "tiy-rps2016", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func stopSession() {
        mcAdvertiserAssistant.stop()
    }
    
    func sendResult() {
        if let resultsVC = viewController as? ResultsViewController {
            resultsVC.opponentsChoice = choice
            
            DispatchQueue.main.async {
                resultsVC.checkResults()
            }
        }
    }
}

extension PeerSessions: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dataPointer = UnsafeMutablePointer<Choices>.allocate(capacity: MemoryLayout<Choices>.size)
        choice = dataPointer.move()
        
        sendResult()
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
}

extension PeerSessions: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        if mcSession.connectedPeers.count > 0, let viewController = viewController as? ViewController {
            viewController.playerTwoSelected()
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
}

