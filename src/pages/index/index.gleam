import wechat/object.{type JsObject}

fn on_load(_o: JsObject) -> Nil {
  Nil
}

fn on_show() -> Nil {
  Nil
}

fn on_ready() -> Nil {
  Nil
}

pub fn page() -> JsObject {
  object.literal([
    #("onLoad", on_load),
  ])
  |> object.merge(object.literal([
        #("onShow", on_show),
        #("onReady", on_ready),
     ]))
  |> object.set("data", object.new())
}
