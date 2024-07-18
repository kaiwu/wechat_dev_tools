import gleam/io
import gleam/string
import wechat/object.{type JsObject}
import app/pages/index/index
import app/components/basic/basic

pub fn exports() -> JsObject {
  object.literal([
    #("index.page", index.page),
    #("basic.component", basic.component),
  ])
} 

fn on_launch(o: JsObject) -> Nil {
  o |> object.stringify |> string.append("gleam app: ", _) |> io.println
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

