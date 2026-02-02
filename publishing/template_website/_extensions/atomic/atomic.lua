-- atomic.lua
-- Custom shortcode for including Obsidian atomic notes in Quarto
-- Features:
--   1. Strips YAML frontmatter from included files
--   2. Supports sectional inclusion with #section-header
--   3. Handles paths with spaces

-- Helper function to read file content
local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil, "Could not open file: " .. path
  end
  local content = file:read("*all")
  file:close()
  return content
end

-- Helper function to convert wikilinks to plain text
local function convert_wikilinks(content)
  -- Convert [[link|alias]] to alias
  content = content:gsub("%[%[([^%]|]+)|([^%]]+)%]%]", "%2")
  -- Convert [[link]] to link
  content = content:gsub("%[%[([^%]]+)%]%]", "%1")
  return content
end

-- Helper to compile TikZ to SVG
local system = require 'pandoc.system'

local function compile_tikz_to_svg(code)
  -- Clean up the code
  code = code:gsub("\\begin{document}%s*\n?", "")
  code = code:gsub("\n?%s*\\end{document}", "")
  code = code:gsub("\\documentclass[^\n]*\n?", "")
  code = code:gsub("^%s+", ""):gsub("%s+$", "")

  -- Generate hash for caching
  local hash = 0
  for i = 1, #code do
    hash = (hash * 31 + string.byte(code, i)) % 2147483647
  end
  local basename = "tikz-" .. tostring(hash)

  return system.with_temporary_directory("tikz", function(tmpdir)
    return system.with_working_directory(tmpdir, function()
      -- Create LaTeX file
      local tex_content = [[
\documentclass[tikz]{standalone}
\begin{document}
]] .. code .. [[

\end{document}
]]
      local tex_file = basename .. ".tex"
      local pdf_file = basename .. ".pdf"
      local svg_file = basename .. ".svg"

      local fh = io.open(tex_file, 'w')
      fh:write(tex_content)
      fh:close()

      -- Compile with pdflatex
      local success = os.execute('pdflatex -interaction=nonstopmode ' .. tex_file .. ' > /dev/null 2>&1')
      if not success then
        return nil, "pdflatex failed"
      end

      -- Convert to SVG with inkscape
      local inkscape_cmd = 'inkscape'
      if os.execute('test -x /Applications/Inkscape.app/Contents/MacOS/inkscape 2>/dev/null') then
        inkscape_cmd = '/Applications/Inkscape.app/Contents/MacOS/inkscape'
      end

      success = os.execute(inkscape_cmd .. ' --export-type=svg --export-plain-svg --export-filename=' .. svg_file .. ' ' .. pdf_file .. ' 2>/dev/null')
      if not success then
        return nil, "inkscape failed"
      end

      -- Read SVG
      local svg_fh = io.open(svg_file, 'r')
      if not svg_fh then
        return nil, "failed to read SVG"
      end
      local svg_data = svg_fh:read('*a')
      svg_fh:close()

      return svg_data, basename
    end)
  end)
end

-- Helper function to process TikZ code blocks in raw content
local function process_tikz_content(content)
  -- Pattern to match ```tikz ... ``` blocks and compile them
  local pattern = "```tikz\n(.-)\n```"
  return content:gsub(pattern, function(code)
    local svg_data, result = compile_tikz_to_svg(code)
    if svg_data then
      -- Store in mediabag and return simple image markdown
      local fname = result .. ".svg"
      pandoc.mediabag.insert(fname, 'image/svg+xml', svg_data)
      return "![](" .. fname .. ")"
    else
      -- Return error message
      return "<!-- TikZ compilation error: " .. (result or "unknown") .. " -->\n```tikz\n" .. code .. "\n```"
    end
  end)
end

-- Helper function to strip YAML frontmatter
local function strip_yaml_frontmatter(content)
  -- Check if content starts with YAML frontmatter (---)
  if content:match("^%-%-%-[\r\n]") then
    -- Find the closing --- on its own line
    -- We need to find the second occurrence of --- at the start of a line
    local first_newline = content:find("[\r\n]")
    if first_newline then
      local rest = content:sub(first_newline)
      local close_pattern = "[\r\n]%-%-%-[\r\n]"
      local close_start, close_end = rest:find(close_pattern)
      if close_start then
        -- Return everything after the closing ---, trimming leading whitespace/newlines
        local result = rest:sub(close_end)
        -- Remove leading blank lines and whitespace
        result = result:gsub("^%s*\n+", "")
        return result
      end
    end
  end
  return content
end

-- Helper function to extract a section from content
-- section_header can be like "#section" or "## Section Name" or "### Definition ([[Kal2021]], pg. 10)"
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

-- Helper function to resolve relative path
local function resolve_path(base_path, relative_path)
  -- Get directory of the current file
  local dir = base_path:match("(.*/)")
  if not dir then
    dir = "./"
  end

  -- Handle ../ in the relative path
  local path = relative_path
  while path:match("^%.%./") do
    path = path:gsub("^%.%./", "")
    dir = dir:gsub("[^/]+/$", "")
  end

  -- Handle ./ in the relative path
  path = path:gsub("^%./", "")

  return dir .. path
end

-- Main shortcode function
return {
  ["atomic"] = function(args, kwargs, meta, raw_args)
    -- Parse raw_args to handle paths with spaces and section specifiers
    -- Format: {{< atomic path/to/file.md >}}
    -- Or:     {{< atomic path/to/file.md #section >}}
    -- Or:     {{< atomic path/to/file.md ## Section Name >}}

    local raw = table.concat(args, " ")

    -- Try to extract section specifier (starts with #)
    local file_path, section_spec

    -- Check for section specifier patterns
    -- Pattern 1: "file.md ### Section Header"
    -- Pattern 2: "file.md ## Section Header"
    -- Pattern 3: "file.md # Section Header"
    -- Pattern 4: "file.md #section" (simple anchor)

    local section_match = raw:match("(.+%.md)%s+(###?#?%s*.+)$")
    if section_match then
      file_path = raw:match("(.+%.md)")
      section_spec = raw:match("%.md%s+(###?#?%s*.+)$")
    else
      -- No section specifier, just the path
      file_path = raw:gsub("%s+$", "")  -- Trim trailing whitespace
      section_spec = nil
    end

    -- Trim whitespace from path
    file_path = file_path:gsub("^%s+", ""):gsub("%s+$", "")

    -- Get the input file path for resolving relative paths
    local input_file = quarto.doc.input_file
    local resolved_path = resolve_path(input_file, file_path)

    -- Read the file
    local content, err = read_file(resolved_path)
    if not content then
      return pandoc.RawBlock("markdown", "<!-- " .. err .. " -->")
    end

    -- Strip YAML frontmatter
    content = strip_yaml_frontmatter(content)

    -- Extract section if specified
    if section_spec then
      content = extract_section(content, section_spec)
    end

    -- Convert wikilinks to plain text
    content = convert_wikilinks(content)

    -- Process TikZ blocks to convert Obsidian format to Quarto format
    content = process_tikz_content(content)

    -- Parse the content and return blocks
    local doc = pandoc.read(content, "markdown+fenced_code_blocks+fenced_code_attributes")
    return doc.blocks
  end
}
