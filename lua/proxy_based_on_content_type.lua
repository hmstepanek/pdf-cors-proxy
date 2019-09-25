local response = ngx.location.capture("/id_" .. ngx.var.request_uri)
if (response.header["Content-Type"] == "application/pdf" 
        or response.header["Content-Type"] == "application/x-pdf") then
    return ngx.exec("/pdf" .. ngx.var.request_uri)
else
    return ngx.redirect(os.getenv("VIA_URL") .. ngx.var.request_uri, 302)
end
