import { build } from 'esbuild'
import { Ok, Error } from "./gleam.mjs"
import { lessLoader } from 'esbuild-plugin-less';

export function bundle_build(entry, out) {
  return new Promise(resolve => {
    let b = build({
      entryPoints: [entry],
      bundle: true,
      minify: true,
      format: 'esm',
      outfile: out,
    })
    resolve(new Ok(undefined))
  })
}

export function js_build(js, out) {
  return new Promise(resolve => {
    let b = build({
      stdin: {
        contents: js,
        loader: 'js',
      },
      bundle: false,
      minify: false,
      format: 'esm',
      outfile: out,
    })
    resolve(new Ok(undefined))
  })
}

export function copy_build(src, out) {
  return new Promise(resolve => {
    let b = build({
      entryPoints: [src],
      loader: {'.wxml': 'copy', '.json': 'copy'},
      outfile: out,
    })
    resolve(new Ok(undefined))
  })
}

export function less_build(css, out) {
  return new Promise(resolve => {
    let b = build({
      entryPoints: [css],
      plugins: [lessLoader()],
      loader: {'.less': 'css'},
      outfile: out,
    })
    resolve(new Ok(undefined))
  })
}
