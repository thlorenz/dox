**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Events](#events)
- [Event Object](#event-object)
- [Creation](#creation)
- [Properties](#properties)
- [Propagation](#propagation)
- [Performance](#performance)
- [Advantages of using selector (delegated evenst)](#advantages-of-using-selector-(delegated-evenst))
- [`on` vs `bind`, `live` and `delegate`](#`on`-vs-`bind`,-`live`-and-`delegate`)
- [.on](#.on)
- [Signatures](#signatures)
- [.off](#.off)
- [Signatures](#signatures)
- [.trigger](#.trigger)
- [Signatures](#signatures)
- [Widget Factory](#widget-factory)
- [What](#what)
- [Why](#why)
- [Building Prototype](#building-prototype)
- [Infrastructure](#infrastructure)
- [Private vs. Public Methods](#private-vs.-public-methods)
- [Instance Properties](#instance-properties)
- [element](#element)
- [options](#options)
- [namespace, name](#namespace,-name)
- [widgetEventPrefix](#widgeteventprefix)
- [widgetBaseClass](#widgetbaseclass)
- [Extra Instance Methods (not mentioned in *Infrastructure*)](#extra-instance-methods-(not-mentioned-in-*infrastructure*))
- [_init](#_init)
- [option](#option)
- [enable/disable](#enable/disable)
- [_trigger](#_trigger)
- [Inner Workings](#inner-workings)

# Events

[Event Handler Attachment](http://api.jquery.com/category/events/event-handler-attachment/)

## Event Object

[doc page](http://api.jquery.com/category/event-object/)

### Creation

- `jQuery.Event('name')`
- can be used to later trigger it

### Properties

- **target:**               event initiating element
- **currentTarget:**        current element within bubbling phase
- **delegateTarget:**       element where currently called handler was attached
- **relatedTarget**         other element involved in event (if any)
- **namespace:**            specified when event was triggered
- **pageX, pageY:**         mouse position
- **data:**                 optional data map
- **result:**               value returned by last handler triggered by this event
- **timeStamp:**            in milliseconds
- **which:**                indicates keys/buttons pressed

## Propagation

- all events bubble to the document
- all event handlers attached to an element in its path are executed
- stop bubbling: `event.stopProagation`
- prevent other handlers on same element from executing: `event.stopImmediatePropagation` (they execute in order they are bound)
- prevent browser's default action `event.preventDefault`
- returning false from event handler calls `event.stopPropagation` and `event.preventDefaults`, a shortcut for this is to substitue handler function with `false`

## Performance

- attach as close to event targets as possible (e.g., attaching to document causes events from everywhere to be evaluated there)

### Advantages of using selector (delegated evenst)

- allows subscribing to child element's events before they are added
- much lower overhead (less event handlers)

## `on` vs `bind`, `live` and `delegate`

- in a nutshell - use `on` only (all others get mapped to `on` anyways)
- more in this [stackoverflow answer](http://stackoverflow.com/questions/8065305/whats-the-difference-between-on-and-live-or-bind)

## .on

[doc page](http://api.jquery.com/on/)

### Signatures

`.on(events [, selector] [,data], handler(event))`
`.on(events-map [, selector] [,data])`

- **events:**     space-separated event types and optional namespaces
- **selector:**   filters descendants of selected elements that trigger the event
- **data:**       data passed to event.data
- **handler:**    executed when triggered
- **events-map:** map of **keys** *space separated event types* and **values** *event handlers*

## .off

[doc page](http://api.jquery.com/off/)

- removes events handlers that fit **all** given filtering arguments
- `"**"` removes all delegated events without removing non-delegated ones

### Signatures

`.off(events [, selector] [, handler(eventObject)])
`.off(events-map [, selector])`

- **selector:** should match selector passed to `on`
- **handler:**  handler previously attached for the events

## .trigger

[doc page](http://api.jquery.com/trigger/)

- executes **all** handlers attached to matched elements for event type

### Signatures

`.trigger(eventType[, params])`
`.trigger(event)`

- **eventType:**    e.g., 'click'
- **params:**       additional params passed to handler
- **event:**        event object


# Widget Factory

[doc page](http://wiki.jqueryui.com/w/page/12138135/Widget%20factory)

## What

- simple function that takes 2 or 3 args
    - 'namespace.widgetname'
        - creates `jQuery.namespace`, `jQuery.namespace.widgetname` and `jQuery.namespace.widgetname.prototype`
    - existing prototype to inherit from (optional)
        - if no prototype is given, widget inherits directly from `jQuery.Widget`
    - object literal to become widget's prototype
        - is transformed into prototype for eahc instance of the widget
        - widget's prototype is connected to any super widgets down to `jQuery.Widget`

## Why

- automatic **pseudo selector** creation `$(':namespace-widgetname')`
- prototype linked to `jQuery.fn` via `jQuery.widget.bridge`
- default options merged with user's overrides
- plugin instance accessible via `$('#id').data('widgetname')`
- reference to jQuery object containing DOM element available as widget instance property `this.element`
- widget's methods accesible via `$('#id').widgetname('methodname')` or `$('#id').data('widgetname').methodname()`
- multiple instantiation of widget on same element prevented
- dispatching callbacks via `this._trigger('eventname')`
- mechanism to allow responding to plugin option changes after instantiation
  via `$('#id').widgetname('option', 'optname', function (event) { ... })`
- `enable` or `disable` widget easily
- automatic method chaining (if method returns no value, plugin instance is returned)

## Building Prototype

### Infrastructure

minimum: 

- `options` used as defaults
- `_create` set up widget (build and inject markup, bind events, etc.,)
- `_setOption` respond to changes to options
    - jQuery UI 1.8 and below invoke `_setOption` on base widget via: `$.Widget.prototype._setOption.apply( this, arguments );`
    - jQuery UI 1.9 and above use `this._super( "_setOption", key, value );`
- `destroy` clean up any DOM modifications caused by widget
    - jQuery UI 1.8 and below invoke base via `$.Widget.prototype.destroy.call( this );` 
    - jQuery UI 1.9 and above define `_destroy` instead of `destroy` and not call base

### Private vs. Public Methods

- `_privateMethod` and `publicMethod`
- `$('#id').('_privateMethod`)` throws exception

### Instance Properties

#### element

- element used to instantiate plugin
- e.g., do `$('#id').myWidget()` then inside widget `element` refers to 'id' element wrapped inside $

#### options

- provided by user and merged with any default options defined on `$.namespace.widgetname.prototype.options`

#### namespace, name

- as given, usually not needed

#### widgetEventPrefix

- determines how to prefix callbacks that the plugin provides
- defaults to widget name but can be overriden

#### widgetBaseClass

- used to build class names to use on elements within the widget
- usefull inside widget factory and abstract plugins

### Extra Instance Methods (not mentioned in *Infrastructure*)

#### _init

- invoked when widget is invoked with no or one option argument
- usually called after `_create` or `create`
- `_create` only called once per widget instance (unless it is destroued), `_init` each time widget is called without args
- place default functionality here

#### option

- get/set options after instantiation
- same method signature ass `.css()` and `attr()`
- calls `_setOptions` internally which then calls `_setOption`
- should not be modified by plugin

#### enable/disable

- calls `option('disabled', false/true)` thic triggers `_setOption`

#### _trigger

- used to execute callbacks
- `_trigger('eventName'[, eventObject] [, hash])`
- `self._trigger('eventName')`
    - widget factory prepends widget's name and fires event
    - if function with 'eventName' exists inside options object, it is also triggered

### Inner Workings

- widget instance is stored in element's data() cache e.g., `$('#id').data()`
- on `_create` markup is generated and injected into DOM and the original element transformed
    
