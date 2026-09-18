import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { MessageApi } from '../../core/message.api';
import { SessionService } from '../../core/session.service';
import { Message } from '../../core/models';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-thread',
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './thread.component.html'
})
export class ThreadComponent implements OnInit {
  private readonly messages = inject(MessageApi);
  private readonly session = inject(SessionService);
  private readonly route = inject(ActivatedRoute);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected items: Message[] = [];
  protected otherId = 0;
  protected readonly me = this.session.user()?.id ?? 0;
  protected readonly form = this.fb.nonNullable.group({
    messageText: ['', Validators.required]
  });

  ngOnInit(): void {
    this.otherId = Number(this.route.snapshot.paramMap.get('userId'));
    this.reload();
  }

  send(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const text = this.form.controls.messageText.value;
    this.messages.send(this.otherId, text).subscribe({
      next: () => {
        this.form.reset();
        this.reload();
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }

  private reload(): void {
    this.messages.thread(this.otherId).subscribe({
      next: ({ messages }) => {
        this.items = messages;
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }
}
