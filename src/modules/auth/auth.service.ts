import { AppDataSource } from '../../config/database';
import { User } from '../users/user.entity';
import { RefreshToken } from './auth.entity';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { config } from '../../config';

export class AuthService {
  private userRepository = AppDataSource.getRepository(User);
  private tokenRepository = AppDataSource.getRepository(RefreshToken);

  async register(email: string, password: string, name: string) {
    // Verificar si el usuario ya existe
    const existingUser = await this.userRepository.findOne({ where: { email } });
    if (existingUser) {
      throw new Error('User already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Crear usuario
    const user = this.userRepository.create({
      email,
      password: hashedPassword,
      name,
    });

    await this.userRepository.save(user);

    // Generar tokens
    const tokens = await this.generateTokens(user);

    return {
      user,
      ...tokens,
    };
  }

  async login(email: string, password: string) {
    // Buscar usuario
    const user = await this.userRepository.findOne({ where: { email } });
    if (!user) {
      throw new Error('Invalid credentials');
    }

    // Verificar password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      throw new Error('Invalid credentials');
    }

    // Generar tokens
    const tokens = await this.generateTokens(user);

    return {
      user,
      ...tokens,
    };
  }

  async generateTokens(user: User) {
    // Access token (corto)
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email },
      config.JWT_SECRET,
      { expiresIn: '15m' }
    );

    // Refresh token (largo)
    const refreshToken = jwt.sign(
      { userId: user.id },
      config.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Guardar refresh token en base de datos
    const refreshTokenEntity = this.tokenRepository.create({
      token: refreshToken,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 días
      user,
    });

    await this.tokenRepository.save(refreshTokenEntity);

    return {
      accessToken,
      refreshToken,
      expiresIn: 15 * 60, // 15 minutos en segundos
    };
  }

  async refreshToken(oldRefreshToken: string) {
    // Verificar token en base de datos
    const tokenEntity = await this.tokenRepository.findOne({
      where: { token: oldRefreshToken, isActive: true },
      relations: ['user'],
    });

    if (!tokenEntity || tokenEntity.expiresAt < new Date()) {
      throw new Error('Invalid refresh token');
    }

    // Invalidar token antiguo
    tokenEntity.isActive = false;
    await this.tokenRepository.save(tokenEntity);

    // Generar nuevos tokens
    return this.generateTokens(tokenEntity.user);
  }

  async logout(refreshToken: string) {
    const tokenEntity = await this.tokenRepository.findOne({
      where: { token: refreshToken },
    });

    if (tokenEntity) {
      tokenEntity.isActive = false;
      await this.tokenRepository.save(tokenEntity);
    }

    return { message: 'Logged out successfully' };
  }
}