import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClient } from './api.client';
import { Profile } from './models';

interface ProfilePayload {
  profile: Profile;
}

@Injectable({ providedIn: 'root' })
export class ProfileApi {
  private readonly api = inject(ApiClient);

  mine(): Observable<ProfilePayload> {
    return this.api.get<ProfilePayload>('/profiles/me');
  }

  get(userId: number): Observable<ProfilePayload> {
    return this.api.get<ProfilePayload>(`/profiles/${userId}`);
  }

  updateMine(input: { careServices: string; location: string; bio: string }): Observable<ProfilePayload> {
    return this.api.put<ProfilePayload>('/profiles/me', input);
  }
}
