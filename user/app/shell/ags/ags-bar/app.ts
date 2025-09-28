import app from "ags/gtk4/app";
import scss from "./style/style.scss";
import Bar from "./widget/bar/Bar";
import VolumeIndicator from "./widget/volume-indicator/VolumeIndicator";

app.start({
  css: scss,
  main() {
    app.get_monitors().map((m) => {
      Bar(m);
      VolumeIndicator(m);
    });
  },
});
