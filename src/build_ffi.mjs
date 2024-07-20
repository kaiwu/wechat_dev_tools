import { build, context } from 'esbuild'
import { Ok, Error } from "./gleam.mjs"
import { lessLoader } from 'esbuild-plugin-less';

export function bundle_build(entry, out) {
  return new Promise(resolve => {
      build({
        entryPoints: [entry],
        bundle: true,
        minify: true,
        format: 'esm',
        outfile: out,
      }).then(function(r){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function js_build(js, out) {
  return new Promise(resolve => {
      build({
        stdin: {
          contents: js,
          loader: 'js',
        },
        bundle: false,
        minify: false,
        format: 'esm',
        outfile: out,
      }).then(function(r){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function copy_build(src, out) {
  return new Promise(resolve => {
      build({
        entryPoints: [src],
        loader: {'.wxml': 'copy', '.json': 'copy'},
        outfile: out,
      }).then(function(r){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function less_build(css, out) {
  return new Promise(resolve => {
      let less = lessLoader({math:'always'}, {})
      build({
        entryPoints: [css],
        plugins: [less],
        loader: {'.less': 'css'},
        outfile: out,
      }).then(function(r){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function bundle_watch(entry, out) {
  return new Promise(resolve => {
      context({
        entryPoints: [entry],
        bundle: true,
        minify: true,
        format: 'esm',
        outfile: out,
      }).then(function(ctx){
        ctx.watch()
        console.log(`watching bundle ${entry}...`)
      }).then(function(){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function js_watch(js, out) {
  return new Promise(resolve => {
      context({
        stdin: {
          contents: js,
          loader: 'js',
        },
        bundle: false,
        minify: false,
        format: 'esm',
        outfile: out,
      }).then(function(ctx){
        ctx.watch()
        console.log("watching js...")
      }).then(function(){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function copy_watch(src, out) {
  return new Promise(resolve => {
      context({
        entryPoints: [src],
        loader: {'.wxml': 'copy', '.json': 'copy'},
        outfile: out,
      }).then(function(ctx){
        ctx.watch()
        console.log(`watching json/wxml ${src}...`)
      }).then(function(){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}

export function less_watch(css, out) {
  return new Promise(resolve => {
      let less = lessLoader({math:'always'}, {})
      context({
        entryPoints: [css],
        plugins: [less],
        loader: {'.less': 'css'},
        outfile: out,
      }).then(function(ctx){
        ctx.watch()
        console.log(`watching css ${css}...`)
      }).then(function(){
        resolve(new Ok(undefined))
      }).catch(function(e){
        resolve(new Error(JSON.stringify(e)))
      })
  })
}
