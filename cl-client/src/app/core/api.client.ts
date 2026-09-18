import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable, map } from 'rxjs';
import { environment } from '../../environments/environment';
import { ApiEnvelope } from './models';

@Injectable({ providedIn: 'root' })
export class ApiClient {
  private readonly http = inject(HttpClient);
  private readonly base = environment.apiUrl;

  get<T>(path: string, params?: Record<string, string | number>): Observable<T> {
    return this.http
      .get<ApiEnvelope<T>>(this.base + path, { params: stringify(params) })
      .pipe(map(unwrap));
  }

  post<T>(path: string, body: unknown): Observable<T> {
    return this.http.post<ApiEnvelope<T>>(this.base + path, body).pipe(map(unwrap));
  }

  put<T>(path: string, body: unknown): Observable<T> {
    return this.http.put<ApiEnvelope<T>>(this.base + path, body).pipe(map(unwrap));
  }
}

export function apiErrorMessage(error: unknown): string {
  if (error instanceof HttpErrorResponse) {
    const body = error.error as ApiEnvelope<unknown> | undefined;
    if (body?.errors?.length) {
      return body.errors.join(' ');
    }
    if (body?.error) {
      return body.error;
    }
    return error.statusText || 'Request failed';
  }
  return 'Request failed';
}

function unwrap<T>(envelope: ApiEnvelope<T>): T {
  if (!envelope?.ok || envelope.data === undefined) {
    throw new Error(envelope?.error || envelope?.errors?.join(' ') || 'Request failed');
  }
  return envelope.data;
}

function stringify(params?: Record<string, string | number>): Record<string, string> | undefined {
  if (!params) {
    return undefined;
  }
  const out: Record<string, string> = {};
  for (const [key, value] of Object.entries(params)) {
    out[key] = String(value);
  }
  return out;
}
