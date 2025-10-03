//
//  NetworkReachability.swift
//  BattleGroundAssement
//
//  Created by Satyam on 08/07/25.
//

import Foundation
import Network

protocol NetworkReachability {
    var isReachable: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class DefaultReachability: NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkReachabilityMonitor")
    private var currentStatus: Bool = true
    private let lock = NSLock()

    var isReachable: Bool {
        lock.lock()
        defer { lock.unlock() }
        return currentStatus
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            self.lock.lock()
            self.currentStatus = path.status == .satisfied
            self.lock.unlock()
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    deinit {
        stopMonitoring()
    }
}
