-- _filters/group-by-year.lua
-- Group bibliography entries under year headings (robust to different Pandoc AST shapes).

local stringify = pandoc.utils.stringify

local function has_class(el, class)
  if not el.classes then return false end
  for _, c in ipairs(el.classes) do
    if c == class then return true end
  end
  return false
end

local function collect_entries(div)
  local entries = {}
  for _, blk in ipairs(div.content) do
    if blk.t == "OrderedList" or blk.t == "BulletList" then
      for _, item in ipairs(blk.content) do
        -- each item is a list of blocks
        table.insert(entries, item)
      end
    else
      -- wrap single block into a list-of-blocks
      table.insert(entries, { blk })
    end
  end
  return entries
end

local function entry_text(entry_blocks)
  local s = ""
  for _, b in ipairs(entry_blocks) do
    s = s .. stringify(b) .. " "
  end
  return s
end

local function find_year_from_text(s)
  for yr in string.gmatch(s, "(%d%d%d%d)") do
    local n = tonumber(yr)
    if n and n >= 1900 and n <= 2099 then
      return tostring(n)
    end
  end
  return "Unknown"
end

function Div(el)
  if not has_class(el, "references") then
    return nil
  end

  local entries = collect_entries(el)
  if #entries == 0 then
    return nil
  end

  local by_year = {}
  local years = {}

  for _, entry in ipairs(entries) do
    local txt = entry_text(entry)
    local yr = find_year_from_text(txt)
    if not by_year[yr] then
      by_year[yr] = {}
      table.insert(years, yr)
    end
    table.insert(by_year[yr], entry)
  end

  table.sort(years, function(a,b)
    if a == b then return false end
    if a == "Unknown" then return false end
    if b == "Unknown" then return true end
    local na, nb = tonumber(a), tonumber(b)
    if na and nb then return na > nb end
    return a > b
  end)

  local blocks = {}
  for _, yr in ipairs(years) do
    table.insert(blocks, pandoc.Header(2, { pandoc.Str(yr) }))
    for _, entry in ipairs(by_year[yr]) do
      if #entry == 1 then
        table.insert(blocks, entry[1])
      else
        table.insert(blocks, pandoc.Div(entry))
      end
    end
  end

  local attr = pandoc.Attr("", {"references-by-year"}, {})
  return pandoc.Div(blocks, attr)
end
