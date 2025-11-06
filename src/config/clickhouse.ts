import { createClient } from '@clickhouse/client';
import { config } from './index';

export const clickhouseClient = createClient({
  host: `http://${config.CLICKHOUSE_HOST}:${config.CLICKHOUSE_PORT}`,
  username: 'default',
  password: '',
  database: 'default',
});

// Función para inicializar tablas de analytics
export const initClickHouse = async () => {
  try {
    await clickhouseClient.query({
      query: `
        CREATE TABLE IF NOT EXISTS user_analytics (
          user_id String,
          event_type String,
          event_data String,
          created_at DateTime DEFAULT now()
        ) ENGINE = MergeTree()
        ORDER BY (user_id, event_type, created_at)
      `,
    });
    console.log('✅ ClickHouse initialized');
  } catch (error) {
    console.error('❌ ClickHouse initialization failed:', error);
  }
};