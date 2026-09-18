import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClient } from './api.client';
import { ProviderMatch, SavedMatch } from './models';

interface SearchPayload {
  matches: ProviderMatch[];
}

interface SavedPayload {
  matches: SavedMatch[];
}

interface OneMatchPayload {
  match: SavedMatch;
}

@Injectable({ providedIn: 'root' })
export class MatchApi {
  private readonly api = inject(ApiClient);

  search(requiredCare: string, location: string, rating: number): Observable<SearchPayload> {
    return this.api.get<SearchPayload>('/matches', { requiredCare, location, rating });
  }

  save(providerId: number): Observable<OneMatchPayload> {
    return this.api.post<OneMatchPayload>('/matches', { providerId });
  }

  mine(): Observable<SavedPayload> {
    return this.api.get<SavedPayload>('/matches/mine');
  }

  accept(matchId: number): Observable<OneMatchPayload> {
    return this.api.post<OneMatchPayload>(`/matches/${matchId}/accept`, {});
  }
}
