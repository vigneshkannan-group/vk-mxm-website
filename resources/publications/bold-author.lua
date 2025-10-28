-- bold-author.lua
-- Bold a specific author in all bibliography entries after rendering

local my_name = "Kannan, V."  -- exactly as in your BibTeX

-- recursive function to process all inlines
function bold_name(inlines)
  for i, el in ipairs(inlines) do
    if el.t == "Str" then
      -- check if the name appears inside the string
      local s = el.text
      local pattern = my_name:gsub("([^%w])","%%%1")  -- escape special characters
      if s:match(pattern) then
        -- replace exact match with bold
        inlines[i] = pandoc.Strong(pandoc.Str(s))
      end
    elseif el.t == "Emph" or el.t == "Strong" or el.t == "Span" then
      -- recursively process nested inlines
      el.content = bold_name(el.content)
    end
  end
  return inlines
end

function Div(div)
  -- check for bibliography div
  if div.identifier == "refs" then
    for _, block in ipairs(div.content) do
      if block.t == "Para" then
        block.content = bold_name(block.content)
      end
    end
  end
  return div
end
