import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validate } from '../../shared/utils/validation';
import { authValidation } from '../../shared/utils/validation';

const router = Router();
const authController = new AuthController();

// Public routes
router.post('/register', validate(authValidation.register), authController.register);
router.post('/login', validate(authValidation.login), authController.login);
router.post('/refresh-token', authController.refreshToken);
router.post('/logout', authController.logout);

// Protected routes
router.get('/profile', authController.getProfile);

export { router as authRoutes };