import wechat/object.{type JsObject}

fn on_launch(_o: JsObject) -> Nil {
  Nil
}

fn on_show(_o: JsObject) -> Nil {
  Nil
}

pub fn app() -> JsObject {
  object.literal([
    #("onLaunch", on_launch),
    #("onShow", on_show),
  ])
  |> object.set("data", object.new())
}

