function LOAD_WEBVIEW()
	WebView = {
		__call = function (self,entity)
			local webview = {
				_entity = nil,
				_url = "",
				_width = 0,
				_height = 0,
				_is_remote = 0,
				_webview_id = -1,

				url = function (self,string)
					self._url = string
					return self
				end,

				is_remote = function (self,value)
					self._is_remote = value
					return self
				end,

				width = function (self,value)
					ARLOG('load width:'..value)
					self._width = value
					return self
				end,

				height = function (self,value)
					self._height = value
					return self
				end,

				load = function (self)
					ARLOG('webview load:')
					local texture_id = self._entity:get_texture_id('uWebViewTexture')
					local mapData = ae.MapData:new()
					ARLOG('webview send_message_tosdk:'..texture_id)
					mapData:put_int("id", MSG_TYPE_WEBVIEW_OPERATION)
					mapData:put_int("operation", WebViewOperation.WebViewLoad)
					mapData:put_int("texture_id", texture_id)
					mapData:put_int('width', self._width)
					mapData:put_int('height', self._height)
					mapData:put_int('is_remote', self._is_remote)
					mapData:put_string("url", self._url)
					WebView.WebViewDict[texture_id] = self
					AR.current_application.lua_handler:send_message_tosdk(mapData)
                    mapData:delete()

					return self
				end,

			}

			webview._entity = entity
			
			webview.update_js = function(self,value)
				local mapData = ae.MapData:new()
				local texture_id = self._entity:get_texture_id('uWebViewTexture')
				mapData:put_int("id", MSG_TYPE_WEBVIEW_OPERATION)
				mapData:put_int("texture_id", texture_id)
				mapData:put_int("operation", WebViewOperation.ModelUpdate)
				mapData:put_string("js_code", value)
				AR.current_application.lua_handler:send_message_tosdk(mapData)
                mapData:delete()

				return self
			end

			webview.update_texture = function(self) 
				local texture_id = self._entity:get_texture_id('uWebViewTexture')
				ARLOG('WebView update_texture:'..texture_id)
				self._entity:update_webview_texture(texture_id)
				return self
			end

			webview.on_load_finish = function(self)
				self:update_texture()
			end

            webview.on_load_error = function(self)
                local texture_id = self._entity:get_texture_id('uWebViewTexture')
                ARLOG('WebView on_load_error texture_id:'..texture_id)
            end

			return webview
		end,

		WebViewDict = {}
	}
	
	setmetatable(WebView,WebView)

	function updateFinish(event)
		texture_id = event.data['texture_id']
		ARLOG('WebView WebViewUpdateFinished'..texture_id)
		local webview = WebView.WebViewDict[texture_id]
		if WebView ~= nil then
			ARLOG('WebView on_loal_finish:'..texture_id)
			webview:update_texture()
		end
	end

	function loadFinshed(event)
		texture_id = event.data['texture_id']
		ARLOG('WebView WebViewLoaded:'..texture_id)
		local webview = WebView.WebViewDict[texture_id]
		if WebView ~= nil then
			ARLOG('WebView on_loal_finish:'..texture_id)
			webview:on_load_finish()
		end
	end

	function loadfailed(event)
		texture_id = event.data['texture_id']
		ARLOG('WebView WebViewLoadError'..texture_id)
		local webview = WebView.WebViewDict[texture_id]
		if WebView ~= nil then
			ARLOG('WebView on_loal_finish:'..texture_id)
			webview:on_load_error(msg)
		end
	end

	Event:addEventListener("webView_operation_load_finish", loadFinshed)
	Event:addEventListener("webView_operation_load_failed", loadfailed)
	Event:addEventListener("webView_operation_update_finish", updateFinish)

	ARLOG('load WebView')
end
LOAD_WEBVIEW()
