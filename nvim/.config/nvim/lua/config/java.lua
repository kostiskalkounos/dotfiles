local M = {}

local version_cache = {}

local function read_version_from_file(filename, patterns, transform)
  local cache_key = filename
  if version_cache[cache_key] then
    return version_cache[cache_key]
  end

  local path = vim.fn.findfile(filename, vim.fn.getcwd() .. ";")
  if path == "" then
    return nil
  end

  local content = table.concat(vim.fn.readfile(path), "\n")

  for _, pattern in ipairs(patterns) do
    local version = content:match(pattern)
    if version then
      local result = transform and transform(version) or version
      version_cache[cache_key] = result
      return result
    end
  end

  version_cache[cache_key] = nil
  return nil
end

local version_patterns = {
  ["pom.xml"] = {
    patterns = {
      "<java%.version>(%d+)</java%.version>",
      "<maven%.compiler%.source>(%d+)</maven%.compiler%.source>",
    },
  },
  ["build.gradle"] = {
    patterns = {
      "sourceCompatibility%s*=%s*['\"]?(1%.%d+)['\"]?",
      "sourceCompatibility%s*=%s*['\"]?(%d+)['\"]?",
    },
    transform = function(v)
      return v:gsub("1%.", "")
    end,
  },
}

function M.getJavaVersion()
  local cwd = vim.fn.getcwd()
  if version_cache[cwd] then
    return version_cache[cwd]
  end

  for filename, config in pairs(version_patterns) do
    local version = read_version_from_file(filename, config.patterns, config.transform)
    if version then
      version_cache[cwd] = version
      return version
    end
  end

  return nil
end

function M.clearCache()
  version_cache = {}
end

return M
