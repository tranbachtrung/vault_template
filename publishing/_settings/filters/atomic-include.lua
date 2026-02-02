-- atomic-include.lua
-- Filter to include atomic notes with optional section extraction

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*all")
  file:close()
  return content
end

local function strip_yaml_frontmatter(content)
  if content:match("^%-%-%-[\r\n]") then
    local first_newline = content:find("[\r\n]")
    if first_newline then
      local rest = content:sub(first_newline)
      local close_pattern = "[\r\n]%-%-%-[\r\n]"
      local close_start, close_end = rest:find(close_pattern)
      if close_start then
        return rest:sub(close_end):gsub("^%s*\n+", "")
      end
    end
  end
  return content
end

local function convert_wikilinks(content)
  content = content:gsub("%[%[([^%]|]+)|([^%]]+)%]%]", "%2")
  content = content:gsub("%[%[([^%]]+)%]%]", "%1")
  return content
end

local function extract_section(content, section_spec)
  if not section_spec or section_spec == "" then
    return content
  end

  -- Parse section spec to get level and header text
  local level, header_text
  if section_spec:match("^###%s+") then
    level, header_text = 3, section_spec:gsub("^###%s+", "")
  elseif section_spec:match("^##%s+") then
    level, header_text = 2, section_spec:gsub("^##%s+", "")
  elseif section_spec:match("^#%s+") then
    level, header_text = 1, section_spec:gsub("^#%s+", "")
  else
    level, header_text = nil, section_spec:gsub("^#", "")
  end

  local escaped_header = header_text:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
  local lines = {}
  for line in content:gmatch("[^\r\n]*") do
    table.insert(lines, line)
  end

  local result_lines = {}
  local in_section = false
  local found_level = 0

  for _, line in ipairs(lines) do
    if not in_section then
      -- Look for the section header
      local line_level = line:match("^(#+)%s+") and #line:match("^(#+)%s+") or 0
      local line_text = line:gsub("^#+%s+", "")
      
      if line_level > 0 then
        local matches = level and (line_level == level and line_text:match(escaped_header))
                        or line_text:lower():match(escaped_header:lower())
        if matches then
          in_section = true
          found_level = line_level
          -- Skip the heading line itself
        end
      end
    else
      -- Check if we've hit the next section
      local line_level = line:match("^(#+)%s+") and #line:match("^(#+)%s+") or 0
      if line_level > 0 and line_level <= found_level then
        break
      end
      table.insert(result_lines, line)
    end
  end

  return #result_lines > 0 and table.concat(result_lines, "\n") 
         or "<!-- Section not found: " .. section_spec .. " -->"
end

local function resolve_path(base_path, relative_path)
  local dir = base_path:match("(.*/)")  or "./"
  local path = relative_path
  while path:match("^%.%./") do
    path = path:gsub("^%.%./", "")
    dir = dir:gsub("[^/]+/$", "")
  end
  return dir .. path:gsub("^%./", "")
end

function CodeBlock(block)
  if block.classes:includes("atomic-include") then
    local file_path = block.text
    local section_spec = block.attributes.section
    local input_file = quarto.doc.input_file
    local resolved_path = resolve_path(input_file, file_path)
    
    local content = read_file(resolved_path)
    if not content then
      return pandoc.Para{pandoc.Str("<!-- Could not read: " .. resolved_path .. " -->")}
    end
    
    content = strip_yaml_frontmatter(content)
    if section_spec then
      content = extract_section(content, section_spec)
    end
    content = convert_wikilinks(content)
    
    return pandoc.read(content, "markdown").blocks
  end
end
