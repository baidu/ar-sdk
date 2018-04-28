function LOAD_HTML()
	Html = {
		__call = function (self,entity)
			local html = {
				_entity = nil,
			}
			html._entity = entity

			html.load_html = function(self, url, width, height)
			
				local texture_id = self._entity:get_texture_id('uHtmlTexture')
				local mapData = ae.MapData:new()
				mapData:put_int("id", MSG_TYPE_HTML_OPERATION)
				mapData:put_int("operation", HtmlOperation.htmlLoad)
				mapData:put_int("texture_id", texture_id)
				mapData:put_int('width', width)
				mapData:put_int('height', height)
				mapData:put_string("url", url)

				Html.htmlDict[texture_id] = self

				AR.current_application.lua_handler:send_message_tosdk(mapData)
				mapData:delete()

				return self
			end

			html.update_model = function(self, model_name, attribute_name, value)
				local mapData = ae.MapData:new()
				local texture_id = self._entity:get_texture_id('uHtmlTexture')
				mapData:put_int("id", MSG_TYPE_HTML_OPERATION)
				mapData:put_int("texture_id", texture_id)
				mapData:put_int("operation", HtmlOperation.modelUpdate)
				mapData:put_string("model_name", model_name)
				mapData:put_string("attribute_name", attribute_name)
				mapData:put_string("value", value)
				AR.current_application.lua_handler:send_message_tosdk(mapData)
				mapData:delete()
				
				return self
			end

			return html
		end,

		htmlLoaded = function(self, texture_id)
			local html = self.htmlDict[texture_id]
			if html ~= nil then
				html._entity._html_need_update = true
			end
		end,

		htmlDict = {}
	}
	setmetatable(Html,Html)
	ARLOG('load html')
end
LOAD_HTML()


