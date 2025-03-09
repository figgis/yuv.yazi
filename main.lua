local M = {}

function M:extract_dimensions(filename)
    -- Try to match the pattern "WIDTHxHEIGHT"
    local width, height = filename:match("(%d+)x(%d+)")

    if width and height then
        return width .. "x" .. height
    else
        -- If the first pattern doesn't match, look for resolution terms
        local resolution_patterns = {
            ["2160p"] = "3840x2160",
            ["1080p"] = "1920x1080",
            ["720p"] = "1280x720",
            ["576p"] = "1024x540",
            ["540p"] = "960x540",
            ["480p"] = "854x480",
            ["360p"] = "640x360",
            ["180p"] = "320x180",
            ["90p"] = "160x90"
        }

        for pattern, dimensions in pairs(resolution_patterns) do
            if filename:find(pattern) then
                return dimensions
            end
        end
    end

    -- Return nil if no pattern matches
    return nil
end

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		ya.mgr_emit("peek", {
			math.max(0, cx.active.preview.skip + job.units),
			only_if = job.file.url,
		})
	end
end

function M:preload(job)
	local percent = 5 + job.skip
	if percent > 95 then
		ya.mgr_emit("peek", { 90, only_if = job.file.url, upper_bound = true })
		return false
	end

	local cache = ya.file_cache(job)
	if not cache then
		return true
	end

	local cha = fs.cha(cache)
	if cha and cha.len > 0 then
		return true
	end

	local dim = M:extract_dimensions(tostring(job.file.url))
	if not dim then
	  return true, Err("Failed to get video dimensions!" .. tostring(job.file.url))
	end

	local qv = 31 - math.floor(rt.preview.image_quality * 0.3)
	-- stylua: ignore
	local status, err = Command("ffmpeg"):args({
		"-v", "quiet", "-threads", 1, 
		"-s", dim,
		"-i", tostring(job.file.url),
		"-vframes", 1,
		"-q:v", qv,
		"-vf", string.format("scale=-1:'min(%d,ih)':flags=fast_bilinear", rt.preview.max_height),
		"-f", "image2",
		"-y", tostring(cache),
	}):status()

	if status then
		return status.success
	else
		return true, Err("Failed to start `ffmpeg`, error: %s", err)
	end
end

return M
