// next insists that global imports only happen in _app.js,
// so this can no longer be placed as a raw value in App.res
import '../styles/main.css';

// spent a few hours trying to get _App.res working
// gave up for now, using this workaround instead
import { make as App } from "common/App.js";

export default App;
