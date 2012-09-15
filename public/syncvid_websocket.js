function log(data) {
  var log    = document.querySelector("#logger");
  log.innerHTML+= "\n"+data;
}

function websocketInit(window, document) {
  var player = document.querySelector("#videobj");
  var name = window.__user_name;
  var channel = window.__user_channel;
  handle = function(data) {
    ary = data.split(":");
    command = ary.shift();
    data = ary.join(":");

    switch(command) {
      case "TELL":
        log(data);
        break;
      case "PLAY":
        player.play();
        break;
      case "PAUSE":
        player.pause();
        break;
    }
  }

  if ("WebSocket" in window) {
    ws_host = "ws://"+window.location.hostname+":8080/?channel="+channel;
    ws = new WebSocket(ws_host);
    ws.onopen = function(event) {
      ws.send("TELL:"+name + " has joined");
    };

    ws.onerror = function(event) {
      ws.send("TELL:"+name + " has left");
    };

    ws.onmessage = function(event) {
      handle(event.data);
    };

    ws.onclose = function(event) {
      ws.send("TELL:"+name + " has left");
    };
  } else {
    // the browser doesn't support WebSocket
    alert("WebSocket NOT supported here!\r\n\r\nBrowser: " +
        navigator.appName + " " + navigator.appVersion);
  }

  return false;
}

function ws_send_data(data) {
  ws.send(data);

  return false;
}




