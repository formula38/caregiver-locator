import { Component, OnInit, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MessageApi } from '../../core/message.api';
import { ThreadSummary } from '../../core/models';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-threads',
  imports: [RouterLink],
  templateUrl: './threads.component.html'
})
export class ThreadsComponent implements OnInit {
  private readonly messages = inject(MessageApi);

  protected error = '';
  protected items: ThreadSummary[] = [];

  ngOnInit(): void {
    this.messages.threads().subscribe({
      next: ({ threads }) => {
        this.items = threads;
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }
}
