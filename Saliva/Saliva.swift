//
//  Saliva.swift
//  Saliva
//
//  Saliva allows you to bind parts of your UI together so
//  that they will update in unison. It's lightweight and flexible.
//  Saliva works by using a timer that's synchronised to the
//  display framerate. There's very little overhead, but because
//  your code could potentially run every frame - make it snappy.
//
//  The simplest usage is bind(from: yourSource, to: yourSink).
//  You can make each whatever you like. For example:
//  
//  bind(from: { self.model.coordinate }, to: { self.view.center = $0 })
//
//  If the type of the binding (in the above case probably CGPoint) is equatable
//  then Saliva will only call the binding if the value changes.
//  
//  If you explicitly want Saliva to bind every frame call bindEveryFrame
//  or if you want to explicitly bind only new values call bindNewValues
//
//
//  Using a timer that runs every frame to create bindings like this
//  can seem pretty messy. However since Swift has only some support
//  for KVO and since KVO based systems can have a lot of overhead, this
//  is a neat way to get simple bindings that are performant.
//
//  Created by Ben Taylor on 11/12/2014.
//  Copyright (c) 2014 Ben Taylor. All rights reserved.
//

import UIKit

public class BindingCollection: NSObject {
	var bindings: [Binding] = []
	
	var _displayLink: CADisplayLink?
	var displayLink: CADisplayLink {
		if let displayLink = _displayLink {
			return displayLink
		}
		_displayLink = CADisplayLink(target: self, selector: "handleDisplayLinkTick")
		_displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
		return _displayLink!
	}
	
	deinit {
		displayLink.invalidate()
	}
	
	
	// Public
	
	func addBinding(binding: Binding) {
		bindings.append(binding)
		updatePausedState()
	}
	
	func removeBinding(binding: Binding) {
		bindings = bindings.filter { $0 !== binding }
		updatePausedState()
	}
	
	public func handleDisplayLinkTick() {
		for binding in bindings {
			binding.apply()
		}
	}
	
	
	// Private
	
	internal func updatePausedState() {
		if bindings.count > 0 {
			displayLink.paused = false
		} else {
			displayLink.paused = true
		}
	}
}


public class Binding {
	func apply() {}
}

public class SimpleBinding<T>: Binding {
	let fromFunc: () -> T
	let toFunc: (T) -> ()
	
	init(from: () -> T, to: (T) -> ()) {
		fromFunc = from
		toFunc = to
	}
	
	// Passes the information from fromFunc to toFunc
	override func apply() {
		toFunc(fromFunc())
	}
}

public class DifferenceBinding<T: Equatable>: SimpleBinding<T> {
	var lastValue: T? = nil
	
	override init(from: () -> T, to: (T) -> ()) {
		super.init(from: from, to: to)
	}
	
	override func apply() {
		let newValue = fromFunc()
		if let lastValue = lastValue {
			if newValue != lastValue {
				toFunc(newValue)
			}
		} else {
			toFunc(newValue)
		}
		lastValue = newValue
	}
}


// Shared state and helper functions
// Not super keen on the shared state
// but it does allow for a nicer API

public let sharedBindingCollection = BindingCollection()

public func bind<T>(from fromFunc: () -> T, to toFunc: (T) -> ()) -> Binding {
	return bindEveryFrame(from: fromFunc, to: toFunc)
}

public func bind<T: Equatable>(from fromFunc: () -> T, to toFunc: (T) -> ()) -> Binding {
	return bindNewValues(from: fromFunc, to: toFunc)
}

public func bindEveryFrame<T>(from fromFunc: () -> T, to toFunc: (T) -> ()) -> SimpleBinding<T> {
	let binding = SimpleBinding(from: fromFunc, to: toFunc)
	sharedBindingCollection.addBinding(binding)
	return binding
}

public func bindNewValues<T: Equatable>(from fromFunc: () -> T, to toFunc: (T) -> ()) -> DifferenceBinding<T> {
	let binding = DifferenceBinding(from: fromFunc, to: toFunc)
	sharedBindingCollection.addBinding(binding)
	return binding
}

public func unbind(binding: Binding) {
	sharedBindingCollection.removeBinding(binding)
}