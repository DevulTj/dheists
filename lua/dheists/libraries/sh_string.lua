
string.DEFAULT_CURRENCY = "$"

local function attachCurrency( str, currency )
    return ( currency or string.DEFAULT_CURRENCY or "$" ) .. str
end

function string.formatMoney( amount, currency )
    if not amount then return attachCurrency( "0", currency ) end

    if amount >= 1e14 then return attachCurrency( tostring( amount ), currency ) end
    if amount <= -1e14 then return "-" .. attachCurrency( tostring( math.abs( amount ) ), currency ) end

    local negative = amount < 0

    amount = tostring( math.abs( amount ) )
    local sep = sep or ","
    local dp = string.find( amount, "%." ) or #amount + 1

    for i = dp - 4, 1, -3 do
        amount = amount:sub( 1, i ) .. sep .. amount:sub( i + 1 )
    end

    return ( negative and "-" or "" ) .. attachCurrency( amount, currency )
end

getmetatable("").__mod = function(s, tab) return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end)) end
