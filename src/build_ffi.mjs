import {build} from 'esbuild'

export async function bundle_build(es, out, min) {
  await build({
    entryPoints: es,
    bundle: true,
    minify: min,
    format: 'esm',
    outdir: out,
    allowOverwrite: true,
  })
}

export async function js_build(js, out) {
  await build({
    stdin: {
      contents: js,
      loader: 'js',
    }
    bundle: false,
    minify: false,
    format: 'esm',
    outfile: out,
    allowOverwrite: true,
  })
}
