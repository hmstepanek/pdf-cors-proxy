local response = ngx.location.capture(ngx.var.request_uri, { method = ngx.HTTP_HEAD})
if (response.header["Content-Type"] == nil) then
    ngx.log(ngx.STDERR, "HEAD request for " .. ngx.var.request_uri .. " didn't have Content-Type header.")
    response = ngx.location.capture("/id_" .. ngx.var.request_uri)
end

if (response.header["Content-Type"] == "application/pdf" 
        or response.header["Content-Type"] == "application/x-pdf") then
    return ngx.exec("/pdf" .. ngx.var.request_uri)
else
    return ngx.redirect(os.getenv("VIA_URL") .. ngx.var.request_uri, 302)
end
