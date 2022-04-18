//
//  File.swift
//  
//
//  Created by Borja Arias Drake on 18.04.2022..
//

import Combine

extension Publisher {
    
    public func asyncSink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) async -> Void),
                          receiveValue: @escaping ((Self.Output) async -> Void)) -> AnyCancellable {
        sink { completion in
            Task {
                await receiveCompletion(completion)
            }
        } receiveValue: { output in
            Task {
                await receiveValue(output)
            }
        }
    }
}


