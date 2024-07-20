import gleam/io
import gleam/string
import wechat/object.{type JsObject}

fn on_launch(o: JsObject) -> Nil {
  o
  |> object.stringify
  |> string.append("gleam app launched: ", _)
  |> io.println
}

fn on_show(_o: JsObject) -> Nil {
  Nil
}

pub fn app() -> JsObject {
  object.literal([#("onLaunch", on_launch), #("onShow", on_show)])
  |> object.set("data", object.new())
}
