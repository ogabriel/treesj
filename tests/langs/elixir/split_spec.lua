local tu = require('tests.utils')

local PATH = './tests/sample/index.ex'
local LANG = 'elixir'
local MODE = 'split'

local data = {
  {
    path = PATH,
    mode = MODE,
    lang = LANG,
    desc = 'lang "%s", node "list", preset default',
    cursor = { 2, 15 },
    expected = { 4, 10 },
    result = { 1, 7 },
  },
  {
    path = PATH,
    mode = MODE,
    lang = LANG,
    desc = 'lang "%s", node "map", preset default',
    cursor = { 13, 15 },
    expected = { 15, 20 },
    result = { 18, 23 },
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
