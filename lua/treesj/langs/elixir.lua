local lang_utils = require('treesj.langs.utils')

return {
  do_block = lang_utils.set_preset_for_dict({
    join = {
      recursive = false,
      format_tree = function(tsj)
        --if has do and end, and if has only one line

        local parent = tsj:tsnode():parent():child(1):text()
        print(parent)

        --TODO: check if has only one line
        --TODO: also handle if else case
        if
          tsj:has_children({ 'do', 'end' })
          and tsj:tsnode():named_child_count() == 1
        then
          tsj:child('do'):update_text(', do:')
          tsj:child('end'):update_text('')
        end
      end,
    },
  }),
  list = lang_utils.set_preset_for_list({
    join = {
      space_in_brackets = false,
    },
    split = {
      recursive = false,
      last_separator = false,
    },
  }),
  map = { target_nodes = { 'map_content' } },
  map_content = lang_utils.set_preset_for_list({
    both = {
      non_bracket_node = true,
    },
    split = {
      last_separator = false,
      format_tree = function(tsj)
        if tsj:has_children({ 'keywords' }) then
          local keywords = tsj:child('keywords')
          keywords:update_preset({ inner_indent = 'normal' }, 'split')
          keywords:_format()
        end
      end,
    },
    join = {
      space_in_brackets = false,
    },
  }),
  keywords = lang_utils.set_preset_for_list({
    both = {
      non_bracket_node = true,
      -- This is only needed because for some reason join and split on a keyword
      -- where the value is certain types of term looks like:
      -- expected: 'key: %{ a: "b" }'
      -- result: 'key:%{ a: "b" }'
      format_tree = function(tsj)
        if tsj:has_children({ 'pair' }) then
          local pairs = tsj:children({ 'pair' })
          for _, pair in ipairs(pairs) do
            for keyword in pair:iter_children() do
              -- Grab the previous node which is the map key
              local map_key = keyword:prev()
              if map_key then
                -- Add an extra space to account for keyword + value quirkness
                local text = map_key:text():gsub(':$', ': ')
                map_key:update_text(text)
              end
            end
          end
        end
      end,
    },
    split = {
      --TODO: the split has to be handled at keywrod because of how the elixir treesitter works
      inner_indent = 'inner',
      last_separator = false,
      format_tree = function(tsj)
        local possible_do = tsj:children({ 'pair' }):key()
        print(possible_do:text())
        -- if tsj:has_children({ 'pair' }) then
        --   local pairs = tsj:children({ 'pair' })
        --   for _, pair in ipairs(pairs) do
        --     for keyword in pair:iter_children() do
        --       local keyword_text = keyword:text()
        --
        --       if string.find(keyword_text, 'do') then
        --         print(keyword_text)
        --       end
        --     end
        --   end
        -- end
      end,
    },
    join = {
      space_in_brackets = false,
    },
  }),
  arguments = lang_utils.set_preset_for_args(),
  tuple = lang_utils.set_preset_for_list({
    join = {
      space_in_brackets = false,
    },
    split = {
      recursive = false,
      last_separator = false,
    },
  }),
  binary_operator = {
    target_nodes = { 'list', 'map', 'tuple' },
  },
}
