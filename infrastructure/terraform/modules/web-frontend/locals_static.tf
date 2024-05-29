locals {
  # Map from file suffixes to the corresponding Content-Type values
  file_types = {
    "txt"    = "text/plain; charset=utf-8"
    "html"   = "text/html; charset=utf-8"
    "htm"    = "text/html; charset=utf-8"
    "xhtml"  = "application/xhtml+xml"
    "css"    = "text/css; charset=utf-8"
    "js"     = "application/javascript"
    "xml"    = "application/xml"
    "json"   = "application/json"
    "jsonld" = "application/ld+json"
    "gif"    = "image/gif"
    "jpeg"   = "image/jpeg"
    "jpg"    = "image/jpeg"
    "png"    = "image/png"
    "svg"    = "image/svg+xml"
    "webp"   = "image/webp"
    "weba"   = "audio/webm"
    "webm"   = "video/webm"
    "pdf"    = "application/pdf"
    "ico"    = "image/vnd.microsoft.icon"
    "ttf"    = "font/ttf"
    "woff"   = "font/woff"
    "woff2"  = "font/woff2"
    "otf"    = "font/otf"
  }

  cloudfront_error_map = {
    "400" : { error_code : 400, response_page_path : "/error/400", response_code : "400" },
    "403" : { error_code : 403, response_page_path : "/error/403", response_code : "403" },
    "404" : { error_code : 404, response_page_path : "/error/404", response_code : "404" },
    "405" : { error_code : 405, response_page_path : "/error/400", response_code : "405" },
    "414" : { error_code : 414, response_page_path : "/error/400", response_code : "414" },
    "416" : { error_code : 416, response_page_path : "/error/400", response_code : "416" },
    "500" : { error_code : 500, response_page_path : "/error/500", response_code : "500" },
    "501" : { error_code : 501, response_page_path : "/error/500", response_code : "501" },
    "502" : { error_code : 502, response_page_path : "/error/400", response_code : "502" },
    "503" : { error_code : 503, response_page_path : "/error/503", response_code : "503" },
    "504" : { error_code : 504, response_page_path : "/error/400", response_code : "504" },
  }

  # The Content-Type value to use for any files that don't match one of the suffixes given in file_types
  default_file_type = "application/octet-stream"
}
