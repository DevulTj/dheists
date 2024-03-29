
local version = 3

if i18n and i18n.VERSION >= version then return end

i18n = {
    VERSION = version,
    AUTHOR = "fruitwasp",
    AUTHOR_URL = "https://steamcommunity.com/id/fruitwasp",

    IDENTIFIER = "i18n"
}

local selectedLanguage = CreateConVar( "i18n_language", "" )
local gameLanguage = GetConVar( "gmod_language" )

local _phrases = {}

function i18n.registerPhrase( languageId, phraseId, phrase )
    _phrases[ languageId ] = _phrases[ languageId ] or {}
    _phrases[ languageId ][ phraseId ] = phrase
end

function i18n.registerPhrases( languageId, phrases )
    for phraseId, phrase in pairs( phrases ) do
        i18n.registerPhrase( languageId, phraseId, phrase )
    end
end

function i18n.getPhrase( identifier, ... )
    local phrases =
        _phrases[ selectedLanguage:GetString() ] 
        or _phrases[ gameLanguage:GetString() ] 
        or _phrases.en

    if not phrases or not phrases[ identifier ] then
        if not _phrases.en or not _phrases.en[ identifier ] then return identifier end

        return string.format( _phrases.en[ identifier ], ... )
    end

    return string.format( phrases[ identifier ], ... )
end