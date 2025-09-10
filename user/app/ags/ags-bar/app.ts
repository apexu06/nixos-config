import app from "ags/gtk4/app"
import css from "~/.config/ags/theme.css"
import Bar from "./widget/Bar"

app.start({
  css: css,
  main() {
    app.get_monitors().map(Bar)
  },
})
