#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide at https://www.varnish-cache.org/docs/
# and https://www.varnish-cache.org/trac/wiki/VCLExamples for more examples.

# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

backend httpd {
    .host = "127.0.0.1";
    .port = "8080";
}

backend simple {
    .host = "127.0.0.1";
    .port = "8081";
}

backend www {
    .host = "127.0.0.1";
    .port = "2368";
}

backend candida {
    .host = "127.0.0.1";
    .port = "3000";
}

sub vcl_recv {
  # Happens before we check if we have this in cache already.
  #
  # Typically you clean up the request here, removing cookies you don't need,
  # rewriting the request, etc.
  #Basic aWJlcnM6eHlsaXRvbA==
  if (req.http.host ~ "^(.*\.)?whut.tv$") {
      set req.backend_hint = simple;
  }

  if (req.http.host ~ "^(.*\.)?owen\.cymru$") {
    if (req.http.host ~ "^files")  {
      set req.backend_hint = httpd;
    } else if (req.http.host ~ "^candida") {
      set req.backend_hint = candida;
    } else if (req.http.host ~ "^vlog") {
      return (synth(302, "https://www.youtube.com/channel/UCgUh0PuD7_I5voGfbSd36LA"));
    } else if (req.http.host ~ "^tv") {
      set req.backend_hint = simple;
    } else {
      if (req.url ~ "^/keybase.txt") {
        set req.url = "/keybase.txt";
        set req.backend_hint = httpd;
      } else {
        set req.backend_hint = www;
      }
    }
  }

}

sub vcl_synth {
  if (resp.status == 301 || resp.status == 302) {
      set resp.http.location = resp.reason;
      set resp.reason = "Moved";
      return (deliver);
  }
}


sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}

