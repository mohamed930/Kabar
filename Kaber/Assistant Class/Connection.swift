//
//  Connection.swift
//  rawanCake
//
//  Created by ahmadSaleh on 1/9/21.
//

//
import Foundation
import Reachability
import RxCocoa
import Alamofire

class NetworkManagerReachability: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: NetworkManagerReachability = { return NetworkManagerReachability() }()
    var connectionBehaviour = BehaviorRelay<Bool?>(value: nil)
    
    
    override init() {
        super.init()
        
        reachability = try! Reachability()
        
        reachability.whenReachable = { _ in
            NetworkManagerReachability.sharedInstance.connectionBehaviour.accept(true)
        }

        reachability.whenUnreachable = { _ in
            NetworkManagerReachability.sharedInstance.connectionBehaviour.accept(false)
        }

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            print("Start Notifier")
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        
        reachability.whenUnreachable = { [unowned self] reachability in
            print("F\(#line): unreachable")
            
            connectionBehaviour.accept(false)
        }
        
        reachability.whenReachable = { [weak self]  reachability in
            
            guard let self = self else { return }
            
            if reachability.connection == .wifi || reachability.connection == .cellular {
                print("F\(#line): reachable")
                connectionBehaviour.accept(true)
            }
            else {
                print("F\(#line): unreachable")
                connectionBehaviour.accept(false)
            }
            
            
        }
    }
    
    
    
    static func stopNotifier() -> Void {
        do {
            try (NetworkManagerReachability.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    func isReachable(completed: @escaping (NetworkManagerReachability) -> Void) {
        if (NetworkManagerReachability.sharedInstance.reachability).connection != .unavailable {
            print("there is internet")
            connectionBehaviour.accept(true)
            completed(NetworkManagerReachability.sharedInstance)
        }
    }
    
    func isUnreachable(completed: @escaping (NetworkManagerReachability) -> Void) {
        if (NetworkManagerReachability.sharedInstance.reachability).connection == .unavailable {
            print("No Internet!!")
            connectionBehaviour.accept(false)
            completed(NetworkManagerReachability.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (NetworkManagerReachability) -> Void) {
        if (NetworkManagerReachability.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManagerReachability.sharedInstance)
        }
    }
    
    static func isReachableViaWiFi(completed: @escaping (NetworkManagerReachability) -> Void) {
        if (NetworkManagerReachability.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManagerReachability.sharedInstance)
        }
    }
    
    
    func checkNetworkConnectivity() {
        let targetURL = "https://www.google.com" // Replace with a reliable host

        AF.request(targetURL)
            .response { [weak self] response in
                guard let self = self else { return }
                
                if let error = response.error {
                    print("Network is not reachable:", error)
                    connectionBehaviour.accept(false)
                } else {
                    print("Network is reachable")
                    connectionBehaviour.accept(true)
                }
            }
    }
    
    
 }

//extension NetworkManagerReachability: SimplePingDelegate {
//
//    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
//
//        ping.send(with: nil)
//    }
//
//    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
//
////        pingCompletion(false)
//        connectionBehaviour.accept(false)
//        ping.stop()
//    }
//
//    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
//
////        pingCompletion(true)
//        connectionBehaviour.accept(true)
//        ping.stop()
//    }
//}
