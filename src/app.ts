import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { config } from './config';
import { AppDataSource } from './config/database';
import { authRoutes } from './modules/auth/auth.routes';

const app = express();

console.log('🔍 Debug: Iniciando aplicación...');
console.log('📁 Directorio actual:', process.cwd());
console.log('📁 Archivos en src/modules/auth:');

// Middleware básico
app.use(helmet());
app.use(cors());
app.use(express.json());

// API Routes
app.use('/api/auth', authRoutes);

// Logger
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: config.NODE_ENV,
    database: AppDataSource.isInitialized ? 'connected' : 'disconnected'
  });
});

// Ruta principal
app.get('/', (req, res) => {
  res.json({ 
    message: '🚀 API is running!',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Manejar rutas no encontradas
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Error handler
app.use((error: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Error:', error);
  res.status(error.status || 500).json({ 
    error: error.message || 'Internal server error' 
  });
});

// Función para inicializar la base de datos
const initializeDatabase = async () => {
  try {
    await AppDataSource.initialize();
    console.log('Database connected successfully');
    
    // Sincronizar esquemas en desarrollo
    if (config.NODE_ENV === 'development') {
      await AppDataSource.synchronize();
      console.log('Database synchronized');
    }
    
    return true;
  } catch (error) {
    console.error('Database connection failed:', error);
    return false;
  }
};

// Función para listar archivos (solo en desarrollo)
if (process.env.NODE_ENV === 'development') {
  const fs = require('fs');
  const path = require('path');
  
  try {
    const authPath = path.join(__dirname, 'modules', 'auth');
    if (fs.existsSync(authPath)) {
      const files = fs.readdirSync(authPath);
      console.log('📄 Archivos en auth:', files);
    } else {
      console.log('❌ No existe carpeta auth');
    }
  } catch (error) {
    console.log('❌ Error leyendo carpeta auth:', error);
  }
}

// Agrega una ruta de debug simple
app.get('/api/debug', (req, res) => {
  res.json({
    message: 'Debug endpoint',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
    nodeVersion: process.version,
    routes: ['/api/auth/register', '/api/auth/login', '/api/health']
  });
});


// Inicializar servidor
const startServer = async () => {
  const dbConnected = await initializeDatabase();
  
  if (!dbConnected && config.NODE_ENV === 'production') {
    console.error('Cannot start server without database connection');
    process.exit(1);
  }

  const PORT = config.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Environment: ${config.NODE_ENV}`);
    console.log(`Health check: http://localhost:${PORT}/health`);
    console.log(`Auth endpoints: http://localhost:${PORT}/api/auth`);
  });
};

startServer();

export default app;