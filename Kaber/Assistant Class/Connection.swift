//
//  Connection.swift
//  rawanCake
//
//  Created by ahmadSaleh on 1/9/21.
//

//
import Foundation
import Reachability
import SimplePing
import RxCocoa

class NetworkManagerReachability: NSObject {
    
    var reachability: Reachability!
    
    private var ping: SimplePing!
    private var pingCompletion: ((Bool) -> Void)!
    
    static let sharedInstance: NetworkManagerReachability = { return NetworkManagerReachability() }()
    var connectionBehaviour = BehaviorRelay<Bool?>(value: nil)
    
    
    override init() {
        super.init()
        
        reachability = try! Reachability()
        
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
        
        NetworkManagerReachability.sharedInstance.reachability.whenUnreachable = { reachability in
            print("F\(#line): unreachable")
            self.connectionBehaviour.accept(false)
        }
        
        NetworkManagerReachability.sharedInstance.reachability.whenReachable = { [weak self]  reachability in
            
            guard let self = self else { return }
            
            print("F\(#line): reachable")
            
            pingIP("8.8.8.8")
            
            pingCompletion = { [weak self] status in
                guard let self = self else { return }
                print(status)
                
                switch status {
                    case true:
                        print("reachable")
                        connectionBehaviour.accept(true)
                        ping?.stop()
                    case false:
                        print("F\(#line): unreachable")
                        connectionBehaviour.accept(false)
                }
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
    
    func pingIP(_ ip: String) {
        ping = SimplePing(hostName: ip)
        ping.delegate = self
        ping.start()
    }
 }

extension NetworkManagerReachability: SimplePingDelegate {
//    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
//        pinger.send(with: address)
//    }

    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        pingCompletion(false)
        ping.start()
    }

    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        pingCompletion(true)
        ping.stop()
    }
}
