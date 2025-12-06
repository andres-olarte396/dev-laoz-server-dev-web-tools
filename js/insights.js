const INSIGHTS = (() => {
    let eventSource = null;
    let isConnected = false;
    const consoleContainer = document.getElementById('consoleContainer');
    const maxLines = 100;

    const appendToConsole = (html) => {
        // Si es el mensaje inicial, limpiar
        if (consoleContainer.children.length === 1 && consoleContainer.children[0].style.textAlign === 'center') {
            consoleContainer.innerHTML = '';
        }

        const div = document.createElement('div');
        div.innerHTML = html;
        div.style.marginBottom = '4px';
        div.style.borderBottom = '1px solid #2b2b2b';
        div.style.paddingBottom = '2px';

        consoleContainer.appendChild(div);

        // Auto-scroll si está cerca del final
        consoleContainer.scrollTop = consoleContainer.scrollHeight;

        // Limitar historial
        if (consoleContainer.children.length > maxLines) {
            consoleContainer.removeChild(consoleContainer.firstChild);
        }
    };

    const formatTime = (ts) => {
        const d = new Date(ts);
        return d.toLocaleTimeString([], { hour12: false }) + '.' + d.getMilliseconds().toString().padStart(3, '0');
    };

    const processEvent = (eventData) => {
        const msg = JSON.parse(eventData);
        const ts = formatTime(msg.timestamp);
        const type = msg.type;
        const data = msg.data;

        let content = '';
        let color = '#bdbdbd';
        let icon = '•';

        if (type === 'audit') {
            color = '#4caf50'; // Green
            icon = '🛡️';
            content = `[${data.action}] ${data.actor} -> ${data.target} (${data.outcome})`;
        } else if (type === 'log') {
            if (data.level === 'error') {
                color = '#f44336'; // Red
                icon = '❌';
            } else if (data.level === 'warn') {
                color = '#ff9800'; // Orange
                icon = '⚠️';
            } else {
                color = '#2196f3'; // Blue
                icon = 'ℹ️';
            }
            content = `[${data.service}] ${data.message}`;
        } else if (type === 'transaction') { // Si enviamos transaction
            color = '#9e9e9e'; // Grey
            icon = '🌐';
            content = `${data.method} ${data.path} ${data.statusCode} (${data.durationMs}ms)`;
        } else if (type === 'connected') {
            color = '#00bcd4';
            content = msg.message;
        }

        appendToConsole(`
      <span style="color: #666; font-size: 11px;">[${ts}]</span> 
      <span style="color: ${color}; font-weight: bold;">${icon} ${type.toUpperCase()}</span> 
      <span style="color: #e0e0e0;">${content}</span>
    `);
    };

    const toggleStream = () => {
        const btn = document.getElementById('toggleMonitorBtn');
        const status = document.getElementById('connectionStatus');

        if (isConnected) {
            if (eventSource) {
                eventSource.close();
                eventSource = null;
            }
            isConnected = false;
            btn.textContent = 'Conectar';
            btn.style.background = '#2e7d32'; // Green
            status.textContent = 'Desconectado';
            status.style.color = '#666';
            appendToConsole('<span style="color: #aaa;">--- Conexión finalizada ---</span>');
        } else {
            // Connect
            appendToConsole('<span style="color: #aaa;">--- Conectando a Insights Stream... ---</span>');

            // La URL del proxy SSE
            const token = AUTH.getToken();
            eventSource = new EventSource(`/api/insights/stream?token=${token}`); // Usar ruta relativa al gateway

            eventSource.onopen = () => {
                isConnected = true;
                btn.textContent = 'Desconectar';
                btn.style.background = '#c62828'; // Red
                status.textContent = 'En Vivo 🟢';
                status.style.color = '#4caf50';
            };

            eventSource.onmessage = (event) => {
                processEvent(event.data);
            };

            eventSource.onerror = (err) => {
                console.error('SSE Error:', err);
                status.textContent = 'Error conexión';
                status.style.color = '#f44336';
                // SSE intenta reconectar automáticamente, pero si el server muere, mejor manejar visualmente
                if (eventSource.readyState === EventSource.CLOSED) {
                    isConnected = false;
                    btn.textContent = 'Conectar';
                    btn.style.background = '#2e7d32';
                    appendToConsole('<span style="color: #f44336;"> Error: Conexión perdida con servidor.</span>');
                }
            };
        }
    };

    return {
        toggleStream
    };
})();
