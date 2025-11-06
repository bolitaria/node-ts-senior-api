import { Request, Response } from 'express';
import { AuthService } from './auth.service';

const authService = new AuthService();

export class AuthController {
  async register(req: Request, res: Response) {
    try {
      const result = await authService.register(
        req.body.email,
        req.body.password,
        req.body.name
      );
      res.status(201).json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async login(req: Request, res: Response) {
    try {
      const result = await authService.login(
        req.body.email,
        req.body.password
      );
      res.json(result);
    } catch (error: any) {
      res.status(401).json({ error: error.message });
    }
  }

  async refreshToken(req: Request, res: Response) {
    try {
      const { refreshToken } = req.body;
      const result = await authService.refreshToken(refreshToken);
      res.json(result);
    } catch (error: any) {
      res.status(401).json({ error: error.message });
    }
  }

  async logout(req: Request, res: Response) {
    try {
      const { refreshToken } = req.body;
      const result = await authService.logout(refreshToken);
      res.json(result);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getProfile(req: Request, res: Response) {
    res.json({ message: "Profile endpoint - needs authentication middleware" });
  }
}