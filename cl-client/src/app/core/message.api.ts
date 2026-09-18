import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiClient } from './api.client';
import { Message, ThreadSummary } from './models';

interface ThreadsPayload {
  threads: ThreadSummary[];
}

interface ThreadPayload {
  messages: Message[];
}

interface OnePayload {
  message: Message;
}

@Injectable({ providedIn: 'root' })
export class MessageApi {
  private readonly api = inject(ApiClient);

  threads(): Observable<ThreadsPayload> {
    return this.api.get<ThreadsPayload>('/messages');
  }

  thread(userId: number): Observable<ThreadPayload> {
    return this.api.get<ThreadPayload>(`/messages/${userId}`);
  }

  send(receiverId: number, messageText: string): Observable<OnePayload> {
    return this.api.post<OnePayload>('/messages', { receiverId, messageText });
  }
}
