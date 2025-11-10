#!/bin/bash

set -e

echo "📁 CREATING FRONTEND FILES"
echo "==========================="

cd frontend/src

# 1. Types
echo "📝 Creating TypeScript types..."

cat > types/auth.ts << 'EOF'
export interface User {
    id: string;
    email: string;
    name: string;
    isActive: boolean;
    createdAt: string;
    updatedAt: string;
    permissions?: string[];
}

export interface LoginData {
    email: string;
    password: string;
}

export interface RegisterData {
    email: string;
    password: string;
    name: string;
}

export interface AuthResponse {
    user: User;
    accessToken: string;
    refreshToken: string;
    expiresIn: number;
}
EOF

# 2. API Service
cat > services/api.ts << 'EOF'
import axios from 'axios';

export const api = axios.create({
    baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
    timeout: 10000,
});

// Request interceptor
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('accessToken');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

// Response interceptor
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            window.location.href = '/login';
        }
        return Promise.reject(error);
    }
);
EOF

# 3. Auth Service
cat > services/authService.ts << 'EOF'
import { api } from './api';
import { LoginData, RegisterData, AuthResponse, User } from '../types/auth';

// Dummy data for development
const dummyUsers: User[] = [
    {
        id: '1',
        email: 'admin@example.com',
        name: 'Administrator',
        isActive: true,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        permissions: ['admin', 'user'],
    },
    {
        id: '2',
        email: 'user@example.com',
        name: 'Regular User',
        isActive: true,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        permissions: ['user'],
    },
];

class AuthService {
    private useMock = import.meta.env.MODE === 'development';

    async login(data: LoginData): Promise<AuthResponse> {
        if (this.useMock) {
            await new Promise(resolve => setTimeout(resolve, 1000));
            const user = dummyUsers.find(u => u.email === data.email);
            
            if (!user || data.password !== 'password') {
                throw new Error('Invalid credentials');
            }

            return {
                user,
                accessToken: 'dummy-access-token-' + user.id,
                refreshToken: 'dummy-refresh-token-' + user.id,
                expiresIn: 3600,
            };
        }

        const response = await api.post<AuthResponse>('/auth/login', data);
        return response.data;
    }

    async register(data: RegisterData): Promise<AuthResponse> {
        if (this.useMock) {
            await new Promise(resolve => setTimeout(resolve, 1000));
            
            const newUser: User = {
                id: (dummyUsers.length + 1).toString(),
                email: data.email,
                name: data.name,
                isActive: true,
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString(),
                permissions: ['user']
            };

            dummyUsers.push(newUser);

            return {
                user: newUser,
                accessToken: 'dummy-access-token-' + newUser.id,
                refreshToken: 'dummy-refresh-token-' + newUser.id,
                expiresIn: 3600,
            };
        }

        const response = await api.post<AuthResponse>('/auth/register', data);
        return response.data;
    }

    async getProfile(): Promise<User> {
        if (this.useMock) {
            await new Promise(resolve => setTimeout(resolve, 500));
            const token = localStorage.getItem('accessToken');
            const userId = token?.replace('dummy-access-token-', '');
            return dummyUsers.find(u => u.id === userId) || dummyUsers[0];
        }

        const response = await api.get<User>('/auth/profile');
        return response.data;
    }

    async logout(refreshToken: string): Promise<void> {
        if (this.useMock) {
            await new Promise(resolve => setTimeout(resolve, 300));
            return;
        }

        try {
            await api.post('/auth/logout', { refreshToken });
        } catch (error) {
            console.error('Logout error:', error);
        }
    }
}

export const authService = new AuthService();
EOF

# 4. Auth Store
cat > store/authStore.ts << 'EOF'
import { create } from 'zustand';
import { AuthState, User, LoginData, RegisterData } from '../types/auth';
import { authService } from '../services/authService';

interface AuthStore extends AuthState {
    login: (data: LoginData) => Promise<void>;
    register: (data: RegisterData) => Promise<void>;
    logout: () => void;
    checkAuth: () => Promise<void>;
}

export const useAuthStore = create<AuthStore>((set, get) => ({
    user: null,
    isAuthenticated: false,
    isLoading: false,
    error: null,

    login: async (data: LoginData) => {
        set({ isLoading: true, error: null });

        try {
            const response = await authService.login(data);

            localStorage.setItem('accessToken', response.accessToken);
            localStorage.setItem('refreshToken', response.refreshToken);

            set({
                user: response.user,
                isAuthenticated: true,
                isLoading: false,
            });
        } catch (error) {
            set({
                error: error instanceof Error ? error.message : 'Authentication error',
                isLoading: false,
            });
            throw error;
        }
    },

    register: async (data: RegisterData) => {
        set({ isLoading: true, error: null });

        try {
            const response = await authService.register(data);

            localStorage.setItem('accessToken', response.accessToken);
            localStorage.setItem('refreshToken', response.refreshToken);

            set({
                user: response.user,
                isAuthenticated: true,
                isLoading: false,
            });
        } catch (error) {
            set({
                error: error instanceof Error ? error.message : 'Registration error',
                isLoading: false,
            });
            throw error;
        }
    },

    logout: () => {
        const refreshToken = localStorage.getItem('refreshToken');
        if (refreshToken) {
            authService.logout(refreshToken);
        }

        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');

        set({
            user: null,
            isAuthenticated: false,
            error: null,
        });
    },

    checkAuth: async () => {
        const token = localStorage.getItem('accessToken');

        if (!token) {
            set({ isLoading: false });
            return;
        }

        set({ isLoading: true });

        try {
            const user = await authService.getProfile();
            set({
                user,
                isAuthenticated: true,
                isLoading: false,
            });
        } catch (error) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            set({
                user: null,
                isAuthenticated: false,
                isLoading: false,
            });
        }
    },
}));
EOF

# 5. UI Components
cat > components/ui/Button.tsx << 'EOF'
import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
    variant?: 'primary' | 'secondary' | 'outline' | 'danger';
    size?: 'sm' | 'md' | 'lg';
    loading?: boolean;
    children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
    children,
    className = '',
    variant = 'primary',
    size = 'md',
    loading = false,
    disabled,
    ...props
}) => {
    const baseClasses = 'inline-flex items-center justify-center font-medium rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed';

    const variants = {
        primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500 shadow-sm',
        secondary: 'bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500 shadow-sm',
        outline: 'border border-gray-300 text-gray-700 hover:bg-gray-50 focus:ring-blue-500 bg-white',
        danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500 shadow-sm',
    };

    const sizes = {
        sm: 'px-3 py-1.5 text-sm',
        md: 'px-4 py-2 text-base',
        lg: 'px-6 py-3 text-lg',
    };

    return (
        <button
            className={`${baseClasses} ${variants[variant]} ${sizes[size]} ${loading ? 'cursor-wait' : ''} ${className}`}
            disabled={disabled || loading}
            {...props}
        >
            {loading && (
                <svg className="animate-spin -ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                </svg>
            )}
            {children}
        </button>
    );
};
EOF

# 6. Pages
cat > pages/auth/Login.tsx << 'EOF'
import React, { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { useAuthStore } from '../../store/authStore';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';

interface LoginForm {
    email: string;
    password: string;
}

export const Login: React.FC = () => {
    const { login, isLoading, error, clearError } = useAuthStore();
    const { register, handleSubmit, formState: { errors } } = useForm<LoginForm>();

    useEffect(() => {
        clearError();
    }, [clearError]);

    const onSubmit = async (data: LoginForm) => {
        try {
            await login(data);
        } catch (error) {
            // Error handled in store
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
            <div className="max-w-md w-full space-y-8">
                <div>
                    <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
                        Sign In
                    </h2>
                </div>

                <form className="mt-8 space-y-6" onSubmit={handleSubmit(onSubmit)}>
                    <Input
                        {...register('email', {
                            required: 'Email is required',
                            pattern: {
                                value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                                message: 'Invalid email address'
                            }
                        })}
                        label="Email"
                        type="email"
                        error={errors.email?.message}
                        placeholder="your@email.com"
                    />

                    <Input
                        {...register('password', {
                            required: 'Password is required',
                            minLength: {
                                value: 6,
                                message: 'Minimum 6 characters'
                            }
                        })}
                        label="Password"
                        type="password"
                        error={errors.password?.message}
                        placeholder="********"
                    />

                    {error && (
                        <div className="text-red-500 text-sm text-center">{error}</div>
                    )}

                    <Button
                        type="submit"
                        loading={isLoading}
                        className="w-full"
                    >
                        Sign In
                    </Button>

                    <div className="text-center text-sm text-gray-600">
                        Use: admin@example.com / password
                    </div>
                </form>
            </div>
        </div>
    );
};
EOF

echo "✅ Frontend files created successfully"
cd ../..