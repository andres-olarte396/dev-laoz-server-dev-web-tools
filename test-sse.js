const http = require('http');

const options = {
    hostname: 'localhost',
    port: 3600,
    path: '/api/insights/stream',
    headers: {
        'Cache-Control': 'no-cache',
        'Accept': 'text/event-stream'
    }
};

console.log('🎧 Escuchando stream SSE...');

const req = http.get(options, (res) => {
    res.on('data', (chunk) => {
        console.log(`📡 Evento recibido:\n${chunk.toString()}`);
    });
});

req.on('error', (e) => {
    console.error(`Problema con request: ${e.message}`);
});

// Cerrar después de 15 segundos
setTimeout(() => {
    console.log('🛑 Terminando prueba SSE');
    req.destroy();
}, 15000);
