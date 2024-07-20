# wechat_dev_tools

Develop wechat miniprograms in [gleam](https://gleam.run).
It uses [esbuild]() and [esbuild-plugin-less]() to build `*.json`, `*.wxml` and `.wxss` files

[![Package Version](https://img.shields.io/hexpm/v/wechat_dev_tools)](https://hex.pm/packages/wechat_dev_tools)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/wechat_dev_tools/)

```sh
$ git clone https://github.com/kaiwu/wechat_dev_tools.git your-project
$ cd your-project
$ npm install
$ gleam build
```
Further documentation can be found at <https://hexdocs.pm/wechat_dev_tools>.

## Development

Update `src/bundle.gleam` so that it includes each one of your page and component

```gleam
pub fn pages() -> List(#(String, Constructor)) {
  [#("index", index.page)]
}

pub fn components() -> List(#(String, Constructor)) {
  [#("basic", basic.component)]
}
```

Npm scripts are provided for convenience

```sh
$ npm run purge
$ npm run clean
$ npm run build
$ npm run watch
```

One can use the excellent `watchexec` command to watch gleam file changes, such as

```sh
$ # a full continuous building process
$ watchexec -e gleam gleam build
$ npm run watch
```
