import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClient } from './api.client';
import { Review } from './models';

interface ListPayload {
  reviews: Review[];
}

interface OnePayload {
  review: Review;
}

@Injectable({ providedIn: 'root' })
export class ReviewApi {
  private readonly api = inject(ApiClient);

  list(revieweeId?: number): Observable<ListPayload> {
    return revieweeId
      ? this.api.get<ListPayload>('/reviews', { revieweeId })
      : this.api.get<ListPayload>('/reviews');
  }

  create(revieweeId: number, rating: number, comment: string): Observable<OnePayload> {
    return this.api.post<OnePayload>('/reviews', { revieweeId, rating, comment });
  }
}
