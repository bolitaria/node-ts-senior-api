import { DataSource } from 'typeorm';
import { config } from './index';
import { User } from '../modules/users/user.entity';
import { RefreshToken } from '../modules/auth/auth.entity';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: config.DB_HOST,
  port: config.DB_PORT,
  username: config.DB_USER,
  password: config.DB_PASSWORD,
  database: config.DB_NAME,
  synchronize: config.NODE_ENV === 'development',
  logging: false,
  entities: [User, RefreshToken],
  migrations: [__dirname + '/../migrations/*{.ts,.js}'],
  subscribers: [],
});
