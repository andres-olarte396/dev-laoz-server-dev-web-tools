const axios = require('axios');

const GATEWAY_URL = 'http://localhost:3210/api';

async function runTest() {
    try {
        // 1. Login (Necesario porque manager tiene auth: true)
        console.log('1. Login...');
        const authRes = await axios.post(`${GATEWAY_URL}/auth/login`, {
            username: 'admin',
            password: 'Admin123!'
        });
        const token = authRes.data.token;
        console.log('Token OK');

        const headers = { Authorization: `Bearer ${token}` };

        // 2. List Containers
        console.log('2. Listing Containers...');
        const containersRes = await axios.get(`${GATEWAY_URL}/manager/containers`, { headers });
        console.log(`Found ${containersRes.data.length} containers.`);

        const managerContainer = containersRes.data.find(c => c.Names.some(n => n.includes('api-manager')));
        if (managerContainer) {
            console.log('SUCCESS: ApiManager found itself via Docker Socket!');
        } else {
            console.warn('WARNING: ApiManager not found in list (check network/filters).');
        }

    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
    }
}

runTest();
