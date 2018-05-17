-- 分步加载

function Load_BatchLoader()
    BatchLoader = {}
    BatchLoader.user_confirm_download = nil
    BatchLoader.user_refuse_download = nil

	BatchLoader.send_download_retry_msg = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", LOAD_STATUS_DOWNLOAD_RETRY_SHOWDIALOG)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
        mapData:delete()
	end

    BatchLoader.CallBack = function(mapData)
        local status = mapData['if_download']
        if (status == 1) then
            local batch_id = mapData['download_batchid']
            if(BatchLoader.user_confirm_download ~= nil) then
                BatchLoader.user_confirm_download(batch_id)
            end
        end

        if (status == 0) then
            local batch_id = mapData['download_batchid']
                if(BatchLoader.user_refuse_download ~= nil) then
                BatchLoader.user_refuse_download(batch_id)
            end
        end

    end
end

Load_BatchLoader()

