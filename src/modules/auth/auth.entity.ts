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
