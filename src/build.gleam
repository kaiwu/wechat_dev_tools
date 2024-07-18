import esgleam
// import app/app

pub fn main() {
  esgleam.new("./dist")
  |> esgleam.entry("app/app.gleam")
  // |> esgleam.minify(True)
  |> esgleam.bundle
}
