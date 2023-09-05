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
    cursor = { 7, 3 },
    expected = { 1, 2 },
    result = { 1, 2 },
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
