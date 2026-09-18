import { DecimalPipe } from '@angular/common';
import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatchApi } from '../../core/match.api';
import { SessionService } from '../../core/session.service';
import { ProviderMatch } from '../../core/models';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-match-search',
  imports: [ReactiveFormsModule, DecimalPipe],
  templateUrl: './match-search.component.html'
})
export class MatchSearchComponent {
  private readonly matches = inject(MatchApi);
  private readonly session = inject(SessionService);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected notice = '';
  protected pending = false;
  protected results: ProviderMatch[] = [];
  protected readonly isRecipient = this.session.user()?.role === 'recipient';
  protected readonly form = this.fb.nonNullable.group({
    requiredCare: ['personal_care', Validators.required],
    location: ['Oakland', Validators.required],
    rating: [0, Validators.min(0)]
  });

  search(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.pending = true;
    this.error = '';
    this.notice = '';
    const { requiredCare, location, rating } = this.form.getRawValue();
    this.matches.search(requiredCare, location, rating).subscribe({
      next: ({ matches }) => {
        this.pending = false;
        this.results = matches;
      },
      error: (err) => {
        this.pending = false;
        this.error = apiErrorMessage(err);
      }
    });
  }

  save(providerId: number): void {
    this.notice = '';
    this.matches.save(providerId).subscribe({
      next: () => {
        this.notice = 'Match saved.';
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }
}
