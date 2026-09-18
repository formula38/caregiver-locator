import { Injectable, inject } from '@angular/core';
import { Observable, tap } from 'rxjs';
import { ApiClient } from './api.client';
import { SessionService } from './session.service';
import { User, UserRole } from './models';

interface AuthPayload {
  user: User;
  token: string;
}

interface MePayload {
  user: User;
}

@Injectable({ providedIn: 'root' })
export class AuthApi {
  private readonly api = inject(ApiClient);
  private readonly session = inject(SessionService);

  register(input: {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    role: UserRole;
  }): Observable<AuthPayload> {
    return this.api.post<AuthPayload>('/users/register', input).pipe(
      tap((payload) => this.session.setSession(payload.token, payload.user))
    );
  }

  login(email: string, password: string): Observable<AuthPayload> {
    return this.api.post<AuthPayload>('/users/login', { email, password }).pipe(
      tap((payload) => this.session.setSession(payload.token, payload.user))
    );
  }

  me(): Observable<MePayload> {
    return this.api.get<MePayload>('/users/me');
  }

  logout(): void {
    this.session.clear();
  }
}
