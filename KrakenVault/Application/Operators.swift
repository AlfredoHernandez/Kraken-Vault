//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

public func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: SingleTypeComposition
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    { g(f($0)) }
}

precedencegroup SingleTypeComposition {
    associativity: right
    higherThan: ForwardApplication
}

infix operator <>: SingleTypeComposition

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    f >>> g
}

public func <> <A: AnyObject>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    { a in
        f(a)
        g(a)
    }
}

precedencegroup BackwardsComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <<<: BackwardsComposition

public func <<< <A, B, C>(g: @escaping (B) -> C, f: @escaping (A) -> B) -> (A) -> C {
    { x in
        g(f(x))
    }
}

public func zurry<A>(_ f: () -> A) -> A {
    f()
}

public func compose<A>(_ modules: A...) -> ((A) -> Void) -> Void {
    { action in
        modules.forEach(action)
    }
}

// Equivalent to ForwardApplication
public func with<A, B>(_ a: A, _ f: (A) -> B) -> B {
    f(a)
}

// Equivalent to ForwardComposition
public func pipe<A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    { a in
        g(f(a))
    }
}

// Equivalent to BackwardsComposition
func compose<A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    { f(g($0)) }
}

public func concat<A: AnyObject>(_ f: @escaping (A) -> Void, _ g: @escaping (A) -> Void, _ fs: ((A) -> Void)...) -> (A) -> Void {
    { a in
        f(a)
        g(a)
        fs.forEach { f in f(a) }
    }
}

protocol Mappeable {
    func map<A>(_ f: @escaping (Self) -> A) -> A
}

extension Mappeable {
    func map<A>(_ f: @escaping (Self) -> A) -> A {
        f(self)
    }
}
