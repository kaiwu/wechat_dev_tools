import wechat/object.{type JsObject}

import app/app
import app/pages/index/index
import app/components/basic/basic

pub type Constructor = fn() -> JsObject

pub fn app() -> Constructor {
  app.app
}

pub fn pages() -> List(#(String, Constructor)) {
  [#("index", index.page)]
}

pub fn components() -> List(#(String, Constructor)) {
  [#("basic", basic.component)]
}
