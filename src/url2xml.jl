using HTTP: request as rq
using LightXML: parse_string, root

function url2xml(url::String)
    r = rq(:GET, url)
    xml_string = parse_string(String(r.body))
    return root(xml_string)
end
