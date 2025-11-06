#!/bin/bash

echo "Corrigiendo errores de TypeScript en entidades..."

# Corregir user.entity.ts
cat > src/modules/users/user.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  email!: string;

  @Column()
  password!: string;

  @Column({ nullable: true })
  name!: string;

  @Column({ default: true })
  isActive: boolean = true;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  // Método para ocultar password en responses
  toJSON() {
    const { password, ...user } = this;
    return user;
  }
}
EOF

# Corregir auth.entity.ts
cat > src/modules/auth/auth.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../users/user.entity';

@Entity('refresh_tokens')
export class RefreshToken {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  token!: string;

  @Column()
  expiresAt!: Date;

  @Column({ default: true })
  isActive: boolean = true;

  @ManyToOne(() => User, user => user.id)
  user!: User;

  @CreateDateColumn()
  createdAt!: Date;
}
EOF

# Actualizar database.ts
cat > src/config/database.ts << 'EOF'
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
EOF

echo "Entidades corregidas"
echo "Reconstruyendo proyecto..."
npm run build

echo "Reiniciando contenedores..."
docker-compose restart api

echo "Listo! Los errores deberían estar solucionados."