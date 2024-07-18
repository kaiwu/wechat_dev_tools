import esgleam
// import bundle

pub fn main() {
  esgleam.new("./dist")
  |> esgleam.entry("bundle.gleam")
  // |> esgleam.minify(True)
  |> esgleam.bundle
}
