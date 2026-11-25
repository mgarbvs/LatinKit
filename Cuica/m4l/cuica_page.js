// cuica_page.js -- the display's two pages: 0 = the drum, 1 = MPE settings. Shows/hides the MPE page's boxes by varname and
// tells the display jsui which page it is on. in: <0|1> (from the MPE button). Box names come as the js arguments.
inlets = 1;
outlets = 0;
var NAMES = jsarguments.slice(1);

function msg_int(v) {
    for (var i = 0; i < NAMES.length; i++) {
        var b = this.patcher.getnamed(NAMES[i]);
        if (b) b.hidden = v ? 0 : 1;
    }
    var view = this.patcher.getnamed("view");
    if (view) view.message("page", v ? 1 : 0);
}
