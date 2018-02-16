require('./index.html');
require('./main.css');
const localStoragePorts = require('./local-storage-ports.js')

const Elm = require('./Main.elm');
const mountNode = document.getElementById('main');

const app = Elm.Main.embed(mountNode);

localStoragePorts.register(app.ports, console.log);