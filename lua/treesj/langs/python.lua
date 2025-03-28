local lang_utils = require('treesj.langs.utils')

local no_space_in_brackets = lang_utils.set_preset_for_list({
  join = {
    space_in_brackets = false,
  },
})

return {
  dictionary = no_space_in_brackets,
  list = no_space_in_brackets,
  set = no_space_in_brackets,
  pattern_list = lang_utils.set_preset_for_args({
    split = {
      last_separator = false,
      format_tree = function(tsj)
        tsj:create_child({ text = '(' }, 1)
        tsj:create_child({ text = ')' }, #tsj:children() + 1)
        local penult = tsj:child(-2)
        if penult:text():sub(-1) == ',' then
          tsj.remove_child(penult)
        else
          local antepenult = tsj:child(-3)
          antepenult:update_text(antepenult:text() .. ',')
          penult:update_text(penult:text() .. ',')
        end
      end,
      format_resulted_lines = function(lines)
        lines[1] = lines[1]:gsub(',$', '')
        return lines
      end,
    },
    join = {
      format_tree = function(tsj)
        tsj:remove_child({ '(', ')' })
        local penult = tsj:child(-2)
        penult:update_text(penult:text() .. ', ')
      end,
    },
  }),
  tuple_pattern = lang_utils.set_preset_for_list({
    join = {
      space_in_brackets = true,
      last_separator = false,
      format_tree = function(tsj)
        if tsj:has_children({ '(', ')' }) then
          tsj:remove_child({ '(', ')' })
        end
      end,
    },
  }),
  tuple = lang_utils.set_preset_for_list({
    join = {
      space_in_brackets = false,
      last_separator = true,
    },
  }),
  import_from_statement = lang_utils.set_preset_for_args({
    both = {
      omit = { lang_utils.helpers.if_second, 'import', ' (' },
    },
    split = {
      last_separator = true,
      format_tree = function(tsj)
        if not tsj:has_children({ '(', ')' }) then
          tsj:create_child({ text = ' (' }, 4)
          tsj:create_child({ text = ')' }, #tsj:children() + 1)
          local penult = tsj:child(-2)
          penult:update_text(penult:text() .. ',')
        end
      end,
      format_resulted_lines = function(lines)
        lines[1] = lines[1]:gsub(',$', '')
        return lines
      end,
    },
    join = {
      format_tree = function(tsj)
        tsj:remove_child({ '(', ')' })
        local penult = tsj:child(-2)
        penult:update_text(penult:text() .. ' ')
      end,
    },
  }),
  argument_list = lang_utils.set_preset_for_args(),
  parameters = lang_utils.set_preset_for_args({
    split = { last_separator = true },
  }),
  parenthesized_expression = lang_utils.set_preset_for_args({}),
  list_comprehension = lang_utils.set_preset_for_args(),
  set_comprehension = lang_utils.set_preset_for_args(),
  dictionary_comprehension = lang_utils.set_preset_for_args(),
  assignment = {
    target_nodes = {
      'tuple',
      'list',
      'dictionary',
      'set',
      'argument_list',
      'list_comprehension',
      'set_comprehension',
      'dictionary_comprehension',
    },
  },
  decorator = {
    target_nodes = {
      'argument_list',
    },
  },
  raise_statement = {
    target_nodes = {
      'argument_list',
    },
  },
  call = {
    target_nodes = {
      'argument_list',
    },
  },
  function_definition = {
    target_nodes = { 'parameters' },
  },
}
