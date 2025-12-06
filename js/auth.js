// Módulo de autenticación para WebTools
const AUTH = {
    API_BASE: 'http://localhost:3210',
    TOKEN_KEY: 'webtools_token',
    REFRESH_KEY: 'webtools_refresh',
    USER_KEY: 'webtools_user',

    // Realiza login y guarda tokens
    async login(username, password) {
        try {
            const response = await fetch(`${this.API_BASE}/api/auth/login`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username, password })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Login fallido');
            }

            // Guardar tokens
            localStorage.setItem(this.TOKEN_KEY, data.token);
            localStorage.setItem(this.REFRESH_KEY, data.refreshToken);

            // Decodificar y guardar info del usuario
            const userInfo = this.decodeToken(data.token);
            localStorage.setItem(this.USER_KEY, JSON.stringify(userInfo));

            return { success: true, user: userInfo };
        } catch (error) {
            console.error('Error en login:', error);
            return { success: false, error: error.message };
        }
    },

    // Cierra sesión y limpia tokens
    async logout() {
        const refreshToken = localStorage.getItem(this.REFRESH_KEY);

        if (refreshToken) {
            try {
                await fetch(`${this.API_BASE}/api/auth/logout`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ refreshToken })
                });
            } catch (error) {
                console.error('Error al cerrar sesión en el servidor:', error);
            }
        }

        // Limpiar almacenamiento local
        localStorage.removeItem(this.TOKEN_KEY);
        localStorage.removeItem(this.REFRESH_KEY);
        localStorage.removeItem(this.USER_KEY);

        window.location.reload();
    },

    // Verifica si el usuario está autenticado
    isAuthenticated() {
        const token = localStorage.getItem(this.TOKEN_KEY);
        if (!token) return false;

        try {
            const decoded = this.decodeToken(token);
            // Verificar si el token ha expirado
            const now = Date.now() / 1000;
            return decoded.exp > now;
        } catch (error) {
            return false;
        }
    },

    // Obtiene el token de acceso
    getToken() {
        return localStorage.getItem(this.TOKEN_KEY);
    },

    // Obtiene información del usuario
    getUserInfo() {
        const userStr = localStorage.getItem(this.USER_KEY);
        return userStr ? JSON.parse(userStr) : null;
    },

    // Decodifica un JWT (sin verificar firma - solo para leer datos)
    decodeToken(token) {
        try {
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(
                atob(base64)
                    .split('')
                    .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
                    .join('')
            );
            return JSON.parse(jsonPayload);
        } catch (error) {
            console.error('Error al decodificar token:', error);
            return null;
        }
    },

    // Realiza una petición autenticada
    async fetchWithAuth(url, options = {}) {
        const token = this.getToken();

        if (!token) {
            throw new Error('No hay token de autenticación');
        }

        const headers = {
            ...options.headers,
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        };

        const response = await fetch(url, { ...options, headers });

        // Si el token expiró, intentar refrescar
        if (response.status === 401) {
            const refreshed = await this.refreshToken();
            if (refreshed) {
                // Reintentar la petición con el nuevo token
                headers.Authorization = `Bearer ${this.getToken()}`;
                return fetch(url, { ...options, headers });
            } else {
                // No se pudo refrescar, cerrar sesión
                this.logout();
                throw new Error('Sesión expirada');
            }
        }

        return response;
    },

    // Refresca el access token usando el refresh token
    async refreshToken() {
        const refreshToken = localStorage.getItem(this.REFRESH_KEY);

        if (!refreshToken) return false;

        try {
            const response = await fetch(`${this.API_BASE}/api/auth/refresh`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ refreshToken })
            });

            const data = await response.json();

            if (response.ok) {
                localStorage.setItem(this.TOKEN_KEY, data.token);
                return true;
            }

            return false;
        } catch (error) {
            console.error('Error al refrescar token:', error);
            return false;
        }
    }
};

// Exponer globalmente
window.AUTH = AUTH;
