local function getTableName(srcLayer, layers)
    for tableName in pairs(layers) do
	local match = tableName:match(srcLayer .. "%-to%-%a+")
	if match then return match end
    end
    return nil
end


local function getSuffix(tableName)
    return tableName:match("%a+$")
end

return {
    getTableName = getTableName,
    getSuffix = getSuffix
}
