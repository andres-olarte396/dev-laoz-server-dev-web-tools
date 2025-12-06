const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');
const path = require('path');

const GATEWAY_URL = 'http://localhost:3210/api';

async function runTest() {
    try {
        // 1. Login
        console.log('1. Login...');
        const authRes = await axios.post(`${GATEWAY_URL}/auth/login`, {
            username: 'admin',
            password: 'Admin123!'
        });
        const token = authRes.data.token;
        console.log('Token OK');

        const headers = { Authorization: `Bearer ${token}` };

        // 2. Upload
        console.log('2. Uploading file...');
        const form = new FormData();
        const dummyPath = path.join(__dirname, 'test_dummy.txt');
        fs.writeFileSync(dummyPath, 'Contenido de prueba ApiFiles');
        form.append('file', fs.createReadStream(dummyPath));

        const uploadRes = await axios.post(`${GATEWAY_URL}/files`, form, {
            headers: {
                ...headers,
                ...form.getHeaders()
            } // En Gateway services.json ruta es /api/files (mapeado a api-files POST /)
            // Wait, services.json path is /api/files, target http://api-files:3700/api/files
            // But api-files routes are based on / (see files.routes.js) or /api/files?
            // In files.routes.js: router.post('/', ...)
            // app.use('/api/files', routes) in server.js? I didn't check server.js of api-files!
        });

        console.log('Upload Response:', uploadRes.data);
        const fileId = uploadRes.data.id;

        // 3. Check Versions
        console.log('3. Checking versions...');
        const verRes = await axios.get(`${GATEWAY_URL}/files/${fileId}/versions`, { headers });
        console.log('Versions:', verRes.data);

        // 4. Move File
        console.log('4. Moving file to local/archive...');
        const moveRes = await axios.put(`${GATEWAY_URL}/files/${fileId}/move`, {
            targetStorageType: 'LOCAL',
            targetPath: 'archive/moved_test.txt'
        }, { headers });
        console.log('Move Response:', moveRes.data);

        // 5. Verify Move
        console.log('5. Verifying path update...');
        const verRes2 = await axios.get(`${GATEWAY_URL}/files/${fileId}/versions`, { headers });
        const lastVer = verRes2.data.find(v => v.version === verRes2.data.length); // or last
        console.log('New Path:', lastVer.relativePath);

        if (lastVer.relativePath === 'archive/moved_test.txt') {
            console.log('SUCCESS: File moved.');
        } else {
            console.error('FAILURE: Path mismatch.');
        }

    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

runTest();
