async function fetchJSON(url) {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
}

function formatBytes(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
    if (bytes < 1024 * 1024 * 1024) return (bytes / 1024 / 1024).toFixed(1) + ' MB';
    return (bytes / 1024 / 1024 / 1024).toFixed(2) + ' GB';
}

function formatDuration(sec) {
    const h = Math.floor(sec / 3600);
    const m = Math.floor((sec % 3600) / 60);
    const s = sec % 60;
    return `${h}h ${m}m ${s}s`;
}

async function updateAP() {
    try {
        const ap = await fetchJSON('/cgi-bin/ap.sh');
        document.getElementById('ap-info').innerHTML = `
            <table>
                <tr><td>SSID</td><td>${ap.ssid}</td></tr>
                <tr><td>Channel</td><td>${ap.channel} (${ap.freq_mhz} MHz)</td></tr>
                <tr><td>Mode</td><td>${ap.type}</td></tr>
                <tr><td>TX Power</td><td>${ap.txpower_dbm} dBm</td></tr>
            </table>
        `;
    } catch (e) {
        document.getElementById('ap-info').textContent = 'Error: ' + e.message;
    }
}

async function updateNetwork() {
    try {
        const ifs = await fetchJSON('/cgi-bin/network.sh');
        let html = '<table><tr><th>Interface</th><th>State</th><th>IP</th></tr>';
        for (const i of ifs) {
            html += `<tr><td>${i.name}</td><td>${i.state}</td><td>${i.ip}</td></tr>`;
        }
        html += '</table>';
        document.getElementById('network-info').innerHTML = html;
    } catch (e) {
        document.getElementById('network-info').textContent = 'Error: ' + e.message;
    }
}

async function updateClients() {
    try {
        const clients = await fetchJSON('/cgi-bin/clients.sh');
        document.getElementById('client-count').textContent = clients.length;
        
        if (clients.length === 0) {
            document.getElementById('clients-info').textContent = 'No clients connected';
            return;
        }
        
        let html = '<table><tr><th>MAC</th><th>Signal</th><th>RX</th><th>TX</th><th>Connected</th></tr>';
        for (const c of clients) {
            html += `<tr>
                <td>${c.mac}</td>
                <td>${c.signal_dbm} dBm</td>
                <td>${formatBytes(c.rx_bytes)}</td>
                <td>${formatBytes(c.tx_bytes)}</td>
                <td>${formatDuration(c.connected_sec)}</td>
            </tr>`;
        }
        html += '</table>';
        document.getElementById('clients-info').innerHTML = html;
    } catch (e) {
        document.getElementById('clients-info').textContent = 'Error: ' + e.message;
    }
}

async function updateSystem() {
    try {
        const sys = await fetchJSON('/cgi-bin/sysinfo.sh');
        const memUsedPct = ((1 - sys.mem_free_kb / sys.mem_total_kb) * 100).toFixed(1);
        document.getElementById('system-info').innerHTML = `
            <table>
                <tr><td>Uptime</td><td>${formatDuration(sys.uptime)}</td></tr>
                <tr><td>Kernel</td><td>${sys.kernel}</td></tr>
                <tr><td>Memory</td><td>${formatBytes(sys.mem_free_kb * 1024)} free / ${formatBytes(sys.mem_total_kb * 1024)} total (${memUsedPct}% used)</td></tr>
                <tr><td>Load avg</td><td>${sys.loadavg}</td></tr>
            </table>
        `;
    } catch (e) {
        document.getElementById('system-info').textContent = 'Error: ' + e.message;
    }
}

async function updateAll() {
    await Promise.all([updateAP(), updateNetwork(), updateClients(), updateSystem()]);
    document.getElementById('last-update').textContent = new Date().toLocaleTimeString();
}

updateAll();
setInterval(updateAll, 2000);
