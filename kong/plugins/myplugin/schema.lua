local typedefs = require "kong.db.schema.typedefs"


local PLUGIN_NAME = "myplugin"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          -- a standard defined field (typedef), with some customizations
          { request_header = typedefs.header_name {
              description = "This is text field for request header",
              required = true,
              default = "Hello-World" } },
          { response_header = typedefs.header_name {
              description = "This is text field for response header",
              required = true,
              default = "Bye-World" } },
          { return_status = {
            description = "This is text field for return status",
            type = "integer",
            required = true,
            default = 200 } },
          { cookie_names = {
            description = "A list of cookie names that Kong will inspect to retrieve JWTs.",
            type = "set",
            elements = { type = "string" },
            default = {}
          }, },
          { ttl = { -- self defined field
              description = "Time To Leave field",
              type = "integer",
              default = 600,
              required = true,
              gt = 0, }}, -- adding a constraint for the value
        },
        entity_checks = {
          -- add some validation rules across fields
          -- the following is silly because it is always true, since they are both required
          { at_least_one_of = { "request_header", "response_header" }, },
          -- We specify that both header-names cannot be the same
          { distinct = { "request_header", "response_header"} },
        },
      },
    },
  },
}

return schema
