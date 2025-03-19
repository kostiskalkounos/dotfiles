local M = {}

function M.getJavaVersion()
  local pom_path = vim.fn.findfile("pom.xml", vim.fn.getcwd() .. ";")
  if pom_path ~= "" then
    local pom_content = vim.fn.readfile(pom_path)
    for _, line in ipairs(pom_content) do
      local version = line:match("<java%.version>(%d+)</java%.version>")
        or line:match("<maven%.compiler%.source>(%d+)</maven%.compiler%.source>")
      if version then
        return version
      end
    end
  end

  local gradle_path = vim.fn.findfile("build.gradle", vim.fn.getcwd() .. ";")
  if gradle_path ~= "" then
    local gradle_content = vim.fn.readfile(gradle_path)
    for _, line in ipairs(gradle_content) do
      local version = line:match("sourceCompatibility%s*=%s*['\"]?(1%.%d+)['\"]?")
        or line:match("sourceCompatibility%s*=%s*['\"]?(%d+)['\"]?")
      if version then
        return version:gsub("1%.", "")
      end
    end
  end

  return nil
end

return M
