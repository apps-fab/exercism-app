//
//  AsyncModel.swift
//  Exercism
//
//  Created by Angie Mugo on 01/06/2023.
//

import Foundation
import ExercismSwift

enum LoadingState<Value: Sendable> {
    case idle
    case loading
    case success(Value)
    case failure(ExercismClientError)
}

@MainActor
protocol LoadableObject: ObservableObject {
    associatedtype Value: Sendable
    
    var state: LoadingState<Value> { get }
    func load() async
}

@MainActor
class AsyncModel<Value: Sendable>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<Value> = LoadingState.idle
    typealias AsyncOperation = () async throws -> Value
    typealias SyncOperation = () -> Value
    
    var operation: AsyncOperation
    var filterOperations: SyncOperation? {
        didSet {
            state = .success(filterOperations!())
        }
    }
    
    init(operation: @escaping AsyncOperation) {
        self.operation = operation
        
        Task { await self.load() }
    }
    
    func load() async {
        state = .loading
        
        do {
            state = .success(try await operation() )
        } catch {
            state = .failure(error as? ExercismClientError ?? ExercismClientError.unsupportedResponseError)
        }
    }
}
