// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app1.css"
import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {};

Hooks.TrackClientCursor = {
  mounted() {
    document.addEventListener('mousemove', (e) => {
      const mouse_x = e.pageX; // in %
      const mouse_y = e.pageY; // in %
      this.pushEvent('cursor-move', { mouse_x, mouse_y });
    });
  }
};

Hooks.Aaa = {
  mounted() {
    document.addEventListener('pointermove', (e) => {
      // console.log(e);
      const x = Math.floor( e.pageX)- 10;
      const y = Math.floor(e.pageY)- 33;
      const p = e.pressure;
  this.pushEvent('cur', {x, y});
  if (p > 0.0) this.pushEvent('aaa', {x, y, p});}
    );
    document.addEventListener('pointerdown', (e) => {
      const x = Math.floor( e.pageX)- 10;
      const y = Math.floor(e.pageY)- 33;
      const p = e.pressure;
      this.pushEvent('aaa', {x, y, p});
});
  }
  
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 1, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

window.liveSocket = liveSocket

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
// window.liveSocket = liveSocket
