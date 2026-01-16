vim.treesitter.query.set(
  "yaml",
  "GraphQL_endpoints",
  [[
        (document (block_node (block_mapping (block_mapping_pair
            value: (block_node (block_mapping (block_mapping_pair
                value: (block_node (block_mapping (block_mapping_pair
                    value: (block_node (block_mapping (block_mapping_pair
                        key: (flow_node) @mutation
                        value: (block_node (block_mapping (block_mapping_pair
                             key: (flow_node) @resolve (#eq? @resolve "resolve")
                             value: (flow_node) @resolver
                         )))
                    )))
                )))
            )))
        ))))
    ]]
)
