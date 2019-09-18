# pdf-proxy
prototype proxy server for hypothesis

# How it works
This is a prototype of a pdf cors proxy server implemented in nginx and lua.
Lua is an interpreted language similar to Python. It is used to perform some
simple logic and templating at the nginx layer.

When a request to the proxy is issued at for example:
`localhost:9081/http://example.com/pdf.pdf` it is routed to the '/' endpoint
which issues a request to `localhost:9081/id_/http://example.com/pdf.pdf`.
This is a non-blocking request. Once it completes, it looks at the 
Content-Type response header to see if it contains a pdf type and if it does
it issues a redirect to `localhost:9081/pdf/http://example.com/pdf.pdf`. If the
content type does not match a pdf it is routed to `localhost:9080/http://example.com/pdf.pdf`
(aka via).

The `/pdf/` endpoint responds with the pdf and the hypothesis client embeded in an html page.
This pdf page also contains a url to the proxied pdf: `localhost:9081/id_/http://example.com/pdf.pdf`
Note this is the same endpoint that was hit in the original request to check the Content-Type
header. Due to nginx caching, that means this second request will return the cached response as opposed
to issueing a second request to the host pdf server.

Note it is also using redirects which means the next time this page needs to proxy a pdf or an html page
it won't run the Content-Type check again which will save time.

# Future Considerations
Note there is a TODO in the code to clear cookies coming back from the server that hosts the pdf.

Using `/id_/` for the pdf proxy may be problematic and catch via proxy requests as well so if we put this
on top of via we may need to rename that endpoint.

While redirecting means we don't run the Content-Type header check again, there may be some issues
with doing this-we may not want to rewrite the url to the redirected url. Also note caching would still
be at play here so it may not be a big performance hit to run the check again since the response to get
the Content-Type header would already be cached.

# Getting Started
Note this is dependent on H, the Client, and Via so those services also need to be running.

To run:
```
docker-compose up -d
```

To stop:
```
docker-compose down
``` 

# Running in Development Mode
Alternatively, to see logging from nginx you can run:
```
docker-compose run --service-ports pdf-proxy
```

To stop ctrl-C and run:

```
docker-compose rm -f pdf-proxy
```


