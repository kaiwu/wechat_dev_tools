import bundle
import envoy
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/result
import gleam/string

@external(javascript, "./build_ffi.mjs", "bundle_build")
pub fn bundle_build(
  entry f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "js_build")
pub fn js_build(
  content c: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "copy_build")
pub fn copy_build(
  json f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "less_build")
pub fn less_build(
  less f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "bundle_watch")
pub fn bundle_watch(
  entry f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "js_watch")
pub fn js_watch(
  content c: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "copy_watch")
pub fn copy_watch(
  json f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "less_watch")
pub fn less_watch(
  less f: String,
  outfile o: String,
) -> Promise(Result(Nil, String))

const entry = "./build/dev/javascript/wechat_dev_tools/bundle.mjs"

const app_content = "import { app } from './bundle.mjs'; app()"

const dist = "./dist/"

const src = "./src/app/"

pub type Builder =
  fn(String, String) -> Promise(Result(Nil, String))

pub type Asset {
  Asset(src: String, dist: String, builder: Builder)
}

fn file_path(path: String, p: String, t: String) -> String {
  string.concat([path, p, "/", p, ".", t])
}

fn index_path(path: String, p: String, t: String) -> String {
  string.concat([path, p, "/", "index.", t])
}

fn page_content(p: String) -> String {
  string.concat([
    "import { pages, page } from '../../bundle.mjs'; page(pages(), \"",
    p,
    "\")",
  ])
}

fn component_content(p: String) -> String {
  string.concat([
    "import { components, component } from '../../bundle.mjs'; component(components(), \"",
    p,
    "\")",
  ])
}

fn bundle_asset(watch: Bool) -> List(Asset) {
  case watch {
    True -> [Asset(entry, dist <> "bundle.mjs.js", bundle_watch)]
    False -> [Asset(entry, dist <> "bundle.mjs.js", bundle_build)]
  }
}

fn app_assets(watch: Bool) -> List(Asset) {
  case watch {
    True -> [
      Asset(app_content, dist <> "app.js", js_watch),
      Asset(src <> "app.json", dist <> "app.json", copy_watch),
      Asset(src <> "app.less", dist <> "app.wxss", less_watch),
    ]
    False -> [
      Asset(app_content, dist <> "app.js", js_build),
      Asset(src <> "app.json", dist <> "app.json", copy_build),
      Asset(src <> "app.less", dist <> "app.wxss", less_build),
    ]
  }
}

fn page_assets(p: String, watch: Bool) -> List(Asset) {
  case watch {
    True -> [
      Asset(page_content(p), file_path(dist <> "/pages/", p, "js"), js_watch),
      Asset(
        file_path(src <> "pages/", p, "json"),
        file_path(dist <> "pages/", p, "json"),
        copy_watch,
      ),
      Asset(
        file_path(src <> "pages/", p, "wxml"),
        file_path(dist <> "pages/", p, "wxml"),
        copy_watch,
      ),
      Asset(
        file_path(src <> "pages/", p, "less"),
        file_path(dist <> "pages/", p, "wxss"),
        less_watch,
      ),
    ]
    False -> [
      Asset(page_content(p), file_path(dist <> "/pages/", p, "js"), js_build),
      Asset(
        file_path(src <> "pages/", p, "json"),
        file_path(dist <> "pages/", p, "json"),
        copy_build,
      ),
      Asset(
        file_path(src <> "pages/", p, "wxml"),
        file_path(dist <> "pages/", p, "wxml"),
        copy_build,
      ),
      Asset(
        file_path(src <> "pages/", p, "less"),
        file_path(dist <> "pages/", p, "wxss"),
        less_build,
      ),
    ]
  }
}

fn pages_assets(watch: Bool) -> List(Asset) {
  bundle.pages()
  |> list.map(fn(p) { p.0 })
  |> list.flat_map(fn(p) { page_assets(p, watch) })
}

fn component_assets(p: String, watch: Bool) -> List(Asset) {
  case watch {
    True -> [
      Asset(
        component_content(p),
        index_path(dist <> "/components/", p, "js"),
        js_watch,
      ),
      Asset(
        file_path(src <> "components/", p, "json"),
        index_path(dist <> "components/", p, "json"),
        copy_watch,
      ),
      Asset(
        file_path(src <> "components/", p, "wxml"),
        index_path(dist <> "components/", p, "wxml"),
        copy_watch,
      ),
      Asset(
        file_path(src <> "components/", p, "less"),
        index_path(dist <> "components/", p, "wxss"),
        less_watch,
      ),
    ]
    False -> [
      Asset(
        component_content(p),
        index_path(dist <> "/components/", p, "js"),
        js_build,
      ),
      Asset(
        file_path(src <> "components/", p, "json"),
        index_path(dist <> "components/", p, "json"),
        copy_build,
      ),
      Asset(
        file_path(src <> "components/", p, "wxml"),
        index_path(dist <> "components/", p, "wxml"),
        copy_build,
      ),
      Asset(
        file_path(src <> "components/", p, "less"),
        index_path(dist <> "components/", p, "wxss"),
        less_build,
      ),
    ]
  }
}

fn components_assets(watch: Bool) -> List(Asset) {
  bundle.components()
  |> list.map(fn(p) { p.0 })
  |> list.flat_map(fn(p) { component_assets(p, watch) })
}

fn fold_result(
  r0: Result(Nil, String),
  r: Result(Nil, String),
) -> Result(Nil, String) {
  case r0, r {
    Ok(Nil), Ok(Nil) -> r0
    Error(_), Ok(Nil) -> r0
    Ok(Nil), Error(_) -> r
    Error(e1), Error(e2) -> Error(e1 <> "\n\n" <> e2)
  }
}

fn build(ass: List(Asset)) -> Promise(Result(Nil, String)) {
  ass
  |> list.map(fn(a) { a.builder(a.src, a.dist) })
  |> promise.await_list
  |> promise.map(fn(ls) {
    ls
    |> list.fold(Ok(Nil), fold_result)
  })
}

pub fn main() {
  let watch =
    envoy.get("WECHAT_BUILD_WATCH")
    |> result.is_ok

  use r0 <- promise.await(bundle_asset(watch) |> build)
  use r1 <- promise.await(app_assets(watch) |> build)
  use r2 <- promise.await(pages_assets(watch) |> build)
  use r3 <- promise.await(components_assets(watch) |> build)

  [r0, r1, r2, r3]
  |> list.fold(Ok(Nil), fold_result)
  |> result.map_error(fn(e) { io.println_error(e) })
  |> promise.resolve
}
