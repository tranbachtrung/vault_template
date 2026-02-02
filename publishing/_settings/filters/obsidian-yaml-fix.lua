-- obsidian-yaml-fix.lua
-- Fixes Obsidian YAML frontmatter issues in-memory during Quarto render
-- Does NOT modify source files

function Meta(meta)
  -- Fix empty aliases field
  if meta.aliases == nil then
    meta.aliases = pandoc.List({})
  end

  return meta
end

-- Remove leading blank paragraphs/spaces after YAML frontmatter is stripped
function Pandoc(doc)
  -- Remove leading empty blocks (paragraphs with only spaces/newlines)
  while #doc.blocks > 0 do
    local first = doc.blocks[1]
    
    -- Check if first block is an empty paragraph
    if first.t == "Para" and #first.content == 0 then
      table.remove(doc.blocks, 1)
    -- Check if first block is a paragraph with only spaces
    elseif first.t == "Para" then
      local only_spaces = true
      for _, inline in ipairs(first.content) do
        if inline.t ~= "Space" and inline.t ~= "SoftBreak" and inline.t ~= "LineBreak" then
          if inline.t == "Str" and inline.text:match("^%s*$") then
            -- It's a string with only whitespace, continue
          else
            only_spaces = false
            break
          end
        end
      end
      if only_spaces then
        table.remove(doc.blocks, 1)
      else
        break
      end
    else
      break
    end
  end
  
  return doc
end
