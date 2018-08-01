//
//  EventBusMiddleware+EventBusPostable.swift
//  SwiftyEventBus
//
//  Created by Maru on 2018/8/1.
//

import Foundation

extension EventBusPureMiddleWare: EventBusPostable {

    public func post<T>(_ cargo: T) where T: EventPresentable {
        let identifier = T.processIdentifier
        if (support(.sticky)) {
            host.replayBuff.enqueue(cargo)
        }
        guard let queue = host.observers[identifier] as? Set<EventSubscriber<T>> else {
            return
        }
        performPost(with: queue, cargo: cargo)
    }
}

extension EventBusDangerMiddleWare: EventBusSafePostable {

    public func post<T>(_ cargo: T) throws where T: EventPresentable {
        let identifier = T.processIdentifier
        if (support(.sticky)) {
            host.replayBuff.enqueue(cargo)
        }
        guard let queue = host.observers[identifier] as? Set<EventSubscriber<T>> else {
            return
        }
        if (support(.safety) && queue.isEmpty) {
            throw EventBusPostError.useless
        }
    }
}
