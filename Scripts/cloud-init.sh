#!/bin/bash

apt-get update -y
apt-get install nginx -y

systemctl enable nginx
systemctl restart nginx

HOSTNAME=$(hostname)

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
<title>VMSS Demo</title>

<style>

body {
    background-color: black;
    color: #00ff00;
    font-family: monospace;
    white-space: pre;
    padding: 20px;
    overflow: hidden;
}

#train {
    height: 8em;
}

#cpuBar {
    color: lime;
}

</style>
</head>

<body>

<div id="content"></div>

<script>

const hostname = "$HOSTNAME";

let trainPos = 0;
const width = 80;

const bootTime = Date.now();

function buildTrain(pos){

    const spaces = " ".repeat(pos);

    return spaces +
\`      ====        ________
  _D _|  |_______/        \\\\__
 |(_)---  |   H   TRAIN     |
 /     |  |                |
|______|__|________________|
   O      O          O   O\`;

}

function cpuBar(percent){

    const blocks = Math.floor(percent / 10);

    return "█".repeat(blocks) +
           "░".repeat(10 - blocks);

}

setInterval(() => {

    trainPos += 2;

    if(trainPos > width){
        trainPos = -35;
    }

    const uptimeSeconds =
        Math.floor((Date.now() - bootTime) / 1000);

    const hours =
        Math.floor(uptimeSeconds / 3600);

    const minutes =
        Math.floor((uptimeSeconds % 3600) / 60);

    const seconds =
        uptimeSeconds % 60;

    const cpu =
        Math.floor(Math.random() * 100);

    document.getElementById("content").innerText =

\`╔══════════════════════════════════════════════════════╗
║               VMSS INSTANCE RUNNING                 ║
╚══════════════════════════════════════════════════════╝


\${buildTrain(trainPos)}


Hostname : \${hostname}

Uptime   : \${hours}h \${minutes}m \${seconds}s

CPU Load : [\${cpuBar(cpu)}] \${cpu}%\`;

}, 500);

</script>

</body>
</html>
EOF