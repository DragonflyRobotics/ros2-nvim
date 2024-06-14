local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function listROSTopics()  
  local topics = {}
  local handle = io.popen("ros2 topic list")
  for topic in handle:lines() do
    table.insert(topics, topic)
  end
  handle:close()
  return topics
end

local function getROSTopicInfo(topic)
  local info = ""
  local handle = io.popen("ros2 topic info " .. topic)
  info = handle:read("*a")
  handle:close()
  return info
end

local function getROSTopicEchoOnce(topic)
  local info = ""
  local handle = io.popen("ros2 topic echo " .. topic .. " --once")
  info = handle:read("*l")
  handle:close()
  return info
end


-- Function to open a new terminal buffer with fd piped to fzf
local function commandInBuf(cmd)
    -- Create a new terminal buffer
    local bufnr = vim.api.nvim_create_buf(false, true)

    -- Open a new split with a terminal running the command
    -- vim.api.nvim_command("split")
    -- vim.api.nvim_command("wincmd j") -- Move to the newly created split
    vim.api.nvim_command("term " .. cmd)
end


local function topic_telescope()
    topics = listROSTopics()
    local options = {}

    for i, topic in ipairs(topics) do
        local description = getROSTopicInfo(topic)
        local description_lines = {}
        for line in description:gmatch("[^\r\n]+") do
            table.insert(description_lines, line)
        end
        table.insert(options, { display = topic, description = description_lines })
    end

    local function make_display(entry)
        return(entry.value.display)
    end

    local function previewer_maker(entry, bufnr)
        -- Clear existing buffer content
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
        -- Set new lines from description
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, entry.value.description)
    end

    pickers.new({}, {
        prompt_title = "Select an Option",
        finder = finders.new_table({
            results = options,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    ordinal = entry.display,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                previewer_maker(entry, self.state.bufnr)
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = action_state.get_selected_entry(prompt_bufnr)
                local text = selection.value.display
                actions.close(prompt_bufnr)
                commandInBuf("ros2 topic echo " .. text)
            end)
            return true
        end,
    }):find()
end


return {
    topic_telescope = topic_telescope
}
