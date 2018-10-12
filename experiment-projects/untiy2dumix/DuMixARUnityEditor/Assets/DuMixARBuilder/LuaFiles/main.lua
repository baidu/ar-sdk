-- app: 全局Application对象
-- scene: 全局Scene对象

app.on_loading_finish = function()
    EDLOG('资源包加载完成后回调,相当于主函数')
    unityInit();
    scene.Iron.on_click = function ( )
    	scene.Iron:set_visible(false)
    end
end