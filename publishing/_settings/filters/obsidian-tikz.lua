-- obsidian-tikz.lua
-- Converts Obsidian TikZJax syntax to Quarto tikz syntax
-- Does NOT modify source files - only transforms in-memory AST during render

function CodeBlock(el)
  -- Check if this is an Obsidian-style tikz block
  if el.classes[1] == "tikz" then
    local content = el.text

    -- Remove \begin{document} and \end{document} wrappers
    content = content:gsub("\\begin{document}%s*", "")
    content = content:gsub("%s*\\end{document}", "")

    -- Remove \documentclass if present
    content = content:gsub("\\documentclass[^}]*}%s*", "")

    -- Trim leading/trailing whitespace
    content = content:gsub("^%s+", ""):gsub("%s+$", "")

    -- Change class from "tikz" to ".tikz" for quarto_tikz extension
    el.classes = {"tikz"}
    el.text = content

    -- Add attributes that quarto_tikz expects
    if not el.attributes["filename"] then
      -- Generate a filename based on content hash to enable caching
      local hash = 0
      for i = 1, #content do
        hash = (hash * 31 + string.byte(content, i)) % 2147483647
      end
      el.attributes["filename"] = "tikz-" .. tostring(hash)
    end

    return el
  end

  return el
end
