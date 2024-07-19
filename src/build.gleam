import gleam/io
import gleam/list
import gleam/string
import gleam/result
import gleam/javascript/promise.{type Promise}
import bundle

@external(javascript, "./build_ffi.mjs", "bundle_build")
pub fn bundle_build(entry f: String, outfile o: String) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "js_build")
pub fn js_build(content c: String, outfile o: String) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "json_build")
pub fn json_build(json f: String, outfile o: String) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "wxml_build")
pub fn wxml_build(wxml f: String, outfile o: String) -> Promise(Result(Nil, String))

@external(javascript, "./build_ffi.mjs", "less_build")
pub fn less_build(less f: String, outfile o: String) -> Promise(Result(Nil, String))

const entry = "./build/dev/javascript/wechat_dev_tools/bundle.mjs"
const app_content = "import { app } from './bundle.mjs'; app()"
const dist = "./dist/"
const src = "./src/"

pub type Builder = fn(String, String) -> Promise(Result(Nil, String))

pub type Asset {
    Asset(src: String, dist: String, builder: Builder)
}

fn file_path(path: String, p: String, t: String) -> String {
  string.concat([ path, p, "/", p, ".", t, ])
}

fn page_content(p: String) -> String {
  string.concat([
    "improt { pages, page } from './bundle.mjs'; page(pages(), \"",
    p,
    "\")",
  ])
}

fn bundle_asset() -> List(Asset) {
  [ Asset(entry, dist <> "bundle.mjs", bundle_build) ]
}

fn app_assets() -> List(Asset) {
  [ Asset(app_content, dist <> "app.js", js_build),
    Asset(src <> "app.json", dist <> "app.json", json_build),
    Asset(src <> "less", dist <> "app.wxss", less_build) ]
}

fn page_assets(p: String) -> List(Asset) {
  [ Asset(page_content(p), file_path(dist, p, "js"), js_build),
    Asset(file_path(src, p, "json"), file_path(dist, p, "json"), json_build),
    Asset(file_path(src, p, "wxml"), file_path(dist, p, "wxml"), wxml_build),
    Asset(file_path(src, p, "less"), file_path(dist, p, "wxss"), less_build) ]
}

fn pages_assets() -> List(Asset) {
  bundle.pages()
  |> list.map(fn(p) { p.0 })
  |> list.flat_map(fn(p) { page_assets(p) })
}

fn fold_result(r0: Result(Nil, String), r: Result(Nil, String)) -> Result(Nil, String) {
  case r {
    Ok(Nil) -> r0
    Error(_) -> r
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
  use r0 <- promise.await(build(bundle_asset()))
  use r1 <- promise.await(build(app_assets()))
  use r2 <- promise.await(build(pages_assets()))

  [r0, r1, r2]
  |> list.fold(Ok(Nil), fold_result)
  |> result.map_error(fn (e) { io.println(e) })
  |> promise.resolve
}
