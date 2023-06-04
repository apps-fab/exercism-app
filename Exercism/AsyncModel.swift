//
//  AsyncModel.swift
//  Exercism
//
//  Created by Angie Mugo on 01/06/2023.
//

import Foundation

enum LoadingState<Value> {
    case idle
    case loading
    case success(Value)
    case failure(Error)
}

@MainActor
protocol LoadableObject: ObservableObject {
    associatedtype Value

    var state: LoadingState<Value> { get }
    func load() async
}

@MainActor
class AsyncModel<Value>: ObservableObject, LoadableObject {
    @Published private(set) var state: LoadingState<Value> = LoadingState.idle
    typealias AsyncOperation = () async throws -> Value

    var operation: AsyncOperation

    init(operation: @escaping AsyncOperation) {
        self.operation = operation
    }

    func load() async {
        state = .loading

        do {
            state = .success(try await operation() )
        } catch {
            state = .failure(error)
        }
    }

}
