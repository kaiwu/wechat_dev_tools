// import gleam/string
import gleam/javascript/promise.{type Promise}
// import bundle

// const entry = "./build/dev/javascript/wechat_dev_tools/bundle.mjs"
// const app_content = "import { app } from './bundle.mjs'; app()"
// const dist = "./dist/"
// const src = "./src/"
//
// fn page_content(p: String) -> String {
//  "improt { pages, page } from './bundle.mjs'; page(pages(), \"" <> p <> "\")"
// } 

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

pub fn main() {
  Nil
}
