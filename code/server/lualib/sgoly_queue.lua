
--[[
 * @brief: queue.lua

 * @author:	  kun si
 * @date:	2016-12-19
--]]

local queue = {}

function queue.new(maxLen)
	if maxLen ~= nil and type(maxLen) == "number" and maxLen > 0 then
		return {first = 0, last = -1, maxLen = maxLen}
	else
		return {first = 0, last = -1}
	end
end

function queue.push(q, value)
	if queue.isFull(q) then
		return -1
	else
		local last = q.last + 1
		q.last = last
		q[last] = value
		return 0
	end
end

function queue.pop(q)
	if queue.isEmpty(q) then
		return -1
	else
		local value = q[q.first]
		q[q.first] = nil
		q.first = q.first + 1
		return value
	end
end

function queue.isFull(q)
	if(q.last - q.first) == (q.maxLen - 1) then
		return true
	else
		return false
	end
end

function queue.isEmpty(q)
	if q.first > q.last then
		return true
	else
		return false
	end
end

function queue.getLen(q)
	return q.last - q.first + 1
end

function queue.getMaxLen(q)
	if q.maxLen then
		return q.maxLen
	else
		return nil
	end
end
function queue.setMaxLen(q, maxLen)
	q.maxLen = maxLen
end

return queue