import app from "ags/gtk4/app"
import scss from "./style.scss"
import Bar from "./widget/Bar"

app.start({
  css: scss,
  main() {
    app.get_monitors().map(Bar)
  },
})
