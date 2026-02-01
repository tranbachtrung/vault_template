-- obsidian-wikilinks.lua
-- Converts Obsidian [[wikilinks]] to standard markdown links
-- Does NOT modify source files - only transforms in-memory AST during render

-- Process a complete wikilink string and return Link element
local function make_link(target, display)
  if not display or display == "" then
    display = target
  end
  local url_target = target:gsub(" ", "%%20") .. ".md"
  return pandoc.Link(display, url_target)
end

-- Parse a string that may contain wikilinks and return list of inlines
local function parse_text_with_wikilinks(text)
  local result = pandoc.List()
  local pos = 1

  while pos <= #text do
    local start_pos = text:find("%[%[", pos)

    if start_pos then
      -- Add text before wikilink
      if start_pos > pos then
        result:insert(pandoc.Str(text:sub(pos, start_pos - 1)))
      end

      -- Find end of wikilink
      local end_pos = text:find("%]%]", start_pos)

      if end_pos then
        local content = text:sub(start_pos + 2, end_pos - 1)
        local pipe_pos = content:find("|")
        local target, display
        if pipe_pos then
          target = content:sub(1, pipe_pos - 1)
          display = content:sub(pipe_pos + 1)
        else
          target = content
          display = content
        end
        result:insert(make_link(target, display))
        pos = end_pos + 2
      else
        result:insert(pandoc.Str(text:sub(start_pos)))
        break
      end
    else
      if pos <= #text then
        result:insert(pandoc.Str(text:sub(pos)))
      end
      break
    end
  end

  return result
end

-- Main filter: process all Str elements
function Str(el)
  local text = el.text

  -- Check if this string contains a complete wikilink
  if text:match("%[%[.-%]%]") then
    return parse_text_with_wikilinks(text)
  end

  return el
end

-- Process inline sequences to catch wikilinks split across elements
function Inlines(inlines)
  local result = pandoc.List()
  local buffer = ""
  local buffering = false

  for i, el in ipairs(inlines) do
    if el.t == "Str" then
      local text = el.text

      if buffering then
        buffer = buffer .. text
        if text:match("%]%]") then
          -- End of wikilink found
          local parsed = parse_text_with_wikilinks(buffer)
          for _, item in ipairs(parsed) do
            result:insert(item)
          end
          buffer = ""
          buffering = false
        end
      elseif text:match("%[%[") and not text:match("%]%]") then
        -- Start of split wikilink
        buffer = text
        buffering = true
      elseif text:match("%[%[.-%]%]") then
        -- Complete wikilink(s) in single element
        local parsed = parse_text_with_wikilinks(text)
        for _, item in ipairs(parsed) do
          result:insert(item)
        end
      else
        result:insert(el)
      end
    elseif buffering then
      if el.t == "Space" then
        buffer = buffer .. " "
      elseif el.t == "SoftBreak" then
        buffer = buffer .. " "
      else
        -- Non-text element breaks the wikilink, flush buffer
        result:insert(pandoc.Str(buffer))
        result:insert(el)
        buffer = ""
        buffering = false
      end
    else
      result:insert(el)
    end
  end

  -- Flush any remaining buffer
  if buffer ~= "" then
    result:insert(pandoc.Str(buffer))
  end

  return result
end
