import { Injectable, PLATFORM_ID, inject } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { User } from './models';

const TOKEN_KEY = 'cl.token';
const USER_KEY = 'cl.user';

@Injectable({ providedIn: 'root' })
export class SessionService {
  private readonly browser = isPlatformBrowser(inject(PLATFORM_ID));

  token(): string {
    return this.read(TOKEN_KEY);
  }

  user(): User | null {
    const raw = this.read(USER_KEY);
    if (!raw) {
      return null;
    }
    try {
      return JSON.parse(raw) as User;
    } catch {
      return null;
    }
  }

  isLoggedIn(): boolean {
    return this.token().length > 0;
  }

  setSession(token: string, user: User): void {
    this.write(TOKEN_KEY, token);
    this.write(USER_KEY, JSON.stringify(user));
  }

  clear(): void {
    this.remove(TOKEN_KEY);
    this.remove(USER_KEY);
  }

  private read(key: string): string {
    if (!this.browser) {
      return '';
    }
    return localStorage.getItem(key) ?? '';
  }

  private write(key: string, value: string): void {
    if (this.browser) {
      localStorage.setItem(key, value);
    }
  }

  private remove(key: string): void {
    if (this.browser) {
      localStorage.removeItem(key);
    }
  }
}
