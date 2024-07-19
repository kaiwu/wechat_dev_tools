import { build } from 'esbuild'
import { lessLoader } from 'esbuild-plugin-less';

export async function bundle_build(entry, out) {
  await build({
    entryPoints: [entry],
    bundle: true,
    minify: true,
    format: 'esm',
    outfile: out,
  })
}

export async function js_build(js, out) {
  await build({
    stdin: {
      contents: js,
      loader: 'js',
    },
    bundle: false,
    minify: false,
    format: 'esm',
    outfile: out,
  })
}

export async function wxml_build(wxml, out) {
  await build({
    entryPoints: [wxml],
    loader: 'txt',
    outfile: out,
  })
}

export async function json_build(json, out) {
  await build({
    entryPoints: [json],
    loader: 'json',
    outfile: out,
  })
}

export async function less_build(css, out) {
  await build({
    entryPoints: [css],
    plugins: [lessLoader()],
    loader: 'css',
    outfile: out,
  })
}
