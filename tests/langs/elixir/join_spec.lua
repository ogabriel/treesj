local tu = require('tests.utils')

local PATH = './tests/sample/index.ex'
local LANG = 'elixir'
local MODE = 'join'

local data = {
  {
    path = PATH,
    mode = MODE,
    lang = LANG,
    desc = 'lang "%s", node "list", preset default',
    cursor = { 2, 17 },
    expected = { 4, 11 },
    result = { 1, 8 },
  },
}

local treesj = require('treesj')
local opts = {}
treesj.setup(opts)

describe('TreeSJ ' .. MODE:upper() .. ':', function()
  for _, value in ipairs(data) do
    tu._test_format(value, treesj)
  end
end)
