import app from "ags/gtk4/app";
import scss from "./src/style/style.scss";
import Bar from "./src/widget/bar/Bar";
import VolumeIndicator from "./src/widget/volume-indicator/VolumeIndicator";

app.start({
  css: scss,
  main() {
    app.get_monitors().map((m) => {
      Bar(m);
      VolumeIndicator(m);
    });
  },
});
