**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Cross Site Scripting](#cross-site-scripting)
	- [Same Origin Policy](#same-origin-policy)
		- [Same Site](#same-site)
		- [Relaxing Same Origin Policy](#relaxing-same-origin-policy)
		- [Resources](#resources)
	- [document.domain property](#documentdomain-property)
	- [Cross-Origin Resource Sharing (CORS)](#cross-origin-resource-sharing-cors)
		- [Standard](#standard)
		- [preflight](#preflight)
		- [Example (simplified)](#example-simplified)
		- [CORS vs. JSONP](#cors-vs-jsonp)
		- [Resources](#resources-1)
	- [Cross-document Messaging](#cross-document-messaging)
		- [Standard](#standard-1)
			- [Message Event Properties](#message-event-properties)
		- [Example](#example)
		- [Security Concerns](#security-concerns)
		- [Resources](#resources-2)

# Cross Site Scripting

## Same Origin Policy

- permits scripts running on web pages that originiate from the same site to access each others methods and properties
  without specific restrictions
- prevents access to most of these across pages of different sites

### Same Site

- site origin derived from **scheme** (protocol: `http|https|ftp ..`), **hostname** and **port**

### Relaxing Same Origin Policy

Three techniques to relax SOP exist (explained below)

- **document.domain property**
- **Cross-Origin Resource Sharing**
- **Cross-document Messaging**

### Resources

[wikipedia](http://en.wikipedia.org/wiki/Same_origin_policy)


## document.domain property

- two windows (frames) set domain to same value, same-origin policy is relaxed for them and they can interact
- i.e. `orders.foo.com` and `catalog.foo.com` set `document.domain` properties to `foo.com` which makes documents appear
  to have same origin, thus enabling each document to read properties of the other


## Cross-Origin Resource Sharing (CORS)

- allows JavaScript on a page to make requests to another domain (not the one it originated from)
- browser and server interact to determine if the cross-origin request should be allowed

### Standard

- HTTP headers that allow servers to serve resource to permitted origin domains
- enforced by browsers including **preflight**ing requests with side-effects

### preflight

- mandated for HTTP request methods that can cause side-effects
- `OPTIONS` request made by browser before the actual the request to determine what methods the server supports
- once server approves, actual request is sent
- if browser's origin is not allowed, it delivers error to page instead of the reponse
- `Access-Control-Allow-Origin: *` allows access to all domains, but is not appropriate except if server content is
  intended to be accessible by everyone (including any code on any site)

### Example (simplified)

1. browser sends request with `Origin : http://domain.that.served.page` header to cross domain server
2. if server allows request it sends `Access-Control-Allow-Origin: http://domain.that.served.page` (indicating what
   origins are allowed)

### CORS vs. JSONP

- CORS is modern alternative to JSONP
- JSONP supports only `GET`
- proper XMLHttpRequests support better error handling than JSONP
- JSONP may compromoise external site while CORS allows website to parse responses to ensure security

### Resources

- [wikipedia](http://en.wikipedia.org/wiki/Cross-Origin_Resource_Sharing)



## Cross-document Messaging

- introduced in HTML5 spec draft
- allows documents to communicate with each other across different origins or source domains
- provides rudimentary security

### Standard

- text messages can be sent across domains via the Messaging API `postMessage` method

Author obtains `window` of receiving document at whic point it can post messages to:

- other frames/iframs within the sender document's window
- parent window of sender document and windows opened by it via JavaScript calls
- window that opened sender document

#### Message Event Properties

- **data** the text message
- **origin** of sender document (`scheme://hostname:port`)
- **source** `WindowProxy` == source window

### Example

-document A communicates with document B

```js
// A
var o = document.getElementsByTagName('iframe')[0];
o.contentWindow.postMessage('Hello B', 'http://documentB.com/');
```

```js
// B
function receiver(event) {
  if (event.origin == 'http://documentA.com') {
    if (event.data == 'Hello B') {
      event.source.postMessage('Hello A, how are you?', event.origin);
    }
    else {
      alert(event.data);
    }
  }
}
window.addEventListener('message', receiver, false);
```

### Security Concerns

- `origin` property and format of incoming messages should always be checked

### Resources

[wikipedia](http://en.wikipedia.org/wiki/Cross-document_messaging)
