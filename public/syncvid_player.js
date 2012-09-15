function getParameterByName(name)
{
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(window.location.search);
    if(results == null)
        return "";
    else
        return decodeURIComponent(results[1].replace(/\+/g, " "));
}

function localFileVideoPlayerInit(window, document) {
    // Going to hell for this. Don't care. Too late.
    window.__user_name = getParameterByName("name") || prompt("What's your name?");
    window.__user_channel = getParameterByName("channel") || prompt("Name for this syncvid session?");

    name = window.__user_name;
    channel = window.__user_channel;

    var URL = window.URL || window.webkitURL;
    displayMessage = (function displayMessageInit() {
      var node = document.querySelector('#logger');

      return function displayMessage(message, isError) {
        node.innerHTML += "\n" + message;
        node.className = isError ? 'error' : 'info';
      };
    }());

    notifyServerOfSelection = function (event) {
      var file = this.files[0];

      var type = file.type;

      var videoNode = document.querySelector('video');

      var canPlay = videoNode.canPlayType(type);

      canPlay = (canPlay === '' ? 'no' : canPlay);

      var isError = canPlay === 'no';

      var fileURL = URL.createObjectURL(file);

      videoNode.src = fileURL;
      ws_send_data("TELL:"+name+" selected " + file.name);
    };

    if (!URL) {
        displayMessage('Your browser is not ' +
           '<a href="http://caniuse.com/bloburls">supported</a>!', true);

        return;
    };

    inputNode = document.querySelector('input');
    inputNode.addEventListener('change', notifyServerOfSelection, false);
};
