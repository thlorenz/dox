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

