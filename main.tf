resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "Date" = {
                "type" = "string"
            },
            "Queue1" = {
                "type" = "string"
            },
            "Queue2" = {
                "type" = "string"
            },
            "Queue3" = {
                "type" = "string"
            },
            "Queue4" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "nOffered1" = {
                "type" = "integer"
            },
            "nOffered2" = {
                "type" = "integer"
            },
            "nOffered3" = {
                "type" = "integer"
            },
            "nOffered4" = {
                "type" = "integer"
            },
            "queue1" = {
                "type" = "string"
            },
            "queue2" = {
                "type" = "string"
            },
            "queue3" = {
                "type" = "string"
            },
            "queue4" = {
                "type" = "string"
            },
            "tAbandon1" = {
                "type" = "integer"
            },
            "tAbandon2" = {
                "type" = "integer"
            },
            "tAbandon3" = {
                "type" = "integer"
            },
            "tAbandon4" = {
                "type" = "integer"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "{\n \"interval\": \"$${input.Date}T07:30:00.000Z/$${input.Date}T23:30:00.000Z\",\n \"groupBy\": [\n  \"queueId\"\n ],\n \"filter\": {\n  \"type\": \"and\",\n  \"clauses\": [\n   {\n    \"type\": \"or\",\n    \"predicates\": [\n     {\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$${input.Queue1}\"\n    }\n#if(\"$!{input.Queue2}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue2}\"\n    }\n#end\n#if(\"$!{input.Queue3}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue3}\"\n    }\n#end\n#if(\"$!{input.Queue4}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue4}\"\n    }\n#end\n    ]\n   }\n  ],\n  \"predicates\": [\n   {\n    \"type\": \"dimension\",\n    \"dimension\": \"mediaType\",\n    \"operator\": \"matches\",\n    \"value\": \"voice\"\n   }\n  ]\n },\n \"views\": [],\n \"metrics\": [\n  \"nOffered\",\n  \"tAbandon\"\n ]\n}"
        request_type         = "POST"
        request_url_template = "/api/v2/analytics/conversations/aggregates/query"
    }

    config_response {
        success_template = "{\"queue1\": $${queue1}, \"queue2\": $${queue2}, \"queue3\": $${queue3}, \"queue4\": $${queue4}, \"nOffered1\": $${nOffered1}, \"nOffered2\": $${nOffered2}, \"nOffered3\": $${nOffered3}, \"nOffered4\": $${nOffered4}, \"tAbandon1\": $${tAbandon1}, \"tAbandon2\": $${tAbandon2}, \"tAbandon3\": $${tAbandon3}, \"tAbandon4\": $${tAbandon4}}"
        translation_map = { 
			tAbandon1 = "$.results[0].data[0].metrics[1].stats.count"
			tAbandon2 = "$.results[1].data[0].metrics[1].stats.count"
			tAbandon3 = "$.results[2].data[0].metrics[1].stats.count"
			tAbandon4 = "$.results[3].data[0].metrics[1].stats.count"
			queue1 = "$.results[0].group.queueId"
			nOffered4 = "$.results[3].data[0].metrics[0].stats.count"
			queue2 = "$.results[1].group.queueId"
			nOffered3 = "$.results[2].data[0].metrics[0].stats.count"
			queue3 = "$.results[2].group.queueId"
			nOffered2 = "$.results[1].data[0].metrics[0].stats.count"
			queue4 = "$.results[3].group.queueId"
			nOffered1 = "$.results[0].data[0].metrics[0].stats.count"
		}
        translation_map_defaults = {       
			tAbandon1 = "0"
			tAbandon2 = "0"
			tAbandon3 = "0"
			tAbandon4 = "0"
			queue1 = "\"Error\""
			nOffered4 = "0"
			queue2 = "\"Error\""
			nOffered3 = "0"
			queue3 = "\"Error\""
			nOffered2 = "0"
			queue4 = "\"Error\""
			nOffered1 = "0"
		}
    }
}