local response = ngx.location.capture("/id_" .. ngx.var.request_uri)
if (response.header["Content-Type"] == "application/pdf" 
        or response.header["Content-Type"] == "application/x-pdf") then
    return ngx.redirect("/pdf" .. ngx.var.request_uri, 302)
else
    return ngx.redirect(os.getenv("VIA_URL") .. ngx.var.request_uri, 302)
end
