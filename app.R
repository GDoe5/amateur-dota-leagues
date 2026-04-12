pkgload::load_all(".")
options(shiny.maxRequestSize = 200 * 1024^2)
runApp()
