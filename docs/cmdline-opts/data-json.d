long: data-json
Arg: <data>
Help: HTTP POST data JSON escaped
Protocols: HTTP
See-also: data data-raw
Added: 7.74.0
Category: http post upload
---
This posts data, similar to the other --data options with the exception that
this performs JSON-escaping.

As per JSON spec, all control characters are properly escaped, avoiding the
need to pre-escape them. JSON data is always POSTed with the "Content-Type"
header set to 'application/json'. When supplying multiple --data parameters,
they all must have the same content type.

The only character that will not be escaped, is the double-quote, as curl does
not know if the double quote is part of the json code itself or the content.
.RS
.IP "content"
This will make curl JSON-escape the content and pass that on.
.IP "@filename"
This will make curl load data from the given filename and JSON-escape that
data to be passed on in the POST.
.RE
