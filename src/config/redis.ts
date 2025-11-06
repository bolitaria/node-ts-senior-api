import Redis from 'redis';
import { config } from './index';

export const redisClient = Redis.createClient({
  socket: {
    host: config.REDIS_HOST,
    port: config.REDIS_PORT,
  },
});

redisClient.on('error', (err) => console.error('Redis Client Error', err));
redisClient.on('connect', () => console.log('✅ Redis connected'));

export const connectRedis = async () => {
  await redisClient.connect();
};