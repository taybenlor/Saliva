# Saliva

Saliva is a simple library for creating bindings in a functional style.


## Introduction

Saliva allows you to bind parts of your UI together so that they will update in unison. It's lightweight and flexible. Saliva works by using CADisplayLink to synchronise updates with the display framerate. There's very little overhead, but because your code could potentially run every frame - make it snappy.


## Example

The simplest usage is `bind(from: yourSource, to: yourSink)`. 

You can make each whatever you like. For example:

```Swift
bind(from: { self.model.coordinate }, to: { self.view.center = $0 })
```
If the type of the binding (in the above case probably CGPoint) is equatable then Saliva will only call the binding if the value changes. If you explicitly want Saliva to bind every frame call `bindEveryFrame` or if you want to explicitly bind only new values call `bindNewValues`.


## Warning

Saliva doesn't actually detect the changes happening, instead it simply updates every frame. That means that if the code you're using is expecting to only ever be called once per change, Saliva won't work. Saliva works best if your binding code can be run many times and is cheap.


## Extra

Using code that runs every frame to create bindings like this can seem pretty messy. However since Swift has only some support for KVO and since KVO based systems can have a lot of overhead, this is a neat way to get simple bindings that are performant.

