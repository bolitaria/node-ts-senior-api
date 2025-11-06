import dotenv from 'dotenv';

dotenv.config();

export const config = {
  NODE_ENV: process.env.NODE_ENV || 'development',
  PORT: parseInt(process.env.PORT || '3000'),
  
  // Database
  DB_HOST: process.env.DB_HOST || 'localhost',
  DB_PORT: parseInt(process.env.DB_PORT || '5432'),
  DB_NAME: process.env.DB_NAME || 'myapp',
  DB_USER: process.env.DB_USER || 'user',
  DB_PASSWORD: process.env.DB_PASSWORD || 'password',
  
  // Redis
  REDIS_HOST: process.env.REDIS_HOST || 'localhost',
  REDIS_PORT: parseInt(process.env.REDIS_PORT || '6379'),
  
  // JWT
  JWT_SECRET: process.env.JWT_SECRET || 'dev-secret-change-in-production',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '1h',
  
  // ClickHouse
  CLICKHOUSE_HOST: process.env.CLICKHOUSE_HOST || 'localhost',
  CLICKHOUSE_PORT: parseInt(process.env.CLICKHOUSE_PORT || '8123')
};